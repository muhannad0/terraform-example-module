# AWS Web Application Module
This is an example Terraform module that deploys an sample web application cluster to AWS.

## Deploy Notes
+ The web application is deployed as an ASG cluster, along with an ALB.
+ The ASG cluster and ALB is deployed to the default VPC of the selected region.

## Usage
+ Refer to the [examples](../../examples) folder for an example how the module can be used in other configurations.

## Inputs
| Name | Description | Required | Type | Default Value |
| ---- | ----------- | -------- | ---- | ------------- |
| environment | The deploy environment. | Yes | String | *none* |
| instance_type | The type of instance to deploy (eg: t2.micro). | Yes | String | *none* |
| min_size | The minimum number of instances to run in the cluster. | Yes | Number | *none* |
| max_size | The maximum number of instances to run in the cluster. | Yes | Number | *none* |
| desired_capacity | The desired number of instances to run in the cluster. | Yes | Number | *none* |
| enable_autoscaling | Enable or disable autoscaling based on pre-defined rules. | No | Bool | False |
| server_port | Port on which the web application service is running | No | Number | 8080 |
| server_text | Custom text to be displayed on the main web page. | No | String | Hello World Default |

## Outputs
| Name | Description |
| ---- | ----------- |
| web_app_dns | DNS address of the web application service |
