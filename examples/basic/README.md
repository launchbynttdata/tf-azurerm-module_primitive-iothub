# tf-azurerm-module_primitive-iothub

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_iothub"></a> [iothub](#module\_iothub) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Optional) Specifies the supported Azure location where the resource exists. | `string` | `"eastus"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) The sku specified for the IoT Hub. | <pre>object({<br/>    name     = string<br/>    capacity = number<br/>  })</pre> | <pre>{<br/>  "capacity": 1,<br/>  "name": "S1"<br/>}</pre> | no |
| <a name="input_consumer_groups"></a> [consumer\_groups](#input\_consumer\_groups) | (Optional) A map of consumer groups and its respective property."<br/>    map(object({<br/>      name (as map key)      = (Required) The name of this Consumer Group.<br/>      eventhub\_endpoint\_name = (Required) The name of the Event Hub-compatible endpoint in the IoT hub.<br/>    })) | <pre>map(object({<br/>    eventhub_endpoint_name = string<br/>    resource_group_name    = string<br/>  }))</pre> | `{}` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>    region     = optional(string, "eastus")<br/>  }))</pre> | <pre>{<br/>  "iothub": {<br/>    "max_length": 80,<br/>    "name": "iothub"<br/>  },<br/>  "resource_group": {<br/>    "max_length": 80,<br/>    "name": "rg"<br/>  }<br/>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Name of the product family for which the resource is created. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Name of the product service for which the resource is created. | `string` | `"iothub"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The IoT Hub Id. |
| <a name="output_name"></a> [name](#output\_name) | The IoT Hub Name. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The Resource Group Name. |
| <a name="output_default_connection_string"></a> [default\_connection\_string](#output\_default\_connection\_string) | The IoT Hub Connection String. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
