terraform {
  required_providers {

  }
  backend "azurerm" {
    subscription_id      = "47f7e6d7-0e52-4394-92cb-5f106bbc647f"
    tenant_id            = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    resource_group_name  = "rg-data-management-zone-terraform"
    storage_account_name = "stgdatamgmtzoneterraform"
    container_name       = "esda-lz-refactored"
    key                  = "esda-lz-refactored.tfstate"
    #use_azuread_auth     = true
  }
  required_version = ">= 0.15"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_client_config" "default" {}



module "esa-dlz" {
  #source                   = "./resources"
  source                   = "github.com/tschwarz01/terraform-custom-caf-module"
  global_settings          = var.global_settings
  common_module_params     = local.common_module_params
  resource_groups          = var.resource_groups
  keyvaults                = var.keyvaults
  keyvault_access_policies = var.keyvault_access_policies
  managed_identities       = var.managed_identities
  storage_accounts         = var.storage_accounts
  role_mapping             = var.role_mapping

  networking = {
    vnets                             = var.vnets
    vnet_peerings_v1                  = var.vnet_peerings_v1
    network_security_group_definition = var.network_security_group_definition
    application_security_groups       = var.application_security_groups
    public_ip_addresses               = var.public_ip_addresses
    load_balancers                    = var.load_balancers
    synapse_privatelink_hubs          = var.synapse_privatelink_hubs
    private_dns_vnet_links            = local.private_dns_vnet_links
    #private_dns                       = try(var.private_dns.zones, {})
  }

  compute = {
    virtual_machine_scale_sets                            = var.virtual_machine_scale_sets
    vmss_extensions_custom_script_adf_integration_runtime = var.vmss_extensions_custom_script_adf_integration_runtime
    bastion_hosts                                         = var.bastion_hosts
  }

  data_factory = {
    data_factory                                        = var.data_factory
    data_factory_integration_runtime_self_hosted        = var.data_factory_integration_runtime_self_hosted
    data_factory_integration_runtime_shared_self_hosted = var.data_factory_integration_runtime_shared_self_hosted
  }

  database = {
    databricks_workspaces = var.databricks_workspaces
    synapse_workspaces    = var.synapse_workspaces
    mssql_servers         = var.mssql_servers
    mssql_databases       = var.mssql_databases
  }

  remote_objects = {
    private_dns = local.remote_private_dns_zones
  }

  diagnostics = {
    diagnostic_log_analytics    = var.diagnostic_log_analytics
    diagnostics_destinations    = var.diagnostics_destinations
    diagnostics_definition      = var.diagnostics_definition
    diagnostic_storage_accounts = var.diagnostic_storage_accounts
  }

  security = {
    dynamic_keyvault_secrets = var.dynamic_keyvault_secrets
  }
}
