# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg" {
  name     = "vovrg"
  location = "westeurope"

  tags = {
    participants = "VOVteam"
  }


}
resource "azurerm_storage_account" "vovstorage" {
  name                     = "vovstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    participants = "VOVteam"
  }
}
resource "azurerm_storage_container" "blob" {
  name                  = "blob"
  storage_account_name  = azurerm_storage_account.vovstorage.name
  container_access_type = "private"


}
resource "azurerm_network_security_group" "rg" {
  name                = "vov-security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    participants = "VOVteam"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "vovterraformnetwork" {
  name                = "vovVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    participants = "VOVteam"
  }
}
# Create subnet
resource "azurerm_subnet" "vovterraformsubnet" {
  name                 = "vovSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vovterraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]

}



# Create public IPs
resource "azurerm_public_ip" "vovterraformpublicip" {
  name                = "vovPublicIP"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"


  tags = {
    participants = "VOVteam"
  }

}
# Create Network Security Group and rule
resource "azurerm_network_security_group" "vovterraformnsg" {
  name                = "vovNetworkSecurityGroup"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}
# Create network interface
resource "azurerm_network_interface" "vovterraformnicvio" {
  name                = "vovNIC"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.vovterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vovterraformpublicip.id
  }


}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "rg" {
  network_interface_id      = azurerm_network_interface.vovterraformnicvio.id
  network_security_group_id = azurerm_network_security_group.vovterraformnsg.id
}



# Create virtual machine
resource "azurerm_linux_virtual_machine" "myvioterraformvm" {
  name                  = "viovm"
  location              = "westeurope"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vovterraformnicvio.id]
  size                  = "Standard_D2_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  computer_name                   = "vovvm"
  admin_username                  = "azureuser"
  admin_password                  = "TosiSalainen1!"
  disable_password_authentication = false


  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vovstorage.primary_blob_endpoint

  }
}
#PostgreSQL Database within a PostgreSQL Server
resource "azurerm_postgresql_server" "rg" {
  name                = "vov-terraform-postgresql-server-1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = "9.5"
  ssl_enforcement_enabled      = false
}

resource "azurerm_postgresql_database" "rg" {
  name                = "vov-terraform-db"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.rg.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "rg" {
  name                = "office"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.rg.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
