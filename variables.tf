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

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the IoT Hub."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which the the IoT Hub is created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists."
}

variable "local_authentication_enabled" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether or not local authentication is enabled or not. Defaults to true."
  default     = true
}

variable "event_hub_partition_count" {
  type        = number
  description = "(Optional) The number of device-to-cloud partitions used by backing event hubs. Must be between 2 and 128. Defaults to 4."
  validation {
    condition     = var.event_hub_partition_count >= 2 && var.event_hub_partition_count <= 128
    error_message = "Must be between 2 and 128."
  }
  default = 4
}

variable "event_hub_retention_in_days" {
  type        = number
  description = "(Optional) The event hub retention to use in days. Must be between 1 and 7. Defaults to 1."
  validation {
    condition     = var.event_hub_retention_in_days >= 1 && var.event_hub_retention_in_days <= 7
    error_message = "Must be between 1 and 7."
  }
  default = 1
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Is the IotHub resource accessible from a public network? Defaults to true."
  default     = true
}

variable "min_tls_version" {
  type        = string
  description = "(Optional) Specifies the minimum TLS version to support for this hub. The only valid value is 1.2. Changing this forces a new resource to be created."
  default     = null
}

variable "sku" {
  description = <<EOF
  (Required) The sku specified for the IoT Hub.
  object({
    name = (Required) The name of the sku. Possible values are B1, B2, B3, F1, S1, S2, and S3. Defaults to S1.
    capacity = (Required) The number of provisioned IoT Hub units. Defaults to 1.
  })
  EOF
  type = object({
    name     = string
    capacity = number
  })
  validation {
    condition     = contains(["B1", "B2", "B3", "F1", "S1", "S2", "S3"], var.sku.name)
    error_message = "Must be either `B1`, `B2`, `B3`, `F1`, `S1`, `S2`, or `S3`."
  }
  default = {
    name     = "S1"
    capacity = 1
  }
}

variable "endpoints" {
  description = <<EOF
  (Optional) A map of endpoints and their respective properties."
    map(object({
      name (as map key)              = (Required) The name of the endpoint. The name must be unique across endpoint types. The following names are reserved: events, operationsMonitoringEvents, fileNotifications and $default.
      type                       = (Required) The type of the endpoint. Possible values are AzureIotHub.StorageContainer, AzureIotHub.ServiceBusQueue, AzureIotHub.ServiceBusTopic or AzureIotHub.EventHub.
      connection_string          = (Optional) The connection string for the endpoint. This attribute is mandatory and can only be specified when authentication_type is keyBased.
      authentication_type        = (Optional) The type used to authenticate against the endpoint. Possible values are keyBased and identityBased. Defaults to keyBased.
      identity_id                = (Optional) The ID of the User Managed Identity used to authenticate against the endpoint.
      endpoint_uri               = (Optional) URI of the Service Bus or Event Hubs Namespace endpoint. This attribute can only be specified and is mandatory when authentication_type is identityBased for endpoint type AzureIotHub.ServiceBusQueue, AzureIotHub.ServiceBusTopic or AzureIotHub.EventHub.
      entity_path                = (Optional) Name of the Service Bus Queue/Topic or Event Hub. This attribute can only be specified and is mandatory when authentication_type is identityBased for endpoint type AzureIotHub.ServiceBusQueue, AzureIotHub.ServiceBusTopic or AzureIotHub.EventHub.
      batch_frequency_in_seconds = (Optional) Time interval at which blobs are written to storage. Value should be between 60 and 720 seconds. Default value is 300 seconds. This attribute is applicable for endpoint type AzureIotHub.StorageContainer.
      max_chunk_size_in_bytes    = (Optional) Maximum number of bytes for each blob written to storage. Value should be between 10485760(10MB) and 524288000(500MB). Default value is 314572800(300MB). This attribute is applicable for endpoint type AzureIotHub.StorageContainer.
      container_name             = (Optional) The name of storage container in the storage account. This attribute is mandatory for endpoint type AzureIotHub.StorageContainer.
      encoding                   = (Optional) Encoding that is used to serialize messages to blobs. Supported values are Avro, AvroDeflate and JSON. Default value is Avro. This attribute is applicable for endpoint type AzureIotHub.StorageContainer. Changing this forces a new resource to be created.
      file_name_format           = (Optional) File name format for the blob. All parameters are mandatory but can be reordered. This attribute is applicable for endpoint type AzureIotHub.StorageContainer. Defaults to {iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}.
      resource_group_name        = (Optional) The resource group in which the endpoint will be created.
    }))
  EOF
  type = map(object({
    type                       = string
    connection_string          = optional(string)
    authentication_type        = optional(string)
    identity_id                = optional(string)
    endpoint_uri               = optional(string)
    entity_path                = optional(string)
    batch_frequency_in_seconds = optional(number)
    max_chunk_size_in_bytes    = optional(number)
    container_name             = optional(string)
    encoding                   = optional(string)
    file_name_format           = optional(string)
    resource_group_name        = optional(string)
  }))
  default = {}
}

