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
#     endpoint_names = ["route"]
#     enabled        = true
#   }

#   route2 = {
#     source         = "DeviceMessages"
#     condition      = "true"
#     endpoint_names = ["route2"]
#     enabled        = true
#   }
# }
