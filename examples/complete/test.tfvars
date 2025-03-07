# eventhub_endpoints = {
#   "eventhub1" = {
#     connection_string = "Endpoint=sb://eventhub1.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;Shared=TODO"
#   }
# }

# eventhub_authorization_rules = {
#   "eventhub1" = {
#     namespace_name      = module.eventhub_namespace.namespace_name
#     resource_group_name = module.resource_group.name
#     listen              = true
#     send                = true
#     manage              = true
#   }
#   "eventhub2" = {
#     namespace_name      = module.eventhub_namespace.namespace_name
#     resource_group_name = module.resource_group.name
#     listen              = true
#     send                = true
#     manage              = true
#   }
# }

# routes = {
#   "route1" = {
#     custom_endpoint = "custom-endpoint1"
#     condition       = "true"
#     source          = "DeviceMessages"
#     enabled         = true
#   }
# }
