# MySQL RDS Example
This folder contains a Terraform configuration that shows an example of how to use the [mysql-db module](../../modules/mysql-db) to deploy a MySQL RDS on AWS.

## Pre-Requisites
+ [Terraform](https://www.terraform.io/downloads.html) 0.12 or higher.
+ AWS account configured.

## Usage
```bash
terraform init
terraform plan
terraform apply

# Cleanup 
terraform destroy
```
## Inputs
n/a

## Outputs
| Name | Description |
| ---- | ----------- |
| db_address | DNS address of the database service |
| db_port | Port on which database service is running |


*Note: This example will deploy real resources to your AWS account. We have made every effort so that the resources qualify for [AWS Free Tier](https://aws.amazon.com/free/), but we are not responsible for any charges you may incur.*