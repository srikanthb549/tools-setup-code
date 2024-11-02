terraform {
  backend "s3" {
    bucket = "terraform-d80"
    key    = "vault-secrets/terraform.tfstate"
    region = "us-east-1"

  }
}

provider "vault" {
  address         = "http://vault-internal.rdevopsb81.online:8200"
  token           = var.vault_token
  skip_tls_verify = true
}

variable "vault_token" {}

resource "vault_mount" "roboshop-dev" {
  path        = "roboshop-dev"
  type        = "kv"
  options     = { version = "2" }
  description = "RoboShop Dev Secrets"
}

resource "vault_generic_secret" "frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOT
{
  "catalogue_url":   "http://catalogue-dev.rdevopsb81.online:8080/",
  "cart_url":   "http://cart-dev.rdevopsb81.online:8080/",
  "user_url":   "http://user-dev.rdevopsb81.online:8080/",
  "shipping_url":   "http://shipping-dev.rdevopsb81.online:8080/",
  "payment_url":   "http://payment-dev.rdevopsb81.online:8080/"
}
EOT
}

resource "vault_generic_secret" "catalogue" {
  path = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
  "MONGO": "true",
  "MONGO_URL" : "mongodb://mongodb-dev.rdevopsb81.online:27017/catalogue"
}
EOT
}

resource "vault_generic_secret" "user" {
path = "${vault_mount.roboshop-dev.path}/user"

data_json = <<EOT
{
  "MONGO": "true",
  "MONGO_URL" : "mongodb://mongodb-dev.rdevopsb81.online:27017/users",
  "REDIS_URL" : "redis://redis-dev.rdevopsb81.online:6379"
}
EOT
}

resource "vault_generic_secret" "cart" {
  path = "${vault_mount.roboshop-dev.path}/cart"

  data_json = <<EOT
{
  "REDIS_HOST": "redis-dev.rdevopsb81.online",
  "CATALOGUE_HOST" : "catalogue-dev.rdevopsb81.online"
}
EOT
}

resource "vault_generic_secret" "shipping" {
path = "${vault_mount.roboshop-dev.path}/shipping"

data_json = <<EOT
{
  "CART_ENDPOINT": "cart-dev.rdevopsb81.online:8080",
  "DB_HOST" : "mysql-dev.rdevopsb81.online",
  "mysql_root_password" : "RoboShop@1"
}
EOT
}



resource "vault_generic_secret" "payment" {
  path = "${vault_mount.roboshop-dev.path}/payment"

  data_json = <<EOT
{
  "CART_HOST" : "cart-dev.rdevopsb81.online",
  "CART_PORT" : "8080",
  "USER_HOST" : "user-dev.rdevopsb81.online",
  "USER_PORT" : "8080",
  "AMQP_HOST" : "rabbitmq-dev.rdevopsb81.online",
  "AMQP_USER" : "roboshop",
  "AMQP_PASS" : "roboshop123"
}
EOT
}

resource "vault_generic_secret" "mysql" {
  path = "${vault_mount.roboshop-dev.path}/mysql"

  data_json = <<EOT
{
  "mysql_root_password" : "RoboShop@1"
}
EOT
}

resource "vault_generic_secret" "rabbitmq" {
  path = "${vault_mount.roboshop-dev.path}/rabbitmq"

  data_json = <<EOT
{
  "user" : "roboshop",
  "password" : "roboshop123"
}
EOT
}


