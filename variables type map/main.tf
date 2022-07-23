provider "azurerm"{
    features {

    }
}


resource "azurerm_resource_group" "grupo-recurso" {
    name = "rg-variaveis"
    location = var.location
    tags = var.tags
}