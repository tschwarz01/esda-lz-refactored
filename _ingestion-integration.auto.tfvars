virtual_machine_scale_sets = {
  vmssshir = {
    resource_group_key                   = "runtimes"
    provision_vm_agent                   = true
    boot_diagnostics_storage_account_key = "bootdiag1"
    os_type                              = "windows"
    keyvault_key                         = "kv_shir"

    vmss_settings = {
      windows = {
        name                            = "shir"
        computer_name_prefix            = "shir"
        sku                             = "Standard_D4d_v4"
        instances                       = 2
        admin_username                  = "adminuser"
        disable_password_authentication = false
        upgrade_mode                    = "Automatic" # Automatic / Rolling / Manual
        priority                        = "Regular"
        #eviction_policy                 = "Deallocate"
        #custom_data                     = "scripts/installSHIRGateway.ps1"

        rolling_upgrade_policy = {
          #   # Only for upgrade mode = "Automatic / Rolling "
          max_batch_instance_percent              = 60
          max_unhealthy_instance_percent          = 60
          max_unhealthy_upgraded_instance_percent = 60
          pause_time_between_batches              = "PT01M"
        }
        automatic_os_upgrade_policy = {
          # Only for upgrade mode = "Automatic"
          disable_automatic_rollback  = false
          enable_automatic_os_upgrade = false
        }

        os_disk = {
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
          disk_size_gb         = 128
        }

        # Uncomment in case the managed_identity_keys are generated locally
        identity = {
          type                  = "UserAssigned"
          managed_identity_keys = ["vmssadf"]
        }

        source_image_reference = {
          publisher = "MicrosoftWindowsServer"
          offer     = "WindowsServer"
          sku       = "2019-Datacenter"
          version   = "latest"
        }

        automatic_instance_repair = {
          enabled      = true
          grace_period = "PT30M" # Use ISO8601 expressions.
        }

        # The health is determined by an exising loadbalancer probe.
        health_probe = {
          loadbalancer_key = "lb-vmss"
          probe_key        = "probe1"
        }

      }
    }

    network_interfaces = {
      nic0 = {
        # Value of the keys from networking.tfvars
        name       = "0"
        primary    = true
        vnet_key   = "lz_vnet_region1"
        subnet_key = "services"
        #subnet_id  = "/subscriptions/97958dac-XXXX-XXXX-XXXX-9f436fa73bd4/resourceGroups/xbvt-rg-vmss-agw-exmp-rg/providers/Microsoft.Network/virtualNetworks/xbvt-vnet-vmss/subnets/xbvt-snet-compute"

        enable_accelerated_networking = false
        enable_ip_forwarding          = false
        internal_dns_name_label       = "nic0"
        load_balancers = {
          lb1 = {
            lb_key = "lb-vmss"
            # lz_key = ""
          }
        }
        application_security_groups = {
          asg1 = {
            asg_key = "app_sg1"
            # lz_key = ""
          }
        }
      }
    }
    ultra_ssd_enabled = false # required if planning to use UltraSSD_LRS

  }
}

vmss_extensions_custom_script_adf_integration_runtime = {

  vmssshir1 = {
    resource_group_key        = "runtimes"
    identity_type             = "SystemAssigned" # optional to use managed_identity for download from location specified in fileuri, UserAssigned or SystemAssigned.
    automatic_upgrade_enabled = false

    integration_runtime_key = "dfirsh1"
    vmss_key                = "vmssshir"
    commandtoexecute        = "powershell.exe -ExecutionPolicy Unrestricted -File installSHIRGateway.ps1 -gatewayKey"
    script_location         = "https://raw.githubusercontent.com/Azure/data-landing-zone/main/code/installSHIRGateway.ps1"
  }

}


