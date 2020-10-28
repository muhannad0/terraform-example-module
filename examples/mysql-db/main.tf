terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}

module "db" {
  source = "../../modules/mysql-db"

  identifier = var.environment

  name     = var.db_name
  username = var.db_user
  password = var.db_pass
  port     = 3306
}
