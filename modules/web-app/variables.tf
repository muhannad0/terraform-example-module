variable "environment" {
    description = "The deploy environment."
    type = string
}

variable "instance_type" {
    description = "The type of instance to deploy. eg: t2.micro"
    type = string
}

variable "min_size" {
    description = "The minimum number of instances to run in the cluster."
    type = number
}

variable "max_size" {
    description = "The maximum number of instances to run in the cluster."
    type = number
}

variable "desired_capacity" {
    description = "The number of instances that should always be running in the cluster."
    type = number
}

variable "enable_autoscaling" {
    description = "Enable/Disable auto scaling based on defined rules."
    type = bool
    default = false
}

variable "server_port" {
    description = "The port running web app service"
    type = number
    default = 8080
}

variable "server_text" {
    description = "The text to be displayed on the web page."
    type = string
    default = "Hello World Default"
}

variable "mysql_config" {
    description = "The configuration of the MySQL database."
    type = object({
        db_address = string
        db_port = number
    })
    default = null
}

variable "mysql_credentials" {
    description = "The credentials to access the MySQL database."
    type = object({
      db_name = string
      db_user = string
      db_password = string
    })
    default = null
}