data_factory = {
  runtimes = {
    name = "runtime-instance"
    resource_group = {
      key = "runtimes"
    }
    managed_virtual_network_enabled = "true"
    private_endpoints = {
      factory = {
        name               = "int-acct"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "runtimes"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "int-acct"
          is_manual_connection = false
          subresource_names    = ["dataFactory"]
        }
        private_dns = {
          zone_group_name = "privatelink.datafactory.azure.net"
          keys            = ["privatelink.datafactory.azure.net"]
        }
      }
      portal = {
        name               = "int-portal"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "runtimes"
        private_service_connection = {
          name                 = "int-portal"
          is_manual_connection = false
          subresource_names    = ["portal"]
        }
        private_dns = {
          zone_group_name = "privatelink.adf.azure.com"
          keys            = ["privatelink.adf.azure.com"]
        }
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_data_factory"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
  ingestion = {
    name = "ingestion-instance"
    resource_group = {
      key = "metadata"
    }
    enable_system_msi               = true
    managed_virtual_network_enabled = true
    private_endpoints = {
      factory = {
        name               = "ing-acct"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "metadata"
        identity = {
          type         = "SystemAssigned"
          identity_ids = []
        }
        private_service_connection = {
          name                 = "ing-acct"
          is_manual_connection = false
          subresource_names    = ["dataFactory"]
        }
        private_dns = {
          zone_group_name = "privatelink.datafactory.azure.net"
          keys            = ["privatelink.datafactory.azure.net"]
        }
      }
      portal = {
        name               = "ing-portal"
        vnet_key           = "lz_vnet_region1"
        subnet_key         = "private_endpoints"
        resource_group_key = "metadata"
        private_service_connection = {
          name                 = "ing-portal"
          is_manual_connection = false
          subresource_names    = ["portal"]
        }
        private_dns = {
          zone_group_name = "privatelink.adf.azure.com"
          keys            = ["privatelink.adf.azure.com"]
        }
      }
    }
    diagnostic_profiles = {
      central_logs_region1 = {
        definition_key   = "azure_data_factory"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}

data_factory_integration_runtime_self_hosted = {
  dfirsh1 = {
    name = "shared"
    resource_group = {
      key = "runtimes"
    }
    data_factory = {
      #id = "resource id"
      key = "runtimes"
    }
  }

}

data_factory_integration_runtime_shared_self_hosted = {
  dfirsh2 = {
    name = "ingestion"
    resource_group = {
      key = "metadata"
    }
    data_factory = {
      #principal_id = ""
      key = "ingestion"
    }
    host_data_factory = { # Utilize existing Self-Hosted Integration Runtime compute resources (Virtual Machines) associated with a separate Data Factory instance
      #resource_id         = ""         # resource id for data factory containing the self-hosted-integration compute resources (VMs) which you want this new runtime to share
      #runtime_resource_id = ""         # resource id for the self-hosted integration runtime associated with the compute resources which you want this new runtime to share
      key         = "runtimes" # key for data factory containing the self-hosted-integration compute resources (VMs) which you want this new runtime to share
      runtime_key = "dfirsh1"  # key for the self-hosted integration runtime associated with the compute resources which you want this new runtime to share
    }
  }
}

mssql_servers = {
  adf_sql = {
    name                          = "meta-ingestion"
    region                        = "region1"
    resource_group_key            = "metadata"
    administrator_login           = "sqladmin"
    keyvault_key                  = "sql_secrets"
    public_network_access_enabled = false

    identity = {
      type = "SystemAssigned"
    }

    azuread_administrator = {
      login_username = "thosch@microsoft.com"
      object_id      = "6405df78-1204-44e2-b0d2-6666c8d83f71"
      tenant_id      = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    }
  }
  hive_sql = {
    name                          = "hive-meta"
    region                        = "region1"
    resource_group_key            = "hive_metadata"
    administrator_login           = "sqladmin"
    keyvault_key                  = "hive_sql_secrets"
    public_network_access_enabled = false

    identity = {
      type = "SystemAssigned"
    }

    azuread_administrator = {
      login_username = "thosch@microsoft.com"
      object_id      = "6405df78-1204-44e2-b0d2-6666c8d83f71"
      tenant_id      = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    }
  }
}

mssql_databases = {
  mssql_db1 = {
    name               = "adfmeta"
    resource_group_key = "metadata"
    mssql_server_key   = "adf_sql"
    license_type       = "LicenseIncluded"
    max_size_gb        = 4
    sku_name           = "BC_Gen5_2"
  }
  mssql_db2 = {
    name               = "hivemeta"
    resource_group_key = "hive_metadata"
    mssql_server_key   = "hive_sql"
    license_type       = "LicenseIncluded"
    max_size_gb        = 4
    sku_name           = "BC_Gen5_2"
  }
}
