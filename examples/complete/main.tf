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

  resource_group_name = module.resource_group.name
  location            = var.location
  namespace_name      = module.resource_names["eventhub_namespace"].minimal_random_suffix
  tags = {
    resource_name = local.resource_group
  }
}

module "iothub" {
  source = "../.."

  name                         = local.iothub_name
  location                     = var.location
  resource_group_name          = module.resource_group.name
  sku                          = var.sku
  capacity                     = var.capacity
  local_authentication_enabled = var.local_authentication_enabled
  identity_type                = var.identity_type

  eventhub_endpoints           = var.eventhub_endpoints
  eventhub_authorization_rules = var.eventhub_authorization_rules
  routes                       = var.routes

  # eventhub_endpoints = {
  #   "eventhub1" = {
  #     connection_string = "Endpoint=sb://eventhub1.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;Shared=TODO"
  #   }
  # }

  # eventhub_authorization_rules = {
  #   "eventhub1" = {
  #     namespace_name      = module.eventhub_namespace.namespace_name
  #     resource_group_name = module.resource_group.name
  #     listen              = true
  #     send                = true
  #     manage              = true
  #   }
  #   "eventhub2" = {
  #     namespace_name      = module.eventhub_namespace.namespace_name
  #     resource_group_name = module.resource_group.name
  #     listen              = true
  #     send                = true
  #     manage              = true
  #   }
  # }

  # routes = {
  #   "route1" = {
  #     custom_endpoint = "custom-endpoint1"
  #     condition       = "true"
  #     source          = "DeviceMessages"
  #     enabled         = true
  #   }
  # }

  depends_on = [module.resource_group]
}
