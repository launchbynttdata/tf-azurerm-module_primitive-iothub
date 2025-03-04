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

variable "sku" {
  type        = string
  description = "(Optional) Specifies the SKU of the IoT Hub. Possible values are S1, S2, and S3. Defaults to S1."
  default     = "S1"
}

variable "capacity" {
  type        = number
  description = "(Optional) Specifies the number of units in the specified SKU. Defaults to 1."
  default     = 1
}

variable "local_authentication_enabled" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether or not local authentication is enabled or not. Defaults to true."
  default     = true
}

variable "identity_type" {
  type        = string
  description = <<EOT
  (Optional) Specifies the type of Managed Service Identity configured on this IoT Hub.
  Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both). Defaults to `SystemAssigned`."
  EOT
  default     = "SystemAssigned"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}
