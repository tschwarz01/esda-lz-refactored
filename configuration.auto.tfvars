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
    name          = "mgmt"
    location      = "region1"
    should_create = true
  }
  databricks_monitoring = {
    name          = "databricks-monitoring"
    location      = "region1"
    should_create = true
  }
  network = {
    name          = "network"
    location      = "region1"
    should_create = true
  }
  runtimes = {
    name          = "integration-runtimes"
    location      = "region1"
    should_create = true
  }
  storage = {
    name          = "datalake-storage"
    location      = "region1"
    should_create = true
  }
  hive_metadata = {
    name          = "hive-metadata"
    location      = "region1"
    should_create = true
  }
  external_data = {
    name          = "incoming-external-data"
    location      = "region1"
    should_create = true
  }
  metadata = {
    name          = "metadata-ingestion"
    location      = "region1"
    should_create = true
  }
  databricks_shared = {
    name          = "shared-databricks"
    location      = "region1"
    should_create = true
  }
  synapse_shared = {
    name          = "shared-synapse"
    location      = "region1"
    should_create = true
  }
  data_app001 = {
    name          = "sample-data-product"
    location      = "region1"
    should_create = true
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
            "Microsoft.Network/virtualNetworks/subnets/join/action"
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


vnet_peerings_v1 = {
  lz_to_hub = {
    name = "data_landing_zone_to_scus_connectivity_hub"
    from = {
      vnet_key = "lz_vnet_region1"
    }
    to = {
      id = "/subscriptions/893395a4-65a3-4525-99ea-2378c6e0dbed/resourceGroups/rg-network_connectivity_hub/providers/Microsoft.Network/virtualNetworks/vnet-connectivity_hub"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
  hub_to_lz = {
    name = "scus_connectivity_hub_to_data_landing_zone"
    from = {
      id = "/subscriptions/893395a4-65a3-4525-99ea-2378c6e0dbed/resourceGroups/rg-network_connectivity_hub/providers/Microsoft.Network/virtualNetworks/vnet-connectivity_hub"
    }
    to = {
      vnet_key = "lz_vnet_region1"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
  lz_to_dmlz = {
    name = "data_landing_zone_to_data_management_zone"
    from = {
      vnet_key = "lz_vnet_region1"
    }
    to = {
      id = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/tpff-rg-networking-volh/providers/Microsoft.Network/virtualNetworks/tpff-vnet-dmlz-networking-eema"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
  dmlz_to_lz = {
    name = "data_management_zone_to_data_landing_zone"
    from = {
      id = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/tpff-rg-networking-volh/providers/Microsoft.Network/virtualNetworks/tpff-vnet-dmlz-networking-eema"
    }
    to = {
      vnet_key = "lz_vnet_region1"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}
