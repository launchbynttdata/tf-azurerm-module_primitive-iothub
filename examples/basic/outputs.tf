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
  value       = module.iothub.id
}

output "name" {
  description = "The IoT Hub Name."
  value       = module.iothub.name
}

output "resource_group_name" {
  description = "The Resource Group Name."
  value       = module.resource_group.name
}

output "hostname" {
  description = "The IoT Hub Hostname."
  value       = module.iothub.hostname
}

output "shared_access_policy_key_name" {
  description = "The IoT Hub Shared Access Policy Key Name."
  value       = module.iothub.shared_access_policy_key_name
}

output "shared_access_policy_permissions" {
  description = "The IoT Hub Shared Access Policy Permisssions."
  value       = module.iothub.shared_access_policy_permissions
}

output "shared_access_policy_primary_key" {
  description = "The IoT Hub Shared Access Policy Primary Key."
  value       = module.iothub.shared_access_policy_primary_key
  sensitive   = true
}

output "shared_access_primary_connection_string" {
  description = "The IoT Hub Shared Access Policy Primary Connection String."
  value       = module.iothub.shared_access_primary_connection_string
  sensitive   = true
}

output "shared_access_policy_secondary_key" {
  description = "The IoT Hub Shared Access Policy Secondary Key."
  value       = module.iothub.shared_access_policy_secondary_key
  sensitive   = true
}

output "shared_access_secondary_connection_string" {
  description = "The IoT Hub Shared Access Policy Secondary Connection String."
  value       = module.iothub.shared_access_secondary_connection_string
  sensitive   = true
}

output "shared_access_policy" {
  description = "The IoT Hub Shared Access Policy."
  value       = module.iothub.shared_access_policy
  sensitive   = true
}
