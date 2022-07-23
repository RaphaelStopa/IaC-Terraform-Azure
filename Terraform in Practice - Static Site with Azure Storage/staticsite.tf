# need to have the site in another repository
# search for Static website
# https://www.udemy.com/course/terraformazure/learn/lecture/24412880#questions
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

variable "location" {
  type = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-sitehtml"
}

resource "azurerm_storage_account" "site" {
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.rg.location
  name                     = "blovhtmlsitetf"
  resource_group_name      = azurerm_resource_group.rg.name
  enable_https_traffic_only = true

  static_website {
    index_document = "index.html"
  }
}