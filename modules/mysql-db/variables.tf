variable "identifier" {
  description = "The database identifier, here used as deploy environment."
  type        = string
}

variable "name" {
  description = "The name of the database to create."
  type        = string
}

variable "username" {
  description = "The administrator username for the database."
  type        = string
}

variable "password" {
  description = "The password for the administrator user of the database."
  type        = string
}

variable "port" {
  description = "The port for database service."
  type        = number
  default     = 3306
}
