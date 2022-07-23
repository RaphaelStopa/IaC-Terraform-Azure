
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

