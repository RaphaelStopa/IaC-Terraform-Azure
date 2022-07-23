provider "azurerm"{
    features {

    }
}

variable "location" {
    type = string
    default = "Localizacao dos Recrusos do Azure. Ex: brazilsouth"
    description = "brazilsouth"
}

resource "azurerm_resource_group" "grupo-recurso" {
    name = "rg-variaveis"
    location = var.location
    tags = {
        "key" = "value"
    }
}