provider "azurerm" {
    features{

    }
}

resource "azurerm_resource_group" "grupo-recurso" {
    location = "brasilsouth"
    name = "rg-terraform-mod5"
    tags = {
        data = formatdate("DD MM yyy hh:mm ZZZ", timestamp())
        ambiente = lower("Homologacao")
        responsavel = upper("higor Luiz Barbosa")
        tecnologia = title("terraform")
    }
}

variable "vnetips"{
    type = list
    default = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "vnet"{
    name = "vnettreinamentoazure"
    location = "brasilsouth"
    resource_group_name = "rg-terraform-mod5"
    address_space= concat(var.vnetips, ["192.168.0.0/16"])
}