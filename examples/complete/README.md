# tf-azurerm-module_primitive-log_analytics_workspace

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
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) The sku specified for the IoT Hub.<br/>  object({<br/>    name = (Required) The name of the sku. Possible values are B1, B2, B3, F1, S1, S2, and S3. Defaults to S1.<br/>    capacity = (Required) The number of provisioned IoT Hub units. Defaults to 1.<br/>  }) | <pre>object({<br/>    name     = string<br/>    capacity = number<br/>  })</pre> | <pre>{<br/>  "capacity": 1,<br/>  "name": "S1"<br/>}</pre> | no |
| <a name="input_routes"></a> [routes](#input\_routes) | (Optional) A map of routes and their respective properties<br/>    object({<br/>      name (as map key) = (Required) The name of the route.<br/>      source            = (Required) The source that the routing rule is to be applied to, such as DeviceMessages. Possible values include: Invalid, DeviceMessages, TwinChangeEvents, DeviceLifecycleEvents, DeviceConnectionStateEvents, DeviceJobLifecycleEvents and DigitalTwinChangeEvents.<br/>      endpoint\_names    = (Required) The list of endpoints to which messages that satisfy the condition are routed.<br/>      enabled           = (Required) Used to specify whether a route is enabled.<br/>      condition         = (Optional) The condition that is evaluated to apply the routing rule. Defaults to true. For grammar, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language.<br/>    }) | <pre>map(object({<br/>    source         = string<br/>    endpoint_names = list(string)<br/>    enabled        = bool<br/>    condition      = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_enrichments"></a> [enrichments](#input\_enrichments) | (Optional) A map of enrichments and their respective properties<br/>    object({<br/>      key (as map key) = (Required) The key of the enrichment.<br/>      value            = (Required) The value of the enrichment. Value can be any static string, the name of the IoT Hub sending the message (use $iothubname) or information from the device twin (ex: $twin.tags.latitude)<br/>      endpoint\_names   = (Required) The list of endpoints which will be enriched.<br/>    }) | <pre>map(object({<br/>    value          = string<br/>    endpoint_names = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_fallback_route"></a> [fallback\_route](#input\_fallback\_route) | (Optional) A map of fallback route properties. The routing rule that is evaluated as a catch-all route when no other routes match.<br/>    object({<br/>      source         = (Optional) The source that the routing rule is to be applied to. Possible values include: Invalid, DeviceMessages, TwinChangeEvents, DeviceLifecycleEvents, DeviceConnectionStateEvents, DeviceJobLifecycleEvents and DigitalTwinChangeEvents. Defaults to DeviceMessages.<br/>      condition      = (Optional) The condition that is evaluated to apply the routing rule. Defaults to true. For grammar, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language.<br/>      endpoint\_names = (Optional) The endpoints to which messages that satisfy the condition are routed. Currently only 1 endpoint is allowed.<br/>      enabled        = (Optional) Used to specify whether the fallback route is enabled.<br/>    }) | <pre>object({<br/>    source         = optional(string)<br/>    condition      = optional(string)<br/>    endpoint_names = optional(list(string))<br/>    enabled        = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_cloud_to_device"></a> [cloud\_to\_device](#input\_cloud\_to\_device) | (Optional) An object for cloud-to-device messaging properties.<br/>    object({<br/>      max\_delivery\_count = (Optional) The maximum delivery count for cloud-to-device per-device queues. This value must be between 1 and 100. Defaults to 10.<br/>      default\_ttl        = (Optional) The default time to live for cloud-to-device messages, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 48 hours. Defaults to PT1H.<br/>      feedback = object({<br/>        time\_to\_live       = (Optional) The retention time for service-bound feedback messages, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 48 hours. Defaults to PT1H.<br/>        max\_delivery\_count = (Optional) The maximum delivery count for the feedback queue. This value must be between 1 and 100. Defaults to 10.<br/>        lock\_duration      = (Optional) The lock duration for the feedback queue, specified as an ISO 8601 timespan duration. This value must be between 5 and 300 seconds. Defaults to PT60S.<br/>    }) | <pre>object({<br/>    max_delivery_count = number<br/>    default_ttl        = string<br/>    feedback = object({<br/>      time_to_live       = string<br/>      max_delivery_count = number<br/>      lock_duration      = string<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_consumer_groups"></a> [consumer\_groups](#input\_consumer\_groups) | (Optional) A list of consumer groups and their respective properties."<br/>    list(object({<br/>      name                   = (Required) The name of this Consumer Group.<br/>      resource\_group\_name    = (Required) The name of the resource group that contains the IoT hub.<br/>      iothub\_name            = (Required) The name of the IoT Hub.<br/>      eventhub\_endpoint\_name = (Required) The name of the Event Hub-compatible endpoint in the IoT hub.<br/>    })) | <pre>list(object({<br/>    name                   = string<br/>    iothub_name            = string<br/>    eventhub_endpoint_name = string<br/>    resource_group_name    = string<br/>  }))</pre> | `[]` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>    region     = optional(string, "eastus")<br/>  }))</pre> | <pre>{<br/>  "eventhub_namespace": {<br/>    "max_length": 80,<br/>    "name": "evthubns"<br/>  },<br/>  "iothub": {<br/>    "max_length": 80,<br/>    "name": "iothub"<br/>  },<br/>  "resource_group": {<br/>    "max_length": 80,<br/>    "name": "rg"<br/>  }<br/>}</pre> | no |
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
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
