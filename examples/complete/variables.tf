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
