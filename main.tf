# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "heroku" {
  api_key = var.heroku_api_key   # Securely fetch Heroku API key from variable
  email   = var.heroku_email     # Securely fetch Heroku email from variable
}

# Define Heroku API key variable
variable "heroku_api_key" {
  type      = string
  sensitive = true
  description = "The API key for authenticating with Heroku"
}

# Define Heroku email variable
variable "heroku_email" {
  type        = string
  description = "The email associated with the Heroku account"
}


resource "heroku_app" "example" {
  name   = "learn-terraform-heroku"
  region = "us"
}

resource "heroku_addon" "postgres" {
  app  = heroku_app.example.id
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_build" "example" {
  app = heroku_app.example.id

  source {
    path = "./app"
  }
}

variable "app_quantity" {
  default     = 1
  description = "Number of dynos in your Heroku formation"
}

# Launch the app's web process by scaling-up
resource "heroku_formation" "example" {
  app        = heroku_app.example.id
  type       = "web"
  quantity   = var.app_quantity
  size       = "Standard-1x"
  depends_on = [heroku_build.example]
}