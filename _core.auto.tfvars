
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
      name          = "dlz-networking"
      address_space = ["10.69.8.0/21"]
    }
    subnets = {
      shared_databricks_pub = {
        name          = "databricks-pub-shared"
        cidr          = ["10.69.8.0/25"]
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
        cidr          = ["10.69.8.128/25"]
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
        cidr          = ["10.69.9.0/24"]
        should_create = true
      }
      private_endpoints = {
        name                                           = "private-endpoints"
        cidr                                           = ["10.69.10.0/24"]
        enforce_private_link_endpoint_network_policies = true
        should_create                                  = true
      }
      bastion = {
        name          = "AzureBastionSubnet"
        cidr          = ["10.69.11.0/25"]
        should_create = true
        nsg_key       = "azure_bastion_nsg"
      }
      gateway = {
        name          = "data-gateway"
        cidr          = ["10.69.11.128/26"]
        should_create = true
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
        cidr          = ["10.69.11.192/26"]
        should_create = true
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

network_watchers = {
  network_watcher_1 = {
    name               = "nwatcher_scus"
    resource_group_key = "lz_vnet_region1"
    region             = "region1"
  }
}

vnet_peerings_v1 = {
  lz_to_hub = {
    name = "dlz_to_region1_hub"
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
    name = "region1_hub_to_dlz"
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
  lz_to_dmz = {
    name = "lz_to_dmz"
    from = {
      vnet_key = "lz_vnet_region1"
    }
    to = {
      id = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/qjam-rg-networking-xuvk/providers/Microsoft.Network/virtualNetworks/qjam-vnet-dmlz-networking-kqdi"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
  dmz_to_lz = {
    name = "dmz_to_dlz"
    from = {
      id = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/qjam-rg-networking-xuvk/providers/Microsoft.Network/virtualNetworks/qjam-vnet-dmlz-networking-kqdi"
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

public_ip_addresses = {
  bastion_host = {
    name                    = "bastion-pip1"
    resource_group_key      = "mgmt"
    sku                     = "Standard"
    allocation_method       = "Static"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"
  }
  lb_pip1 = {
    name               = "lb_pip1"
    resource_group_key = "runtimes"
    sku                = "Basic"
    # Note: For UltraPerformance ExpressRoute Virtual Network gateway, the associated Public IP needs to be sku "Basic" not "Standard"
    allocation_method = "Dynamic"
    # allocation method needs to be Dynamic
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"
  }
}

# Application security groups
application_security_groups = {
  app_sg1 = {
    resource_group_key = "runtimes"
    name               = "app_sg1"

  }
}

load_balancers = {
  lb-vmss = {
    name                      = "lb-vmss"
    sku                       = "Basic"
    resource_group_key        = "runtimes"
    backend_address_pool_name = "vmss1"
    frontend_ip_configurations = {
      config1 = {
        name                  = "config1"
        public_ip_address_key = "lb_pip1"
      }
    }
    probes = {
      probe1 = {
        resource_group_key = "runtimes"
        load_balancer_key  = "lb-vmss"
        probe_name         = "rdp"
        port               = "3389"
      }
    }
    lb_rules = {
      rule1 = {
        resource_group_key             = "runtimes"
        load_balancer_key              = "lb-vmss"
        lb_rule_name                   = "rule1"
        protocol                       = "Tcp"
        probe_id_key                   = "probe1"
        frontend_port                  = "3389"
        backend_port                   = "3389"
        frontend_ip_configuration_name = "config1" #name must match the configuration that's defined in the load_balancers block.
      }
    }
  }
}

tags = {
  Owner   = "Cloud Scale Analytics Scenario"
  Project = "Cloud Scale Analytics Scneario"
  Toolkit = "Terraform"
}

bastion_hosts = {
  bastion_hub = {
    name               = "lz_bastion-001"
    region             = "region1"
    resource_group_key = "mgmt"
    vnet_key           = "lz_vnet_region1"
    subnet_key         = "bastion"
    public_ip_key      = "bastion_host"

    # you can setup up to 5 profiles
    diagnostic_profiles = {
      operations = {
        definition_key   = "bastion_host"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
  }
}

network_security_group_definition = {
  empty_nsg = {
    version            = 1
    resource_group_key = "network"
    name               = "empty_nsg"

    /*
    flow_logs = {
      version = 2
      enabled = true
      storage_account = {
        storage_account_destination = "all_regions"
        retention = {
          enabled = true
          days    = 30
        }
      }
      traffic_analytics = {
        enabled                             = true
        log_analytics_workspace_destination = "central_logs"
        interval_in_minutes                 = "10"
      }
    }
    */
    diagnostic_profiles = {
      nsg = {
        definition_key   = "network_security_group"
        destination_type = "storage"
        destination_key  = "all_regions"
      }
      operations = {
        name             = "operations"
        definition_key   = "network_security_group"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
    nsg = []
  }

  databricks_pub = {
    resource_group_key = "network"
    name               = "databricks-pub-nsg"
    diagnostic_profiles = {
      nsg = {
        definition_key   = "network_security_group"
        destination_type = "storage"
        destination_key  = "all_regions"
      }
      operations = {
        name             = "operations"
        definition_key   = "network_security_group"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }

    nsg = []
  }
  databricks_pri = {
    resource_group_key = "network"
    name               = "databricks-pri-nsg"
    diagnostic_profiles = {
      nsg = {
        definition_key   = "network_security_group"
        destination_type = "storage"
        destination_key  = "all_regions"
      }
      operations = {
        name             = "operations"
        definition_key   = "network_security_group"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }

    nsg = []
  }

  azure_bastion_nsg = {
    version            = 1
    resource_group_key = "network"
    name               = "azure_bastion_nsg"
    diagnostic_profiles = {
      nsg = {
        definition_key   = "network_security_group"
        destination_type = "storage"
        destination_key  = "all_regions"
      }
      operations = {
        name             = "operations"
        definition_key   = "network_security_group"
        destination_type = "log_analytics"
        destination_key  = "central_logs"
      }
    }
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

# You will likely want to comment out one of the two sections below
# One allows you to specify that existing private dns zones, likely deployed in a separate subscription, should be used
# The second allows you to define the private dns zones which should be created in the subscription to which you are deploying this template

existing_private_dns = {
  subscription_id     = "c00669a2-37e9-4e0d-8b57-4e8dd0fcdd4a"
  resource_group_name = "rg-scus-pe-lab-network"
  zones_region        = "region1"
  local_vnet_key      = "lz_vnet_region1"
  dns_zones = [
    "privatelink.blob.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com",
    "privatelink.servicebus.windows.net",
    "privatelink.azurecr.io",
    "privatelink.azuresynapse.net",
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net"
  ]
}


