output "db_address" {
    description = "The address of the database."
    value = module.db.this_db_instance_address
}

output "db_port" {
    description = "The port of the database service."
    value = module.db.this_db_instance_port
}