output "db_address" {
  description = "The address of the database."
  value       = module.db.db_address
}

output "db_port" {
  description = "The port of the database service."
  value       = module.db.db_port
}

output "db_security_group_id" {
  description = "The ID of the database security group."
  value       = module.db.db_security_group_id
}
