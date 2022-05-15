synapse_workspaces = {
  synapse_workspace_shared = {
    name                    = "synapse-shared"
    resource_group_key      = "synapse_shared"
    sql_administrator_login = "dbadmin"
    # sql_administrator_login_password = "<string password>"   # If not set use module autogenerate a strong password and stores it in the keyvault
    keyvault_key                    = "synapse_secrets"
    managed_virtual_network_enabled = true
    tags                            = {}

    synapse_sql_pools = {}

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




