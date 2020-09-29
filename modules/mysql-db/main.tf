terraform {
    required_version = ">= 0.12"
}

module "db" {
    source = "terraform-aws-modules/rds/aws"
    version = "~> 2.0"

    identifier = var.identifier

    engine = "mysql"
    engine_version = "5.7.19"
    instance_class = "db.t2.micro"
    allocated_storage = 10

    name = var.name
    username = var.username
    password = var.password
    port = var.port

    maintenance_window = "Fri:20:00-Fri:21:00"
    backup_window = "22:00-23:00"

    backup_retention_period = 0

    # DB subnet group
    subnet_ids = var.subnet_ids

    # DB parameter group
    family = "mysql5.7"

    # DB option group
    major_engine_version = "5.7"

    parameters = [
        {
        name  = "character_set_client"
        value = "utf8"
        },
        {
        name  = "character_set_server"
        value = "utf8"
        }
    ] 
}