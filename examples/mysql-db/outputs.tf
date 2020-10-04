output "db_address" {
    description = "The address of the database."
    value = module.db.db_address
}

output "db_port" {
    description = "The port of the database service."
    value = module.db.db_port
}