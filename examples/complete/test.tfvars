sku = {
  name     = "S1"
  capacity = 1
}

# endpoints = {
#   endpoint1 = {
#     type                       = "AzureIotHub.StorageContainer"
#     connection_string          = azurerm_storage_account.example.primary_blob_connection_string
#     name                       = "route1"
#     batch_frequency_in_seconds = 60
#     max_chunk_size_in_bytes    = 10485760
#     container_name             = azurerm_storage_container.example.name
#     encoding                   = "Avro"
#     file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
#   }

#   endpoint2 = {
#     type              = "AzureIotHub.EventHub"
#     connection_string = azurerm_eventhub_authorization_rule.example.primary_connection_string
#     name              = "route2"
#   }
# }

# routes = {
#   route1 = {
#     source         = "DeviceMessages"
#     condition      = "true"
#     endpoint_names = ["route1"]
#     enabled        = true
#   }

#   route2 = {
#     source         = "DeviceMessages"
#     condition      = "true"
#     endpoint_names = ["route2"]
#     enabled        = true
#   }
# }

# enrichments = {
#   "eventName1" = {
#     value          = "device_connection"
#     endpoint_names = ["eventhub1-endpt"]
#   }
#   "eventName2" = {
#     value          = "device_connection"
#     endpoint_names = ["eventhub2-endpt"]
#   }
# }

# enrichments = {
#   key            = "tenant"
#   value          = "$twin.tags.Tenant"
#   endpoint_names = ["export", "export2"]
# }

cloud_to_device = {
  max_delivery_count = 30
  default_ttl        = "PT1H"
  feedback = {
    time_to_live       = "PT1H10M"
    max_delivery_count = 15
    lock_duration      = "PT30S"
  }
}

fallback_route = {
  enabled = false
}

consumer_groups = []
