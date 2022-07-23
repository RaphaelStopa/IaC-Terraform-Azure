provider "azurerm"{
    features {

    }
}

# rename to values and output and Marge

# the margin takes a value that already exists and adds another

# it is still possible to pass parameters via Command Line as terraform -var "location=westus"

# with a separate tfvars have to give the command
# terraform plan -var-file="valores.tfvars"


resource "azurerm_resource_group" "grupo-recurso" {
    name = var.name-rg
    location = var.location
    tags = marge(var.tags, {
        treinamento = "terraform"
    })
}

resource "azurerm_virtual_network" "vnet" {
    name = "vnet-terraform-treinamento"
    resource_group_name = "${azurerm_resource_group.grupo-recurso.name}"
    location = var.location
    address_space = var.vnetenderecos
}