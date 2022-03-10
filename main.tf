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
  name     = "${var.prefix}-tuntikirjausRG"
  location = var.location

  tags = {
    team = var.team
  }


}
#storage account ja blobi
/* resource "azurerm_storage_account" "vovstorage" {
  name                     = "${var.prefix}-storage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    team = var.team
  }
}
resource "azurerm_storage_container" "blob" {
  name                  = "${var.prefix}-blob"
  storage_account_name  = azurerm_storage_account.vovstorage.name
  container_access_type = "private"
} */


///VM

/* resource "azurerm_network_security_group" "rg" {
  name                = "${var.prefix}-security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


  tags = {
    team = var.team {
      
    }
  }
}

# Create virtual network
resource "azurerm_virtual_network" "vovterraformnetwork" {
  name                = "${var.prefix}-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    team = var.team
  }
}
# Create subnet
resource "azurerm_subnet" "vovterraformsubnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vovterraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]

}



# Create public IPs
resource "azurerm_public_ip" "vovterraformpublicip" {
  name                = "${var.prefix}-public IP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"


  tags = {
    team = var.team
  }

}
# Create Network Security Group and rule
resource "azurerm_network_security_group" "vovterraformnsg" {
  name                = "${var.prefix}-NetworkSecurityGroup"
  location            = var.location
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

  tags = {
    participants = var.team
  }
}
# Create network interface
resource "azurerm_network_interface" "vovterraformnic" {
  name                = "${var.prefix}-NIC"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = ""${var.prefix}-ipConfiguration"
    subnet_id                     = azurerm_subnet.vovterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vovterraformpublicip.id
  }

  tags = {
    participants = var.team
  }

}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "rg" {
  network_interface_id      = azurerm_network_interface.vovterraformnic.id
  network_security_group_id = azurerm_network_security_group.vovterraformnsg.id
}



# Create virtual machine
resource "azurerm_linux_virtual_machine" "myvioterraformvm" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vovterraformnic.id]
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

  computer_name                   = "${var.prefix}-vm"
  admin_username                  = "azureuser"
  admin_password                  = "TosiSalainen1!"
  disable_password_authentication = false


  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vovstorage.primary_blob_endpoint

  }
  tags = {
    participants = var.team
  }
} */
//Scalesetti 
resource "azurerm_virtual_network" "rg" {
  name                = "${var.prefix}-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "rg" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_storage_account" "rg" {
  name                     = "${var.prefix}storageaccount"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    team = var.team
  }
}

resource "azurerm_storage_container" "rg" {
  name                  = "${var.prefix}-storagecontainer"
  storage_account_name  = azurerm_storage_account.rg.name
  container_access_type = "private"
}

resource "azurerm_virtual_machine_scale_set" "rg" {
  name                = "${var.prefix}-ss"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  }

  os_profile {
    computer_name_prefix = "${var.prefix}-testvm"
    admin_username       = var.administrator_login
    admin_password       = var.administrator_login_password
  }

  os_profile_linux_config {
    disable_password_authentication = false


  }

  network_profile {
    name    = "${var.prefix}-networkprofile"
    primary = true

    ip_configuration {
      name      = "${var.prefix}-testIPConfiguration"
      primary   = true
      subnet_id = azurerm_subnet.rg.id
    }
  }

  storage_profile_os_disk {
    name           = "osDiskProfile"
    caching        = "ReadWrite"
    create_option  = "FromImage"
    vhd_containers = ["${azurerm_storage_account.rg.primary_blob_endpoint}${azurerm_storage_container.rg.name}"]
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}





#PostgreSQL Database within a PostgreSQL Server
resource "azurerm_postgresql_server" "rg" {
  name                = "${var.prefix}-terraformpostrgesqlserver"
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



  tags = {
    team = var.team
  }


}

resource "azurerm_postgresql_database" "rg" {
  name                = "${var.prefix}-db"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.rg.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

}

resource "azurerm_postgresql_firewall_rule" "rg" {
  name                = "kaikki"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.rg.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"


}
