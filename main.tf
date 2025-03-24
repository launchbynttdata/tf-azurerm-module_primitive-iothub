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
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  local_authentication_enabled  = var.local_authentication_enabled
  event_hub_partition_count     = var.event_hub_partition_count
  event_hub_retention_in_days   = var.event_hub_retention_in_days
  public_network_access_enabled = var.public_network_access_enabled
  min_tls_version               = var.min_tls_version

  sku {
    name     = var.sku.name
    capacity = var.sku.capacity
  }

  dynamic "endpoint" {
    for_each = var.endpoints
    content {
      name                       = endpoint.key
      type                       = endpoint.value.type
      connection_string          = endpoint.value.connection_string
      authentication_type        = endpoint.value.authentication_type
      identity_id                = endpoint.value.identity_id
      endpoint_uri               = endpoint.value.endpoint_uri
      entity_path                = endpoint.value.entity_path
      batch_frequency_in_seconds = endpoint.value.batch_frequency_in_seconds
      max_chunk_size_in_bytes    = endpoint.value.max_chunk_size_in_bytes
      container_name             = endpoint.value.container_name
      encoding                   = endpoint.value.encoding
      file_name_format           = endpoint.value.file_name_format
      resource_group_name        = endpoint.value.resource_group_name
    }
  }

  dynamic "fallback_route" {
    for_each = var.fallback_route != null ? [var.fallback_route] : []
    content {
      source         = fallback_route.value.source
      condition      = fallback_route.value.condition
      endpoint_names = fallback_route.value.endpoint_names
      enabled        = fallback_route.value.enabled
    }
  }

  dynamic "file_upload" {
    for_each = var.file_uploads
    content {
      connection_string   = file_upload.value.connection_string
      container_name      = file_upload.value.container_name
      authentication_type = file_upload.value["authentication_type"]
      identity_id         = file_upload.value["identity_id"]
      sas_ttl             = file_upload.value["sas_ttl"]
      notifications       = file_upload.value["notifications"]
      lock_duration       = file_upload.value["lock_duration"]
      default_ttl         = file_upload.value["default_ttl"]
      max_delivery_count  = file_upload.value["max_delivery_count"]
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.identity_type
      identity_ids = identity.value["identity_ids"]
    }
  }

  dynamic "network_rule_set" {
    for_each = var.network_rule_set != null ? [var.network_rule_set] : []
    content {
      default_action                     = network_rule_set.value.default_action
      apply_to_builtin_eventhub_endpoint = network_rule_set.value.apply_to_builtin_eventhub_endpoint
      dynamic "ip_rule" {
        for_each = network_rule_set.value["ip_rule"] != null ? network_rule_set.value["ip_rule"] : {}
        content {
          ip_mask = ip_rule.value.ip_rule_mask
          name    = ip_rule.key
          action  = ip_rule.value["ip_rule_action"] == null ? "Allow" : ip_rule.value["ip_rule_action"]
        }
      }
    }
  }

  dynamic "route" {
    for_each = var.routes
    content {
      name           = route.key
      source         = route.value.source
      condition      = route.value.condition
      endpoint_names = route.value.endpoint_names
      enabled        = route.value.enabled
    }
  }

  dynamic "enrichment" {
    for_each = var.enrichments
    content {
      key            = enrichment.key
      value          = enrichment.value.value
      endpoint_names = enrichment.value.endpoint_names
    }
  }

  dynamic "cloud_to_device" {
    for_each = var.cloud_to_device != null ? [var.cloud_to_device] : []
    content {
      max_delivery_count = cloud_to_device.value.max_delivery_count
      default_ttl        = cloud_to_device.value.default_ttl
      feedback {
        time_to_live       = cloud_to_device.value.feedback.time_to_live
        max_delivery_count = cloud_to_device.value.feedback.max_delivery_count
        lock_duration      = cloud_to_device.value.feedback.lock_duration
      }
    }
  }

  tags = local.tags
}

resource "azurerm_iothub_consumer_group" "consumer_groups" {
  for_each               = var.consumer_groups
  name                   = each.key
  resource_group_name    = var.resource_group_name
  iothub_name            = azurerm_iothub.instance.name
  eventhub_endpoint_name = each.value.eventhub_endpoint_name
}
