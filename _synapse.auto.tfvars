synapse_workspaces = {
  synapse_workspace_shared = {
    name                    = "synapse-shared"
    resource_group_key      = "synapse_shared"
    sql_administrator_login = "dbadmin"
    # sql_administrator_login_password = "<string password>"   # If not set use module autogenerate a strong password and stores it in the keyvault
    keyvault_key                    = "synapse_secrets"
    managed_virtual_network_enabled = true
    tags                            = {}
    aad_admin = {
      tws = {
        login     = "thosch@microsoft.com"
        object_id = "6405df78-1204-44e2-b0d2-6666c8d83f71"
        tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
      }
    }
    sql_aad_admin = {
      tws = {
        login     = "thosch@microsoft.com"
        object_id = "6405df78-1204-44e2-b0d2-6666c8d83f71"
        tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
      }
    }
    data_lake_filesystem = {
      storage_account_key = "development_storage"
      container_key       = "synaspe_filesystem"
    }
  }
}