variable "fallback_route" {
  description = <<EOF
  (Optional) A map of fallback route properties. The routing rule that is evaluated as a catch-all route when no other routes match.
    object({
      source         = (Optional) The source that the routing rule is to be applied to. Possible values include: Invalid, DeviceMessages, TwinChangeEvents, DeviceLifecycleEvents, DeviceConnectionStateEvents, DeviceJobLifecycleEvents and DigitalTwinChangeEvents. Defaults to DeviceMessages.
      condition      = (Optional) The condition that is evaluated to apply the routing rule. Defaults to true. For grammar, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language.
      endpoint_names = (Optional) The endpoints to which messages that satisfy the condition are routed. Currently only 1 endpoint is allowed.
      enabled        = (Optional) Used to specify whether the fallback route is enabled.
    })
  EOF
  type = object({
    source         = optional(string)
    condition      = optional(string)
    endpoint_names = optional(list(string))
    enabled        = optional(bool)
  })
  default = null
}

variable "file_uploads" {
  description = <<EOF
  (Optional) A mapping of file upload properties.
    map(object({
      connection_string   = (Required) The connection string for the Azure Storage account to which files are uploaded.
      container_name      = (Required) The name of the root container where the files should be uploaded to. The container need not exist but should be creatable using the connection_string specified.
      authentication_type = (Optional) The type used to authenticate against the storage account. Possible values are keyBased and identityBased. Defaults to keyBased.
      identity_id         = (Optional) The ID of the User Managed Identity used to authenticate against the storage account.
      sas_ttl             = (Optional) The period of time for which the SAS URI generated by IoT Hub for file upload is valid, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 24 hours. Defaults to PT1H.
      notifications       = (Optional) Used to specify whether file notifications are sent to IoT Hub on upload. Defaults to false.
      lock_duration       = (Optional) The lock duration for the file upload notifications queue, specified as an ISO 8601 timespan duration. This value must be between 5 and 300 seconds. Defaults to PT1M.
      default_ttl         = (Optional) The period of time for which a file upload notification message is available to consume before it expires, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 48 hours. Defaults to PT1H.
      max_delivery_count  = (Optional) The number of times the IoT Hub attempts to deliver a file upload notification message. Defaults to 10.
    }))
  EOF
  type = map(object({
    connection_string   = string
    container_name      = string
    authentication_type = optional(string)
    identity_id         = optional(string)
    sas_ttl             = optional(string)
    notifications       = optional(bool)
    lock_duration       = optional(string)
    default_ttl         = optional(string)
    max_delivery_count  = optional(number)
  }))
  default = {}
}

variable "identity" {
  description = <<EOF
  (Optional) The identity configured for the IoT Hub.
    object({
      identity_type = (Optional) Specifies the type of Managed Service Identity configured on this IoT Hub.
        Possible values are `SystemAssigned`, `UserAssigned`, and `SystemAssigned, UserAssigned` (to enable both). Defaults to `SystemAssigned`."
      identity_ids  = (Optional) A list of User Assigned Managed Service Identity IDs to associate with the IoT Hub. Required if `identity_type` is set to `UserAssigned`.
    })
  EOF
  type = object({
    identity_type = string
    identity_ids  = optional(list(string))
  })
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.identity_type)
    error_message = "`identity_type`'s possible values are `SystemAssigned`, `UserAssigned`, and `SystemAssigned, UserAssigned`."
  }
  default = {
    identity_type = "SystemAssigned"
  }
}

