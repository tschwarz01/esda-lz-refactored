global_settings = {
  passthrough    = false
  random_length  = 4
  default_region = "region1"
  regions = {
    region1 = "southcentralus"
    region2 = "centralus"
  }
}

resource_groups = {
  mgmt = {
    name     = "mgmt"
    location = "region1"
  }
  databricks_monitoring = {
    name     = "databricks-monitoring"
    location = "region1"
  }
  network = {
    name     = "network"
    location = "region1"
  }
  runtimes = {
    name     = "integration-runtimes"
    location = "region1"
  }
  storage = {
    name     = "datalake-storage"
    location = "region1"
  }
  hive_metadata = {
    name     = "hive-metadata"
    location = "region1"
  }
  external_data = {
    name     = "incoming-external-data"
    location = "region1"
  }
  metadata = {
    name     = "metadata-ingestion"
    location = "region1"
  }
  databricks_shared = {
    name     = "shared-databricks"
    location = "region1"
  }
  synapse_shared = {
    name     = "shared-synapse"
    location = "region1"
  }
  data_app001 = {
    name     = "sample-data-product"
    location = "region1"
  }
}


vnets = {
  lz_vnet_region1 = {
    resource_group_key = "network"
    vnet = {
      name          = "dmlz-networking"
      address_space = ["10.50.8.0/21"]
    }
    subnets = {
      shared_databricks_container = {
        name          = "databricks-container-shared"
        cidr          = ["10.50.8.0/25"]
        should_create = false
        nsg_key       = "databricks_container"
      }
      shared_databricks_host = {
        name          = "databricks-host-shared"
        cidr          = ["10.50.8.128/25"]
        should_create = false
        nsg_key       = "databricks_host"
      }
      services = {
        name          = "general-services"
        cidr          = ["10.50.9.0/24"]
        should_create = true
        nsg_key       = "empty_nsg"
      }
      private_endpoints = {
        name                                           = "private-endpoints"
        cidr                                           = ["10.50.10.0/24"]
        enforce_private_link_endpoint_network_policies = true
        should_create                                  = true
        nsg_key                                        = "empty_nsg"
      }
      bastion = {
        name          = "AzureBastionSubnet"
        cidr          = ["10.50.11.0/25"]
        should_create = false
        nsg_key       = "azure_bastion_nsg"
      }
      gateway = {
        name          = "data-gateway"
        cidr          = ["10.50.11.128/26"]
        should_create = true
        nsg_key       = "empty_nsg"
        delegation = {
          name               = "power_platform_data_gateway"
          service_delegation = "Microsoft.PowerPlatform/vnetaccesslinks"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/action"
          ]
        }
      }
      data_app001 = {
        name          = "example-data-product-001"
        cidr          = ["10.50.11.192/26"]
        should_create = true
        nsg_key       = "empty_nsg"
      }
    }
    diagnostic_profiles = {
      operation = {
        definition_key   = "networking_all"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}
