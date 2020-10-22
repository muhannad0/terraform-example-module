terraform {
    required_version = ">= 0.12"
}

provider "aws" {
    region = "us-east-1"
}

module "web_app" {
    source = "../../../modules/web-app"

    environment = var.environment

    instance_type = var.instance_type
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity

    enable_autoscaling = false

    server_text = var.server_text

    mysql_config = module.db

    mysql_credentials = {
      db_name = var.db_name
      db_user = var.db_user
      db_password = var.db_pass
    }
}

module "db" {
    source = "../../../modules/mysql-db"

    identifier = var.environment

    name = var.db_name
    username = var.db_user
    password = var.db_pass
    port = 3306
}
