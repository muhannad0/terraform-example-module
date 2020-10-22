terraform {
    required_version = ">= 0.12"
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "all" {
    vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
    vpc_id = data.aws_vpc.default.id
    name = "default"
}

data "template_file" "user_data" {
    template = file("${path.module}/user-data.sh")

    vars = {
        server_text = var.server_text
        server_port = var.server_port
        db_address = var.mysql_config.db_address
        db_port = var.mysql_config.db_port
        db_name = var.mysql_credentials.db_name
        db_user = var.mysql_credentials.db_user
        db_password = var.mysql_credentials.db_password
    }
}

module "asg" {
    source = "terraform-aws-modules/autoscaling/aws"
    version = "~> 3.0"

    name = "webapp-${var.environment}"

    # Launch Configuration

    image_id = "ami-0c94855ba95c71c99"
    instance_type = var.instance_type
    security_groups = [aws_security_group.instance.id]

    user_data = data.template_file.user_data.rendered

    recreate_asg_when_lc_changes = true

    # ASG Configuration
    asg_name = "asg-webapp-${var.environment}"
    vpc_zone_identifier = data.aws_subnet_ids.all.ids
    health_check_type = "EC2"
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    wait_for_elb_capacity = var.min_size

    tags = [
        {
            key = "environment"
            value = var.environment
            propagate_at_launch = true
        },
        {
            key = "service"
            value = "web-app"
            propagate_at_launch = true
        },
    ]

    target_group_arns = [module.alb.target_group_arns[0]]
}

module "alb" {
    source = "terraform-aws-modules/alb/aws"
    version = "~> 5.0"

    name = "alb-${var.environment}"

    load_balancer_type = "application"

    vpc_id = data.aws_vpc.default.id
    subnets = data.aws_subnet_ids.all.ids
    security_groups = [aws_security_group.alb.id]

    # ALB Listener Configuration
    http_tcp_listeners = [
        {
            port = local.http_port
            protocol = "HTTP"
            action_type = "fixed-response"
            fixed_response = {
                content_type = "text/plain"
                message_body = "404: page not found"
                status_code = 404
            }
        },
    ]

    # ALB Listener Rule Configuration
    # Currently only support https_listener_rules configured within the module
    # HTTP rule is defined as a separate resource

    # ALB Target Group Configuration
    target_groups = [
        {
            name_prefix = "web1"
            backend_protocol = "HTTP"
            backend_port = var.server_port
            target_type = "instance"
            deregistration_delay = 10
            health_check = {
                enabled = true
                interval = 15
                path = "/"
                protocol = "HTTP"
                matcher = "200"
                healthy_threshold = 2
                unhealthy_threshold = 2
                timeout = 3
            }
        },
    ]
}

# ALB HTTP Listener Rules
resource "aws_lb_listener_rule" "http_default" {
    listener_arn = module.alb.http_tcp_listener_arns[0]
    priority = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = module.alb.target_group_arns[0]
    }
}

# Security Groups Configuration
resource "aws_security_group" "instance" {
    name = "web-app-asg-${var.environment}-instance"
}

resource "aws_security_group_rule" "allow_instance_alb_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.instance.id

    from_port = var.server_port
    to_port = var.server_port
    protocol = local.tcp_protocol
    # cidr_blocks = local.any_ip
    source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "allow_instance_all_outbound" {
    type = "egress"
    security_group_id = aws_security_group.instance.id

    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.any_ip
}

resource "aws_security_group" "alb" {
    name = "web-app-alb-${var.environment}"
}

resource "aws_security_group_rule" "allow_http_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.alb.id

    # Allow inbound HTTP requests
    from_port = local.http_port
    to_port = local.http_port
    protocol = local.tcp_protocol
    cidr_blocks = local.any_ip
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type = "egress"
    security_group_id = aws_security_group.alb.id

    # Allow all outbound requests
    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.any_ip
}

resource "aws_security_group_rule" "allow_db_inbound" {
    type = "ingress"
    security_group_id = data.aws_security_group.default.id

    from_port = local.db_port
    to_port = local.db_port
    protocol = local.tcp_protocol
    # cidr_blocks = local.any_ip
    source_security_group_id = aws_security_group.instance.id
}

# Module local variables
locals {
    http_port = 80
    db_port = var.mysql_config.db_port
    any_port = 0
    any_protocol = "-1"
    tcp_protocol = "tcp"
    any_ip = ["0.0.0.0/0"]
}
