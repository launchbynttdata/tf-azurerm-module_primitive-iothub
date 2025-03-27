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

output "id" {
  description = "The IoT Hub Id."
  value       = azurerm_iothub.instance.id
}

output "name" {
  description = "The IoT Hub Name."
  value       = azurerm_iothub.instance.name
}

output "hostname" {
  description = "The IoT Hub Shared Access Hostname."
  value       = azurerm_iothub.instance.hostname
}

output "shared_access_policy_key_name" {
  description = "The IoT Hub Shared Access Policy Key Name."
  value       = azurerm_iothub.instance.shared_access_policy[0].key_name
}

output "shared_access_policy_permissions" {
  description = "The IoT Hub Shared Access Policy Permisssions."
  value       = azurerm_iothub.instance.shared_access_policy[0].permissions
}

output "shared_access_policy_primary_key" {
  description = "The IoT Hub Shared Access Policy Primary Key."
  value       = azurerm_iothub.instance.shared_access_policy[0].primary_key
  sensitive   = true
}

output "shared_access_primary_connection_string" {
  description = "The IoT Hub Shared Access Primary Connection String."
  value       = "HostName=${azurerm_iothub.instance.hostname};SharedAccessKeyName=${azurerm_iothub.instance.shared_access_policy[0].key_name};SharedAccessKey=${azurerm_iothub.instance.shared_access_policy[0].primary_key}"
  sensitive   = true
}

output "shared_access_policy_secondary_key" {
  description = "The IoT Hub Shared Access Policy Secondary Key."
  value       = azurerm_iothub.instance.shared_access_policy[0].secondary_key
  sensitive   = true
}

output "shared_access_secondary_connection_string" {
  description = "The IoT Hub Shared Access Secondary Connection String."
  value       = "HostName=${azurerm_iothub.instance.hostname};SharedAccessKeyName=${azurerm_iothub.instance.shared_access_policy[0].key_name};SharedAccessKey=${azurerm_iothub.instance.shared_access_policy[0].secondary_key}"
  sensitive   = true
}

output "shared_access_policy" {
  description = "The IoT Hub Shared Access Policy."
  value       = azurerm_iothub.instance.shared_access_policy
  sensitive   = true
}
