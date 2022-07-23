variable "name-rg" {
    type = string
    description = "Nome do Resource Grupo"
    default = "rg-variaveis"
}


variable "location"{
    type = string
    description = "Localizacao dos Recursos do Azure. Ex: brasilsouth"
    default = "brasilsouth"
}

variable "tags" {
    type = map
    description = "Tags nos Recursos e servicos do Azure"
    default = {
        ambiente = "desenvolvimento"
        responsavel = "Raphael Mendes Stopa"
    }
}

variable "vnetenderecos" {
    type = list
    default = ["10.0.0.0.16", "192.168.0.0/16"]
}

