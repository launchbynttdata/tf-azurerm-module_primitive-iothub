sku = {
  name     = "S1"
  capacity = 1
}

# endpoints = {
#   endpoint2 = {
#     type                       = "AzureIotHub.StorageContainer"
#     connection_string          = azurerm_storage_account.example.primary_blob_connection_string
#     name                       = "route1"
#     batch_frequency_in_seconds = 60
#     max_chunk_size_in_bytes    = 10485760
#     container_name             = azurerm_storage_container.example.name
#     encoding                   = "Avro"
#     file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
#   }
#

fallback_route = {
  enabled = false
}

file_uploads = {}

identity = {
  identity_type = "SystemAssigned"
}

network_rule_set = null

cloud_to_device = {
  max_delivery_count = 30
  default_ttl        = "PT1H"
  feedback = {
    time_to_live       = "PT1H10M"
    max_delivery_count = 15
    lock_duration      = "PT30S"
  }
}

consumer_groups = {}
