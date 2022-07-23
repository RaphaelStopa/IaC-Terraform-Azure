# terraform doc with Azure: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
# Login: az login
# View subscription list: az account list
# select subscription: az account set --subscription nomedasubscrition
# see your account details: az account show

# working with variables. Need a file named variables.tf

terraform {
  required_providers{
    # We use azurerm, because we are using azure
    # In case of another look in the documentation
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.0"
    }
  }
}

provider "azurerm"{
  features {

  }
}

# terraform init "loads the file", initializing the provider. Use it whenever you think it's necessary because with it you can find mistakes

# It all starts with a resource group
# Create resources, resource group and resource name same
# rg, it's like a nickname, definition, it's not a name
resource "azurerm_resource_group" "rg" {
  name = var.rg
  location = var.local
  tags = {
    "env": "staging"
    "project": "azureestudo"
  }
}

# terraform plan:this command does not run itself. It just checks if it already exists or is going to do an update. It generates an execution plan, showing what will be executed.
# terraform apply: Wheel itself. It will ask for confirmation.

# So far he has created a resource group
# If you want to update something, just do it and run it again, it will identify and change. Experiment with tags


# Terraform Backend (to version terraform, but you can use terraform cloud, blob and etc)
# Create a resource group just for her and then create a store account.
# create a container
# interesting to always leave it under the provider!
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "StorageAccount-ResourceGroup"
#     storage_account_name = "abcd1234"
#     container_name       = "tfstate"
#     # aqui eh o nome do arquivo que vc vai criar
#     key                  = "prod.terraform.tfstate"
#     #talvez vc tenha que autenticar.
#   }
# }


# Creating an internal network
resource "azurerm_virtual_network" "default" {
  name = var.vnet
  address_space = ["10.0.0.0/16"]
  location = var.local
  resource_group_name = var.rg

}

# sub rede
resource "azurerm_subnet" "name" {
  name = "internal"
  resource_group_name = var.rg
  virtual_network_name = var.vnet
  address_prefixes = [ "10.0.1.0/24" ]

}

resource "azurerm_network_interface" "default" {
  name                = "${var.vm}-nic"
  location            = var.local
  resource_group_name = var.rg

  ip_configuration {
    name                          = "testconfiguration1"
#    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_virtual_machine" "main" {
  name                  = var.vm
  location              = var.local
  resource_group_name   = var.rg
  network_interface_ids = [azurerm_network_interface.default.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}


resource "azurerm_maintenance_configuration" "maintenance" {
  name                = "monday-mc"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  #Extension, Host, InGuestPatch, OSImage, SQLDB or SQLManagedInstance
  scope               = "All"

  window {
    start_date_time      = "2022-03-14 01:00"
    expiration_date_time = "9999-12-31 00:00"
    duration             = "02:00"
    time_zone            = "Central Brazilian Standard Time"
    recur_every          = "7Days"
  }
}
