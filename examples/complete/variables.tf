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

variable "location" {
  type        = string
  description = "(Optional) Specifies the supported Azure location where the resource exists."
  default     = "eastus"
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
  (Optional) A list of consumer groups and their respective properties."
    list(object({
      name                   = (Required) The name of this Consumer Group.
      resource_group_name    = (Required) The name of the resource group that contains the IoT hub.
      iothub_name            = (Required) The name of the IoT Hub.
      eventhub_endpoint_name = (Required) The name of the Event Hub-compatible endpoint in the IoT hub.
    }))
  EOF
  type = list(object({
    name                   = string
    iothub_name            = string
    eventhub_endpoint_name = string
    resource_group_name    = string
  }))
  default = []
}

//variables required by resource names module
variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
    region     = optional(string, "eastus")
  }))

  default = {
    resource_group = {
      name       = "rg"
      max_length = 80
    }
    iothub = {
      name       = "iothub"
      max_length = 80
    }
    eventhub_namespace = {
      name       = "evthubns"
      max_length = 80
    }
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0
}

variable "logical_product_family" {
  type        = string
  description = "Name of the product family for which the resource is created."
  default     = "launch"
}

variable "logical_product_service" {
  type        = string
  description = "Name of the product service for which the resource is created."

  default = "iothub"
}

variable "class_env" {
  type        = string
  description = "Environment where resource is going to be deployed. For example. dev, qa, uat"
  default     = "dev"
}
