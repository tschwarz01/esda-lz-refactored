keyvaults = {
  synapse_secrets = {
    name                     = "synapsesecrets22"
    resource_group_key       = "synapse_shared"
    sku_name                 = "premium"
    soft_delete_enabled      = true
    purge_protection_enabled = false

    creation_policies = {
      logged_in_user = {
        certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "GetIssuers", "SetIssuers", "ListIssuers", "DeleteIssuers", "ManageIssuers", "Restore", "ManageContacts"]
        secret_permissions      = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        key_permissions         = []
        storage_permissions     = []
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_key_vault"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    private_endpoints = {
      vault = {
        name               = "vaultsynapse1"
        resource_group_key = "synapse_shared"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "vault"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.net"]
        }
      }
    }
  }
  sql_secrets = {
    name                     = "sqlsecrets22"
    resource_group_key       = "metadata"
    sku_name                 = "standard"
    soft_delete_enabled      = true
    purge_protection_enabled = false

    creation_policies = {
      logged_in_user = {
        certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "GetIssuers", "SetIssuers", "ListIssuers", "DeleteIssuers", "ManageIssuers", "Restore", "ManageContacts"]
        secret_permissions      = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        key_permissions         = []
        storage_permissions     = []
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_key_vault"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    private_endpoints = {
      vault = {
        name               = "vaultsql1"
        resource_group_key = "metadata"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "vault"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.net"]
        }
      }
    }
  }
  kv_shir = {
    name               = "kvshir22"
    resource_group_key = "runtimes"
    sku_name           = "standard"
    #enable_rbac_authorization = true
    soft_delete_enabled      = true
    purge_protection_enabled = false
    creation_policies = {
      logged_in_user = {
        #object_id               = "6405df78-1204-44e2-b0d2-6666c8d83f71"
        certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "GetIssuers", "SetIssuers", "ListIssuers", "DeleteIssuers", "ManageIssuers", "Restore", "ManageContacts"]
        secret_permissions      = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        key_permissions         = []
        storage_permissions     = []
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_key_vault"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    private_endpoints = {
      vault = {
        name               = "vault"
        resource_group_key = "runtimes"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "vault"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.net"]
        }
      }
    }
  }
  kv_ingestion = {
    name               = "kvingestion22"
    resource_group_key = "metadata"
    sku_name           = "standard"
    #enable_rbac_authorization = true
    soft_delete_enabled      = true
    purge_protection_enabled = false
    creation_policies = {
      logged_in_user = {
        #object_id               = "6405df78-1204-44e2-b0d2-6666c8d83f71"
        certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover", "GetIssuers", "SetIssuers", "ListIssuers", "DeleteIssuers", "ManageIssuers", "Restore", "ManageContacts"]
        secret_permissions      = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        key_permissions         = []
        storage_permissions     = []
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_key_vault"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    private_endpoints = {
      vault = {
        name               = "vault"
        resource_group_key = "metadata"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        private_service_connection = {
          name                 = "vault"
          is_manual_connection = false
          subresource_names    = ["vault"]
        }
        private_dns = {
          zone_group_name = "default"
          keys            = ["privatelink.vaultcore.azure.net"]
        }
      }
    }
  }
}

managed_identities = {
  vmssadf = {
    name               = "vmssadf"
    resource_group_key = "runtimes"
  }
}

role_mapping = {
  built_in_role_mapping = {
    storage_accounts = {
      development_storage = {
        "Storage Blob Data Contributor" = {
          synapse_workspaces = {
            keys = ["synapse_workspace_shared"]
          }
        }
      }
    }
  }
}


dynamic_keyvault_secrets = {
  kv_shir = {
    shirKey = {
      # this secret is retrieved automatically from the module run output
      secret_name   = "shir-auth-key"
      output_key    = "data_factory_integration_runtime_self_hosted"
      resource_key  = "dfirsh1"
      attribute_key = "primary_authorization_key"
    }
  }
}
