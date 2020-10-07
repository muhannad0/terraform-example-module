# Web Application Example with MySQL
This folder contains a Terraform configuration that shows an example of how to use the [web-app module](../../modules/web-app) to deploy a sample web application cluster on AWS along with the [MySQL database module](../../modules/mysql-db).

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
| web_app_dns | DNS address of the web application service |

*Note: This example will deploy real resources to your AWS account. We have made every effort so that the resources qualify for [AWS Free Tier](https://aws.amazon.com/free/), but we are not responsible for any charges you may incur.*