variable "network_rule_set" {
  description = <<EOF
  (Optional) An object for cloud-to-device messaging properties.
    object({
      default_action                     = (Optional) Default Action for Network Rule Set. Possible values are Deny, Allow. Defaults to Deny.
      apply_to_builtin_eventhub_endpoint = (Optional) Determines if Network Rule Set is also applied to the BuiltIn EventHub EndPoint of the IotHub. Defaults to false.
      ip_rules = optional(map(object({
        ip_rule_name   = (Required) The name of the IP rule.
        ip_rule_mask   = (Required) The IP address range in CIDR notation for the IP rule.
        ip_rule_action = (Optional) The desired action for requests captured by this rule. Possible values are Allow. Defaults to Allow.
      })))
    })
  EOF
  type = object({
    default_action                     = optional(string)
    apply_to_builtin_eventhub_endpoint = optional(bool)
    ip_rules = optional(map(object({
      ip_rule_name   = string
      ip_rule_mask   = string
      ip_rule_action = optional(string)
    })))
  })
  default = null
}

variable "routes" {
  description = <<EOF
  (Optional) A map of routes and their respective properties
    object({
      name (as map key) = (Required) The name of the route.
      source            = (Required) The source that the routing rule is to be applied to, such as DeviceMessages. Possible values include: Invalid, DeviceMessages, TwinChangeEvents, DeviceLifecycleEvents, DeviceConnectionStateEvents, DeviceJobLifecycleEvents and DigitalTwinChangeEvents.
      endpoint_names    = (Required) The list of endpoints to which messages that satisfy the condition are routed.
      enabled           = (Required) Used to specify whether a route is enabled.
      condition         = (Optional) The condition that is evaluated to apply the routing rule. Defaults to true. For grammar, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language.
    })
  EOF
  type = map(object({
    source         = string
    endpoint_names = list(string)
    enabled        = bool
    condition      = optional(string)
  }))
  default = {}
}

variable "enrichments" {
  description = <<EOF
  (Optional) A map of enrichments and their respective properties
    object({
      key (as map key) = (Required) The key of the enrichment.
      value            = (Required) The value of the enrichment. Value can be any static string, the name of the IoT Hub sending the message (use $iothubname) or information from the device twin (ex: $twin.tags.latitude)
      endpoint_names   = (Required) The list of endpoints which will be enriched.
    })
  EOF
  type = map(object({
    value          = string
    endpoint_names = list(string)
  }))
  default = {}
}

variable "cloud_to_device" {
  description = <<EOF
  (Optional) An object for cloud-to-device messaging properties.
    object({
      max_delivery_count = (Optional) The maximum delivery count for cloud-to-device per-device queues. This value must be between 1 and 100. Defaults to 10.
      default_ttl        = (Optional) The default time to live for cloud-to-device messages, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 48 hours. Defaults to PT1H.
      feedback = object({
        time_to_live       = (Optional) The retention time for service-bound feedback messages, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 48 hours. Defaults to PT1H.
        max_delivery_count = (Optional) The maximum delivery count for the feedback queue. This value must be between 1 and 100. Defaults to 10.
        lock_duration      = (Optional) The lock duration for the feedback queue, specified as an ISO 8601 timespan duration. This value must be between 5 and 300 seconds. Defaults to PT60S.
    })
  EOF
  type = object({
    max_delivery_count = number
    default_ttl        = string
    feedback = object({
      time_to_live       = string
      max_delivery_count = number
      lock_duration      = string
    })
  })
  default = null
}

variable "consumer_groups" {
  description = <<EOF
  (Optional) A map of consumer groups and its respective property."
    map(object({
      name (as map key)      = (Required) The name of this Consumer Group.
      eventhub_endpoint_name = (Required) The name of the Event Hub-compatible endpoint in the IoT hub.
    }))
  EOF
  type = map(object({
    eventhub_endpoint_name = string
  }))
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}
