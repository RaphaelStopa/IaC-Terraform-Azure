# here we will store the state in a storage blob
# there is more than one way to certify the terraform backend in storage
# note that the storage tag is the backend tag, and this storage must already be created.

terraform{
    backend "azurerm"{
        resource_group_name = "terraformstate"
        storage_account_name = "tfstateaztreinamento"
        container_name = "terraformstate"
        key = "account key"
    }
}

provider "azurerm"{
    features{

    }
}

resource "azurerm_resource_group" "rg-state" {
    name = "rg_terraform_com_state"
    location = "brazilsouth"
}