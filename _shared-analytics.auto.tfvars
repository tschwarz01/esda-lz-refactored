databricks_workspaces = {
  shared_workspace = {
    name                                  = "dbricks-shared-ws"
    resource_group_key                    = "databricks_shared"
    sku                                   = "standard"
    public_network_access_enabled         = true
    network_security_group_rules_required = "AllRules"

    custom_parameters = {
      no_public_ip       = true
      public_subnet_key  = "shared_databricks_pub"
      private_subnet_key = "shared_databricks_pri"
      vnet_key           = "lz_vnet_region1"
    }
  }
}


synapse_workspaces = {
  synapse_workspace_shared = {
    name                    = "synapse-shared-ws"
    resource_group_key      = "synapse_shared"
    sql_administrator_login = "dbadmin"
    # sql_administrator_login_password = "<string password>"   # If not set use module autogenerate a strong password and stores it in the keyvault
    keyvault_key                    = "synapse_secrets"
    managed_virtual_network_enabled = true
    data_encrypted                  = true
    tags                            = {}

    # Uncomment to add a dedicated SQL Pool to the Synapse deployment
    /*    synapse_sql_pools = {
      shared_synapse_sql_pool = {
        name                  = "synpoolshared"
        synapse_workspace_key = "synapse_workspace_shared"
        sku_name              = "DW100c"
        create_mode           = "Default"
      }
    }*/
    # Uncomment to add a spark pool to the Synapse deployment
    /*    synapse_spark_pools = {
      shared_synapse_spark_pool = {
        name                  = "synsparkpoolshared" #[name can contain only letters or numbers, must start with a letter, and be between 1 and 15 characters long]
        synapse_workspace_key = "synapse_workspace_shared"
        node_size_family      = "MemoryOptimized" # Only current option
        node_size             = "Small"           # Small, Medium, Large, XLarge, XXLarge
        cache_size            = 20                # Percentage of disk to reserve for cache
        spark_version         = "3.1"
        auto_scale = {
          max_node_count = 50 # Maximum = 200, or auto_scale
          min_node_count = 3  # Minimum = 3, or auto_scale
        }
        auto_pause = {
          delay_in_minutes = 15
        }
        tags = {
          environment = "example tag"
        }
      }
    }*/
    aad_admin = {
      login     = "thosch@microsoft.com"
      object_id = "6405df78-1204-44e2-b0d2-6666c8d83f71"
      tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    }
    sql_aad_admin = {
      login     = "thosch@microsoft.com"
      object_id = "6405df78-1204-44e2-b0d2-6666c8d83f71"
      tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    }
    data_lake_filesystem = {
      storage_account_key = "development_storage"
      container_key       = "synaspe_filesystem"
    }
    private_endpoints = {
      # Require enforce_private_link_endpoint_network_policies set to true on the subnet
      sql = {
        name               = "sharedsynapsesql"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "synapse_shared"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "sharedsynapsesql"
          is_manual_connection = false
          subresource_names    = ["Sql"]
        }
        private_dns = {
          zone_group_name = "privatelink.sql.azuresynapse.net"
          keys            = ["privatelink.sql.azuresynapse.net"]
        }
      }
      sqlod = {
        name               = "sharedsynapsesqlod"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "synapse_shared"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "sharedsynapsesqlod"
          is_manual_connection = false
          subresource_names    = ["SqlOnDemand"]
        }
        private_dns = {
          zone_group_name = "privatelink.sql.azuresynapse.net"
          keys            = ["privatelink.sql.azuresynapse.net"]
        }
      }
      dev = {
        name               = "sharedsynapsedev"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "synapse_shared"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "sharedsynapsedev"
          is_manual_connection = false
          subresource_names    = ["Dev"]
        }
        private_dns = {
          zone_group_name = "privatelink.dev.azuresynapse.net"
          keys            = ["privatelink.dev.azuresynapse.net"]
        }
      }
    }
  }
}
