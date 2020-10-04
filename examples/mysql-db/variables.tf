variable "environment" {
    description = "The deploy environment."
    type = string
}

variable "db_name" {
    description = "The name of the database to create."
    type = string
}

variable "db_user" {
    description = "The administrator username for the database."
    type = string
}

variable "db_pass" {
    description = "The password for the administrator user of the database."
    type = string
}