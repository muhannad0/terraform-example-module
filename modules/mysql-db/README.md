# AWS RDS MySQL Module
This is an example Terraform module that deploys an RDS MySQL instance to AWS.

## Deploy Notes
+ The RDS instance is deployed with the default settings.
+ The RDS instance is deployed to the default VPC of the selected region.

## Usage
+ Refer to the [examples](../../examples) folder for an example how the module can be used in other configurations.

## Inputs
| Name | Description | Required | Type | Default Value |
| ---- | ----------- | -------- | ---- | ------------- |
| identifier | Unique identifier for the database. | Yes | String | *none* |
| name | Name of the database to create. | Yes | String | *none* |
| username | Administrator username for the database. | Yes | String | *none* |
| password | Password for the administrator user of the database. | Yes | String | *none* |
| port | Port on which database service is running | No | Number | 3306 |

## Outputs
| Name | Description |
| ---- | ----------- |
| db_address | DNS address of the database service |
| db_port | Port on which database service is running |
| db_security_group_id | The security group ID of the database service |
