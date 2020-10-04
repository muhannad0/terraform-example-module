output "web_app_dns" {
    description = "The DNS address of the web app."
    value = module.alb.this_lb_dns_name
}