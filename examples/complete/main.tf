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

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = local.resource_group
  location = var.location
  tags = {
    resource_name = local.resource_group
  }
}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  region                  = var.location
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}

module "eventhub_namespace" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/eventhub_namespace/azurerm"
  version = "~> 1.0"

  resource_group_name           = module.resource_group.name
  location                      = var.location
  namespace_name                = module.resource_names["eventhub_namespace"].minimal_random_suffix
  public_network_access_enabled = local.public_network_access_enabled
  tags = {
    resource_name = local.resource_group
  }
}

module "eventhub" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/eventhub/azurerm"
  version = "~> 1.0"

  for_each            = toset(local.eventhubs)
  eventhub_name       = each.key
  namespace_name      = module.eventhub_namespace.namespace_name
  resource_group_name = module.resource_group.name
}

resource "azurerm_eventhub_authorization_rule" "authz_rules" {
  for_each            = toset(local.eventhubs)
  name                = each.key
  namespace_name      = module.eventhub_namespace.namespace_name
  eventhub_name       = module.eventhub[each.key].eventhub_name
  resource_group_name = module.resource_group.name

  listen = true
  send   = false
  manage = false
}

module "iothub" {
  source = "../.."

  name                = local.iothub_name
  location            = var.location
  resource_group_name = module.resource_group.name
  sku                 = var.sku
  # endpoints           = var.endpoints
  endpoints = [
    {
      type              = "AzureIotHub.EventHub"
      connection_string = azurerm_eventhub_authorization_rule.authz_rules[local.eventhubs[0]].primary_connection_string
      name              = local.eventhubs[0]
    }
  ]
  fallback_route   = var.fallback_route
  file_uploads     = var.file_uploads
  identity         = var.identity
  network_rule_set = var.network_rule_set
  # routes           = var.routes
  routes = {
    route1 = {
      source         = "DeviceMessages"
      condition      = "true"
      endpoint_names = local.eventhubs
      enabled        = true
    }
  }
  # enrichments = var.enrichments
  enrichments = {
    enrichment1 = {
      key            = "tenant"
      value          = "$twin.tags.Tenant"
      endpoint_names = local.eventhubs
    }
  }

  cloud_to_device = var.cloud_to_device
  consumer_groups = var.consumer_groups

}
