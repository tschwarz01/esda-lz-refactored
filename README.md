## notes

### Must be deployed after the [management zone](https://github.com/tschwarz01/esda-mz-refactored)

### Requires updating values for the following resources:
**_configuration.auto.tfvars**
- network resource id for the connectivity hub virtual network & network resource id for the management zone virtual network

**_diagnostics.auto.tfvars**  
- log analytics workspace resource id for the management zone LAW instance
- storage_account_resource_id (two instances) within the diagnostics_destinations configuration object.  These should be populated with the storage account resource ids for the diagnostic_storage_accounts created in the logging resource group within the data management landing zone.

### Requires resources module.  

From project root:
- `git clone https://github.com/tschwarz01/terraform-custom-caf-module resources`


### Gaps
- CICD (GHA Worflow / ADO Pipeline)
- Azure Policy
- Realistic IAM implementation
- Room for improvement re: monitor diagnostic settings
- Meta db for Databricks is present; however, cluster(s) will not automatically leverage the db
- The ingestion framework data factory, which shares the VMSS used by the 'integration' data factory's self-hosted integration runtime, is not consistently deploying on the first execution.  It should perhaps be omitted from initial release of the template until a resolution is found. 
- **Need to implement example "data product" using separate tf deployment"**


### Potential Errors

The deployment will create multiple Azure Data Factory and Self-Hosted Integration Runtime instances.  Additionally, a two-node VM Scale Set will be provisioned, upon which a script will be executed to register the virtual machines with one of the Self-Hosted Integration Runtimes.  Late in the deployment, the second Self-Hosted Integration Runtime will attempt to become a shared runtime by associating itself with the first Self-Hosted Runtime & underlying VMSS compute.  This last step has been producing the following error:

```
│ Error: creating/updating Data Factory Self-Hosted Integration Runtime: (Name "rsat-adf-ingestion-lfyg" / Factory Name "rsat-adf-ingestion-instance-hvji" / Resource Group "rsat-rg-metadata-ingestion-ubtq"): datafactory.IntegrationRuntimesClient#CreateOrUpdate: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="SharableIntegrationRuntimeUnSupportVersion" Message="Integration runtime 'rsat-adf-shared-fytj' sharing failed. Either your shared integration runtime is not registered or the version is lower than 3.8. Please register a new node or update your self-hosted integration runtime to latest version respectively."
```

If the error is encountered, running `terraform plan` followed by `terraform apply` a second time will succeed without error and the full deployment will be complete at that time.