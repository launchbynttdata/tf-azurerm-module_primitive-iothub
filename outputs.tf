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

output "default_connection_string" {
  value     = "HostName=${azurerm_iothub.instance.hostname};SharedAccessKeyName=${azurerm_iothub.instance.shared_access_policy[0].key_name};SharedAccessKey=${azurerm_iothub.instance.shared_access_policy[0].primary_key}"
  sensitive = true
}
