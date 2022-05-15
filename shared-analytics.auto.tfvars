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

