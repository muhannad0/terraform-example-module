terraform {
    required_version = ">= 0.12"
}

provider "aws" {
    region = "us-east-1"
}

module "web_app" {
    source = "../../modules/web-app"

    environment = var.environment

    instance_type = var.instance_type
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity

    enable_autoscaling = false

    server_text = "Hello Example v2"
}
