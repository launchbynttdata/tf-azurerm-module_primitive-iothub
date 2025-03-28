# tf-azurerm-module_primitive-iothub

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

Manages an Azure IoT Hub.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_iothub.instance](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub) | resource |
| [azurerm_iothub_consumer_group.consumer_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub_consumer_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the IoT Hub. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which the the IoT Hub is created. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| <a name="input_local_authentication_enabled"></a> [local\_authentication\_enabled](#input\_local\_authentication\_enabled) | (Optional) Boolean flag to specify whether or not local authentication is enabled or not. Defaults to true. | `bool` | `true` | no |
| <a name="input_event_hub_partition_count"></a> [event\_hub\_partition\_count](#input\_event\_hub\_partition\_count) | (Optional) The number of device-to-cloud partitions used by backing event hubs. Must be between 2 and 128. Defaults to 4. | `number` | `4` | no |
| <a name="input_event_hub_retention_in_days"></a> [event\_hub\_retention\_in\_days](#input\_event\_hub\_retention\_in\_days) | (Optional) The event hub retention to use in days. Must be between 1 and 7. Defaults to 1. | `number` | `1` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Is the IotHub resource accessible from a public network? Defaults to true. | `bool` | `true` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | (Optional) Specifies the minimum TLS version to support for this hub. The only valid value is 1.2. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) The sku specified for the IoT Hub.<br/>  object({<br/>    name = (Required) The name of the sku. Possible values are B1, B2, B3, F1, S1, S2, and S3. Defaults to S1.<br/>    capacity = (Required) The number of provisioned IoT Hub units. Defaults to 1.<br/>  }) | <pre>object({<br/>    name     = string<br/>    capacity = number<br/>  })</pre> | <pre>{<br/>  "capacity": 1,<br/>  "name": "S1"<br/>}</pre> | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | (Optional) A map of endpoints and their respective properties."<br/>    map(object({<br/>      name (as map key)              = (Required) The name of the endpoint. The name must be unique across endpoint types. The following names are reserved: events, operationsMonitoringEvents, fileNotifications and $default.<br/>      type                       = (Required) The type of the endpoint. Possible values are AzureIotHub.StorageContainer, AzureIotHub.ServiceBusQueue, AzureIotHub.ServiceBusTopic or AzureIotHub.EventHub.<br/>      connection\_string          = (Optional) The connection string for the endpoint. This attribute is mandatory and can only be specified when authentication\_type is keyBased.<br/>      authentication\_type        = (Optional) The type used to authenticate against the endpoint. Possible values are keyBased and identityBased. Defaults to keyBased.<br/>      identity\_id                = (Optional) The ID of the User Managed Identity used to authenticate against the endpoint.<br/>      endpoint\_uri               = (Optional) URI of the Service Bus or Event Hubs Namespace endpoint. This attribute can only be specified and is mandatory when authentication\_type is identityBased for endpoint type AzureIotHub.ServiceBusQueue, AzureIotHub.ServiceBusTopic or AzureIotHub.EventHub.<br/>      entity\_path                = (Optional) Name of the Service Bus Queue/Topic or Event Hub. This attribute can only be specified and is mandatory when authentication\_type is identityBased for endpoint type AzureIotHub.ServiceBusQueue, AzureIotHub.ServiceBusTopic or AzureIotHub.EventHub.<br/>      batch\_frequency\_in\_seconds = (Optional) Time interval at which blobs are written to storage. Value should be between 60 and 720 seconds. Default value is 300 seconds. This attribute is applicable for endpoint type AzureIotHub.StorageContainer.<br/>      max\_chunk\_size\_in\_bytes    = (Optional) Maximum number of bytes for each blob written to storage. Value should be between 10485760(10MB) and 524288000(500MB). Default value is 314572800(300MB). This attribute is applicable for endpoint type AzureIotHub.StorageContainer.<br/>      container\_name             = (Optional) The name of storage container in the storage account. This attribute is mandatory for endpoint type AzureIotHub.StorageContainer.<br/>      encoding                   = (Optional) Encoding that is used to serialize messages to blobs. Supported values are Avro, AvroDeflate and JSON. Default value is Avro. This attribute is applicable for endpoint type AzureIotHub.StorageContainer. Changing this forces a new resource to be created.<br/>      file\_name\_format           = (Optional) File name format for the blob. All parameters are mandatory but can be reordered. This attribute is applicable for endpoint type AzureIotHub.StorageContainer. Defaults to {iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}.<br/>      resource\_group\_name        = (Optional) The resource group in which the endpoint will be created.<br/>    })) | <pre>map(object({<br/>    type                       = string<br/>    connection_string          = optional(string)<br/>    authentication_type        = optional(string)<br/>    identity_id                = optional(string)<br/>    endpoint_uri               = optional(string)<br/>    entity_path                = optional(string)<br/>    batch_frequency_in_seconds = optional(number)<br/>    max_chunk_size_in_bytes    = optional(number)<br/>    container_name             = optional(string)<br/>    encoding                   = optional(string)<br/>    file_name_format           = optional(string)<br/>    resource_group_name        = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_fallback_route"></a> [fallback\_route](#input\_fallback\_route) | (Optional) A map of fallback route properties. The routing rule that is evaluated as a catch-all route when no other routes match.<br/>    object({<br/>      source         = (Optional) The source that the routing rule is to be applied to. Possible values include: Invalid, DeviceMessages, TwinChangeEvents, DeviceLifecycleEvents, DeviceConnectionStateEvents, DeviceJobLifecycleEvents and DigitalTwinChangeEvents. Defaults to DeviceMessages.<br/>      condition      = (Optional) The condition that is evaluated to apply the routing rule. Defaults to true. For grammar, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language.<br/>      endpoint\_names = (Optional) The endpoints to which messages that satisfy the condition are routed. Currently only 1 endpoint is allowed.<br/>      enabled        = (Optional) Used to specify whether the fallback route is enabled.<br/>    }) | <pre>object({<br/>    source         = optional(string)<br/>    condition      = optional(string)<br/>    endpoint_names = optional(list(string))<br/>    enabled        = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_file_uploads"></a> [file\_uploads](#input\_file\_uploads) | (Optional) A mapping of file upload properties.<br/>    map(object({<br/>      connection\_string   = (Required) The connection string for the Azure Storage account to which files are uploaded.<br/>      container\_name      = (Required) The name of the root container where the files should be uploaded to. The container need not exist but should be creatable using the connection\_string specified.<br/>      authentication\_type = (Optional) The type used to authenticate against the storage account. Possible values are keyBased and identityBased. Defaults to keyBased.<br/>      identity\_id         = (Optional) The ID of the User Managed Identity used to authenticate against the storage account.<br/>      sas\_ttl             = (Optional) The period of time for which the SAS URI generated by IoT Hub for file upload is valid, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 24 hours. Defaults to PT1H.<br/>      notifications       = (Optional) Used to specify whether file notifications are sent to IoT Hub on upload. Defaults to false.<br/>      lock\_duration       = (Optional) The lock duration for the file upload notifications queue, specified as an ISO 8601 timespan duration. This value must be between 5 and 300 seconds. Defaults to PT1M.<br/>      default\_ttl         = (Optional) The period of time for which a file upload notification message is available to consume before it expires, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 48 hours. Defaults to PT1H.<br/>      max\_delivery\_count  = (Optional) The number of times the IoT Hub attempts to deliver a file upload notification message. Defaults to 10.<br/>    })) | <pre>map(object({<br/>    connection_string   = string<br/>    container_name      = string<br/>    authentication_type = optional(string)<br/>    identity_id         = optional(string)<br/>    sas_ttl             = optional(string)<br/>    notifications       = optional(bool)<br/>    lock_duration       = optional(string)<br/>    default_ttl         = optional(string)<br/>    max_delivery_count  = optional(number)<br/>  }))</pre> | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) The identity configured for the IoT Hub.<br/>    object({<br/>      identity\_type = (Optional) Specifies the type of Managed Service Identity configured on this IoT Hub.<br/>        Possible values are `SystemAssigned`, `UserAssigned`, and `SystemAssigned, UserAssigned` (to enable both). Defaults to `SystemAssigned`."<br/>      identity\_ids  = (Optional) A list of User Assigned Managed Service Identity IDs to associate with the IoT Hub. Required if `identity_type` is set to `UserAssigned`.<br/>    }) | <pre>object({<br/>    identity_type = string<br/>    identity_ids  = optional(list(string))<br/>  })</pre> | <pre>{<br/>  "identity_type": "SystemAssigned"<br/>}</pre> | no |
| <a name="input_network_rule_set"></a> [network\_rule\_set](#input\_network\_rule\_set) | (Optional) An object for cloud-to-device messaging properties.<br/>    object({<br/>      default\_action                     = (Optional) Default Action for Network Rule Set. Possible values are Deny, Allow. Defaults to Deny.<br/>      apply\_to\_builtin\_eventhub\_endpoint = (Optional) Determines if Network Rule Set is also applied to the BuiltIn EventHub EndPoint of the IotHub. Defaults to false.<br/>      ip\_rules = optional(map(object({<br/>        ip\_rule\_name   = (Required) The name of the IP rule.<br/>        ip\_rule\_mask   = (Required) The IP address range in CIDR notation for the IP rule.<br/>        ip\_rule\_action = (Optional) The desired action for requests captured by this rule. Possible values are Allow. Defaults to Allow.<br/>      })))<br/>    }) | <pre>object({<br/>    default_action                     = optional(string)<br/>    apply_to_builtin_eventhub_endpoint = optional(bool)<br/>    ip_rules = optional(map(object({<br/>      ip_rule_name   = string<br/>      ip_rule_mask   = string<br/>      ip_rule_action = optional(string)<br/>    })))<br/>  })</pre> | `null` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | (Optional) A map of routes and their respective properties<br/>    object({<br/>      name (as map key) = (Required) The name of the route.<br/>      source            = (Required) The source that the routing rule is to be applied to, such as DeviceMessages. Possible values include: Invalid, DeviceMessages, TwinChangeEvents, DeviceLifecycleEvents, DeviceConnectionStateEvents, DeviceJobLifecycleEvents and DigitalTwinChangeEvents.<br/>      endpoint\_names    = (Required) The list of endpoints to which messages that satisfy the condition are routed.<br/>      enabled           = (Required) Used to specify whether a route is enabled.<br/>      condition         = (Optional) The condition that is evaluated to apply the routing rule. Defaults to true. For grammar, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language.<br/>    }) | <pre>map(object({<br/>    source         = string<br/>    endpoint_names = list(string)<br/>    enabled        = bool<br/>    condition      = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_enrichments"></a> [enrichments](#input\_enrichments) | (Optional) A map of enrichments and their respective properties<br/>    object({<br/>      key (as map key) = (Required) The key of the enrichment.<br/>      value            = (Required) The value of the enrichment. Value can be any static string, the name of the IoT Hub sending the message (use $iothubname) or information from the device twin (ex: $twin.tags.latitude)<br/>      endpoint\_names   = (Required) The list of endpoints which will be enriched.<br/>    }) | <pre>map(object({<br/>    value          = string<br/>    endpoint_names = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_cloud_to_device"></a> [cloud\_to\_device](#input\_cloud\_to\_device) | (Optional) An object for cloud-to-device messaging properties.<br/>    object({<br/>      max\_delivery\_count = (Optional) The maximum delivery count for cloud-to-device per-device queues. This value must be between 1 and 100. Defaults to 10.<br/>      default\_ttl        = (Optional) The default time to live for cloud-to-device messages, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 48 hours. Defaults to PT1H.<br/>      feedback = object({<br/>        time\_to\_live       = (Optional) The retention time for service-bound feedback messages, specified as an ISO 8601 timespan duration. This value must be between 1 minute and 48 hours. Defaults to PT1H.<br/>        max\_delivery\_count = (Optional) The maximum delivery count for the feedback queue. This value must be between 1 and 100. Defaults to 10.<br/>        lock\_duration      = (Optional) The lock duration for the feedback queue, specified as an ISO 8601 timespan duration. This value must be between 5 and 300 seconds. Defaults to PT60S.<br/>    }) | <pre>object({<br/>    max_delivery_count = number<br/>    default_ttl        = string<br/>    feedback = object({<br/>      time_to_live       = string<br/>      max_delivery_count = number<br/>      lock_duration      = string<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_consumer_groups"></a> [consumer\_groups](#input\_consumer\_groups) | (Optional) A map of consumer groups and its respective property."<br/>    map(object({<br/>      name (as map key)      = (Required) The name of this Consumer Group.<br/>      eventhub\_endpoint\_name = (Required) The name of the Event Hub-compatible endpoint in the IoT hub.<br/>    })) | <pre>map(object({<br/>    eventhub_endpoint_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The IoT Hub Id. |
| <a name="output_name"></a> [name](#output\_name) | The IoT Hub Name. |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | The IoT Hub Shared Access Hostname. |
| <a name="output_shared_access_policy_key_name"></a> [shared\_access\_policy\_key\_name](#output\_shared\_access\_policy\_key\_name) | The IoT Hub Shared Access Policy Key Name. |
| <a name="output_shared_access_policy_permissions"></a> [shared\_access\_policy\_permissions](#output\_shared\_access\_policy\_permissions) | The IoT Hub Shared Access Policy Permisssions. |
| <a name="output_shared_access_policy_primary_key"></a> [shared\_access\_policy\_primary\_key](#output\_shared\_access\_policy\_primary\_key) | The IoT Hub Shared Access Policy Primary Key. |
| <a name="output_shared_access_primary_connection_string"></a> [shared\_access\_primary\_connection\_string](#output\_shared\_access\_primary\_connection\_string) | The IoT Hub Shared Access Primary Connection String. |
| <a name="output_shared_access_policy_secondary_key"></a> [shared\_access\_policy\_secondary\_key](#output\_shared\_access\_policy\_secondary\_key) | The IoT Hub Shared Access Policy Secondary Key. |
| <a name="output_shared_access_secondary_connection_string"></a> [shared\_access\_secondary\_connection\_string](#output\_shared\_access\_secondary\_connection\_string) | The IoT Hub Shared Access Secondary Connection String. |
| <a name="output_shared_access_policy"></a> [shared\_access\_policy](#output\_shared\_access\_policy) | The IoT Hub Shared Access Policy. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
