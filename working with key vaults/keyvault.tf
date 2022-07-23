provider "azurerm"{
    features{}
}

resource "azurerm_resource_group" "rg"{
    name = "rg-keyvault"
    location = "brazilsouth"
}

// the data is used to get the situation data. There are other ways!
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
    name = "keyvaulttf"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    //aqui eu pego o tenant_id direto do sistema
    tenant_id = data.azurerm_client_config.current.tenant_id
    sku_name = "premium"
    soft_delete_retention_days = 7

    access_policy  {
        key_permissions = ["create", "get"]
        object_id = data.azurerm_client_config.current.object_id
        tenant_id = data.azurerm_client_config.current.tenant_id
        secret_permissions = [
            "set",
            "get",
            "delete",
            "purge",
            "recover",
            "list"
               ]
        certificate_permissions = [
        "list"
        ]
    }
}

resource "azurerm_key_vault_secret" "secret" {
    name = "secret-terraform"
    value = "mysecret@12345"
    key_vault_id = azurerm_key_vault.keyvault.id
    expiration_date = "2021-12-31T00:00:00Z"
}

#To get the key vault value from the system
data "azurerm_key_vault_secret" "getsecret" {
    key_vault_id = azurerm_key_vault.keyvault.id
    name         = "secret-terraform"
}

output "secret_value" {
    value = data.azurerm_key_vault_secret.getsecret.value
}

output "keyvault_url" {
    value = azurerm_key_vault.keyvault.vault_uri
}