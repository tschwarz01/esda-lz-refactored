keyvaults = {
  synapse_secrets = {
    name                = "synapsesecrets"
    resource_group_key  = "synapse_shared"
    sku_name            = "premium"
    soft_delete_enabled = true

    creation_policies = {
      logged_in_user = {
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }
}

role_mapping = {
  built_in_role_mapping = {
    storage_accounts = {
      synapse_shared_storage = {
        "Storage Blob Data Contributor" = {
          synapse_workspaces = {
            keys = ["synapse_workspace_shared"]
          }
        }
      }
    }
  }
}
