// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

resource "azurerm_iothub" "instance" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  local_authentication_enabled = var.local_authentication_enabled

  sku {
    name     = var.sku
    capacity = var.capacity
  }

  identity {
    type = var.identity_type
  }

  tags = local.tags
}

resource "azurerm_iothub_endpoint_eventhub" "endpoints" {
  for_each            = var.eventhub_endpoints
  resource_group_name = var.resource_group_name
  iothub_id           = azurerm_iothub.instance.id
  name                = each.key
  connection_string   = each.value.connection_string
}

resource "azurerm_eventhub_authorization_rule" "rules" {
  for_each            = var.eventhub_authorization_rules
  name                = each.key
  namespace_name      = each.value.namespace_name
  resource_group_name = each.value.resource_group_name
  eventhub_name       = each.key

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

resource "azurerm_iothub_route" "routes" {
  for_each            = var.routes
  resource_group_name = var.resource_group_name
  iothub_name         = azurerm_iothub.instance.name
  name                = each.key

  source    = each.value.source
  condition = each.value.condition
  endpoint_names = [
    each.value.custom_endpoint
  ]
  enabled = each.value.enabled

  depends_on = [azurerm_iothub_endpoint_eventhub.endpoints]
}
