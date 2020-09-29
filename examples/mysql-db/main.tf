terraform {
    required_version = ">= 0.12"
}

provider "aws" {
    region = "us-east-1"
}

# Select the default VPC
data "aws_vpc" "default" {
    # count = var.vpc_id == null ? 1 : 0
    default = true
}

# Get the subnets in the default VPC
data "aws_subnet_ids" "all" {
    # count = var.subnet_ids == null ? 1 : 0
    vpc_id = data.aws_vpc.default.id
}

module "db" {
    source = "../../modules/mysql-db"

    identifier = var.environment

    name = var.db_name
    username = var.db_user
    password = var.db_pass
    port = 3306

    # DB subnet group
    subnet_ids = data.aws_subnet_ids.all.ids
}