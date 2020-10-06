variable "environment" {
    description = "The deploy environment."
    type = string
}

variable "instance_type" {
    description = "The type of instance to deploy the app."
    type = string
}

variable "min_size" {
    description = "The minimum number of instances to be running in the cluster."
    type = number
}

variable "max_size" {
    description = "The maximum number of instances to be running in the cluster."
    type = number
}

variable "desired_capacity" {
    description = "The number of instances that should always be running in the cluster."
    type = number
}

variable "enable_autoscaling" {
    description = "Option to enable/disable autoscaling based on preset rules."
    type = bool
    default = false
}

variable "server_text" {
    description = "The text to be displayed on the web page."
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
