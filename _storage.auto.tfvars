storage_accounts = {
  development_storage = {
    name                     = "synwsandanalyticssandbox"
    resource_group_key       = "storage"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
    is_hns_enabled           = true

    data_lake_filesystems = {
      synaspe_filesystem = {
        name = "synapsefs"
      }
      sandbox_filesystem = {
        name = "analyticssandboxfs"
      }
    }
    private_endpoints = {
      # Require enforce_private_link_endpoint_network_policies set to true on the subnet
      blob = {
        name               = "lake1-adls-blob"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "storage"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "lake1-adls-blob"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "privatelink.blob.core.windows.net"
          keys            = ["privatelink.blob.core.windows.net"]
        }
      }
      dfs = {
        name               = "lake1-dfs-blob"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "storage"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "lake1-dfs-blob"
          is_manual_connection = false
          subresource_names    = ["dfs"]
        }
        private_dns = {
          zone_group_name = "privatelink.dfs.core.windows.net"
          keys            = ["privatelink.dfs.core.windows.net"]
        }
      }
    }
  }
  enriched_curated = {
    name                     = "enrichedcurated"
    resource_group_key       = "synapse_shared"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
    is_hns_enabled           = true

    data_lake_filesystems = {
      enriched = {
        name = "enrichedfs"
      }
      curated = {
        name = "curatedfs"
      }
    }
    private_endpoints = {
      # Require enforce_private_link_endpoint_network_policies set to true on the subnet
      blob = {
        name               = "lake2-adls-blob"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "storage"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "lake2-adls-blob"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "privatelink.blob.core.windows.net"
          keys            = ["privatelink.blob.core.windows.net"]
        }
      }
      dfs = {
        name               = "lake2-dfs-blob"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "storage"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "lake2-dfs-blob"
          is_manual_connection = false
          subresource_names    = ["dfs"]
        }
        private_dns = {
          zone_group_name = "privatelink.dfs.core.windows.net"
          keys            = ["privatelink.dfs.core.windows.net"]
        }
      }
    }
  }
  raw = {
    name                     = "raw"
    resource_group_key       = "synapse_shared"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
    is_hns_enabled           = true

    data_lake_filesystems = {
      landing = {
        name = "rawlanding"
      }
      conformance = {
        name = "rawconformance"
      }
    }
    private_endpoints = {
      # Require enforce_private_link_endpoint_network_policies set to true on the subnet
      blob = {
        name               = "lake3-adls-blob"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "storage"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "lake3-adls-blob"
          is_manual_connection = false
          subresource_names    = ["blob"]
        }
        private_dns = {
          zone_group_name = "privatelink.blob.core.windows.net"
          keys            = ["privatelink.blob.core.windows.net"]
        }
      }
      dfs = {
        name               = "lake3-dfs-blob"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "storage"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "lake3-dfs-blob"
          is_manual_connection = false
          subresource_names    = ["dfs"]
        }
        private_dns = {
          zone_group_name = "privatelink.dfs.core.windows.net"
          keys            = ["privatelink.dfs.core.windows.net"]
        }
      }
    }
  }
}

