diagnostic_log_analytics = {
  databricks_monitoring = {
    region             = "region1"
    name               = "databricks-monitoring"
    resource_group_key = "databricks_monitoring"
  }
}

diagnostic_storage_accounts = {
  # Stores boot diagnostic for region1
  bootdiag1 = {
    name                     = "bootdiag1"
    resource_group_key       = "mgmt"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
  }
}

diagnostics_destinations = {
  # Storage keys must reference the azure region name
  # For storage, reference "all_regions" and we will send the logs to the storage account
  # in the region of the deployment

  log_analytics = {
    central_logs = {
      workspace_id              = "a95b50c0-6010-4f27-984d-ab2aa9bfd7e5"
      log_analytics_resource_id = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/qjam-rg-logging-and-management-kvxm/providers/Microsoft.OperationalInsights/workspaces/qjam-log-logs-vpbh"
    }
  }

  # use existing storage account
  storage = {
    all_regions = {
      southcentralus = {
        storage_account_resource_id = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/qjam-rg-logging-and-management-kvxm/providers/Microsoft.Storage/storageAccounts/qjamstdiaglogsre1vpwb"
      }
      centralus = {
        storage_account_resource_id = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/qjam-rg-logging-and-management-kvxm/providers/Microsoft.Storage/storageAccounts/qjamstdiaglogsre2lbje"
      }
    }
  }
}

diagnostics_definition = {
  log_analytics = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["Audit", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  default_all = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  bastion_host = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["BastionAuditLogs", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  networking_all = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["VMProtectionAlerts", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  public_ip_address = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["DDoSProtectionNotifications", true, false, 7],
        ["DDoSMitigationFlowLogs", true, false, 7],
        ["DDoSMitigationReports", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  load_balancer = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        ["LoadBalancerAlertEvent", true, false, 7],
        ["LoadBalancerProbeHealthStatus", true, false, 7],
      ]
      metric = [
        ["AllMetrics", true, false, 7]
      ]
    }
  }

  network_security_group = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["NetworkSecurityGroupEvent", true, false, 7],
        ["NetworkSecurityGroupRuleCounter", true, false, 7],
      ]
    }
  }

  network_interface_card = {
    name = "operational_logs_and_metrics"
    categories = {
      # log = [
      #   # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #   ["AuditEvent", true, false, 7],
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  private_dns_zone = {
    name = "operational_logs_and_metrics"
    categories = {
      # log = [
      #   # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #   ["AuditEvent", true, false, 7],
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_container_registry = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ContainerRegistryRepositoryEvents", true, false, 7],
        ["ContainerRegistryLoginEvents", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_key_vault = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, false, 7],
        ["AzurePolicyEvaluationDetails", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_data_factory = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ActivityRuns", true, false, 7],
        ["PipelineRuns", true, false, 7],
        ["TriggerRuns", true, false, 7],
        ["SandboxPipelineRuns", true, false, 7],
        ["SandboxActivityRuns", true, false, 7],
        ["SSISPackageEventMessages", true, false, 7],
        ["SSISPackageExecutableStatistics", true, false, 7],
        ["SSISPackageEventMessageContext", true, false, 7],
        ["SSISPackageExecutionComponentPhases", true, false, 7],
        ["SSISPackageExecutionDataStatistics", true, false, 7],
        ["SSISIntegrationRuntimeLogs", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  purview_account = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ScanStatusLogEvent", true, false, 7],
        ["DataSensitivityLogEvent", true, false, 7],
        ["Security", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_kubernetes_cluster = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["kube-apiserver", true, false, 7],
        ["kube-audit", true, false, 7],
        ["kube-audit-admin", true, false, 7],
        ["kube-controller-manager", true, false, 7],
        ["kube-scheduler", true, false, 7],
        ["cluster-autoscaler", true, false, 7],
        ["guard", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  azure_site_recovery = {
    name                           = "operational_logs_and_metrics"
    log_analytics_destination_type = "Dedicated"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AzureBackupReport", true, true, 7],
        ["CoreAzureBackup", true, true, 7],
        ["AddonAzureBackupAlerts", true, true, 7],
        ["AddonAzureBackupJobs", true, true, 7],
        ["AddonAzureBackupPolicy", true, true, 7],
        ["AddonAzureBackupProtectedInstance", true, true, 7],
        ["AddonAzureBackupStorage", true, true, 7],
        ["AzureSiteRecoveryJobs", true, true, 7],
        ["AzureSiteRecoveryEvents", true, true, 7],
        ["AzureSiteRecoveryReplicatedItems", true, true, 7],
        ["AzureSiteRecoveryReplicationStats", true, true, 7],
        ["AzureSiteRecoveryRecoveryPoints", true, true, 7],
        ["AzureSiteRecoveryReplicationDataUploadRate", true, true, 7],
        ["AzureSiteRecoveryProtectedDiskDataChurn", true, true, 30],
      ]
      metric = [
        #["AllMetrics", 60, True],
      ]
    }
  }

  azure_automation = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["JobLogs", true, true, 30],
        ["JobStreams", true, true, 30],
        ["DscNodeStatus", true, true, 30],
      ]
      metric = [
        # ["Category name",  "Metric Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, true, 30],
      ]
    }
  }

  event_hub_namespace = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ArchiveLogs", true, false, 7],
        ["OperationalLogs", true, false, 7],
        ["AutoScaleLogs", true, false, 7],
        ["KafkaCoordinatorLogs", true, false, 7],
        ["KafkaUserErrorLogs", true, false, 7],
        ["EventHubVNetConnectionEvent", true, false, 7],
        ["CustomerManagedKeyUserLogs", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }

  compliance_all = {
    name = "compliance_logs"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, true, 365],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", false, false, 7],
      ]
    }
  }

  siem_all = {
    name = "siem"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", true, true, 0],
      ]

      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", false, false, 0],
      ]
    }
  }

  subscription_operations = {
    name = "subscription_operations"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)"]
        ["Administrative", true],
        ["Security", true],
        ["ServiceHealth", true],
        ["Alert", true],
        ["Policy", true],
        ["Autoscale", true],
        ["ResourceHealth", true],
        ["Recommendation", true],
      ]
    }
  }

  subscription_siem = {
    name = "activity_logs_for_siem"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)"]
        ["Administrative", false],
        ["Security", true],
        ["ServiceHealth", false],
        ["Alert", false],
        ["Policy", true],
        ["Autoscale", false],
        ["ResourceHealth", false],
        ["Recommendation", false],
      ]
    }
  }
}


