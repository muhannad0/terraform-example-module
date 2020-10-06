output "web_app_dns" {
    description = "The DNS address to access the web app."
    value = module.web_app.web_app_dns
}