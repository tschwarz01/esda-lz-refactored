## notes

### Must be deployed after the [management zone](https://github.com/tschwarz01/esda-mz-refactored)

### Requires updating values for the following resources:
- **_configuration.auto.tfvars**: network resource id for the connectivity hub virtual network & network resource id for the management zone virtual network
- **_diagnostics.auto.tfvars**: log analytics workspace resource id for the management zone LAW instance

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
