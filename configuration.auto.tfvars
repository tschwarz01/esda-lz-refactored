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
      shared_databricks_pub = {
        name          = "databricks-pub-shared"
        cidr          = ["10.50.8.0/25"]
        should_create = true
        nsg_key       = "databricks_pub"
        delegation = {
          name               = "databricks-pub-delegation"
          service_delegation = "Microsoft.Databricks/workspaces"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
          ]
        }
      }
      shared_databricks_pri = {
        name          = "databricks-pri-shared"
        cidr          = ["10.50.8.128/25"]
        should_create = true
        nsg_key       = "databricks_pri"
        delegation = {
          name               = "databricks-pri-delegation"
          service_delegation = "Microsoft.Databricks/workspaces"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
          ]
        }
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
        should_create = true
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

network_security_group_definition = {
  empty_nsg = {
    resource_group_key = "vnet_region1"
    name               = "empty_nsg"

    nsg = []
  }

  databricks_pub = {
    resource_group_key = "network"
    name               = "databricks-pub-nsg"

    nsg = []
  }
  databricks_pri = {
    resource_group_key = "network"
    name               = "databricks-pri-nsg"

    nsg = []
  }

  azure_bastion_nsg = {
    resource_group_key = "network"
    name               = ""
    nsg = [
      {
        name                       = "AllowWebExperienceInBound",
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowControlPlaneInBound",
        priority                   = "110"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowHealthProbesInBound",
        priority                   = "120"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowBastionHostToHostInBound",
        priority                   = "130"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_ranges    = ["8080", "5701"]
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "DenyAllInBound",
        priority                   = "1000"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowSshToVnetOutBound",
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "AllowRdpToVnetOutBound",
        priority                   = "110"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "AllowControlPlaneOutBound",
        priority                   = "120"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "AzureCloud"
      },
      {
        name                       = "AllowBastionHostToHostOutBound",
        priority                   = "130"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["8080", "5701"]
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "AllowBastionCertificateValidationOutBound",
        priority                   = "140"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "Internet"
      },
      {
        name                       = "DenyAllOutBound",
        priority                   = "1000"
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

}
