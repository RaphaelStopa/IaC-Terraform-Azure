# doc do terraform com o Azure: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
# Login: az login
# Ver lista assinatura: az account list
# Selecionar assinatura: az account set --subscription nomedasubscrition
# ver dados da sua conta: az account show

#trabalhando com variaveis. Precisa de um arquivo com o nome variables.tf

terraform {
  required_providers{
      # Usamos o azurerm, por estarmos usando o azure
      # Em caso de outro procure em nos docs
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

# terraform init "carrega o arquivo", inicializando o provider. Use sempre que achar necessário porque com ele você pode encontrar erros

# Tudo começa por um resource group
#Criar recursos, o recurso grupo e o nome do recurso mesmo
#rg, é como se fosse um apelido, definição, não é nome
resource "azurerm_resource_group" "rg" {
  name = var.rg
  location = var.local
  tags = {
    "env": "staging"
    "project": "azureestudo"
  }
}

# terraform plan: este comando não executa em si. Ele apenas checa se já existe ou vai fazer um atualização. Ele gera um plana de execução, mostrando o que vai ser executado.
# terraform apply: Roda em si. Ele vai pedir uma confirmação.

# Teste até esta parte ele criou um resource group
# Caso queria fazer um update de alguma coisa basta fazer e rodar novamente, ele vai identificar e mudar. Experimente com as tags


# Terraform Backend (para versionar terraform, mais pode usar o terraform cloud, blob e etc)
# Crie um resource grupo so para ela e depois crie um store account.
# Crie um container
#interrasante sempre deixar ele abaixo do provider!
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


# Criando uma rede interna
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
    subnet_id                     = azurerm_subnet.internal.id
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


#Vou usar isto aqui para tentar combar atualização de cluster
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


