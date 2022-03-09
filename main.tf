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
    team = "VOVteam"
  }


}
resource "azurerm_storage_account" "vovstorage" {
  name                     = "vovstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    team = "VOVteam"
  }
}
resource "azurerm_storage_container" "blob" {
  name                  = "blob"
  storage_account_name  = azurerm_storage_account.vovstorage.name
  container_access_type = "private"
}


///VM

/* resource "azurerm_network_security_group" "rg" {
  name                = "vov-security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


  tags = {
    team = "VOVteam"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "vovterraformnetwork" {
  name                = "vovVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    team = "VOVteam"
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
    team = "VOVteam"
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

  tags = {
    participants = "VOVteam"
  }
}
# Create network interface
resource "azurerm_network_interface" "vovterraformnic" {
  name                = "vovNIC1"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.vovterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vovterraformpublicip.id
  }

  tags = {
    participants = "VOVteam"
  }

}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "rg" {
  network_interface_id      = azurerm_network_interface.vovterraformnic.id
  network_security_group_id = azurerm_network_security_group.vovterraformnsg.id
}



# Create virtual machine
resource "azurerm_linux_virtual_machine" "myvioterraformvm" {
  name                  = "viovm"
  location              = "westeurope"
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

  computer_name                   = "vovvm"
  admin_username                  = "azureuser"
  admin_password                  = "TosiSalainen1!"
  disable_password_authentication = false


  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vovstorage.primary_blob_endpoint

  }
  tags = {
    participants = "VOVteam"
  }
} */
//Scalesetti
resource "azurerm_virtual_network" "rg" {
  name                = "vovacctvn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "rg" {
  name                 = "acctsub"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "rg" {
  name                = "vovtest"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = azurerm_resource_group.rg.name

  tags = {
    team = "vovteam"
  }
}

resource "azurerm_lb" "rg" {
  name                = "vovlb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "VovPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.rg.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.rg.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.rg.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.rg.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "VOVPublicIPAddress"
}

resource "azurerm_lb_probe" "rg" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.rg.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/health"
  port                = 8080
}

resource "azurerm_virtual_machine_scale_set" "rg" {
  name                = "VOVtestscaleset-1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.rg.id

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "vovtestvm"
    admin_username       = var.administrator_login
    admin_password       = var.administrator_login_password
  }

  os_profile_linux_config {
    disable_password_authentication = false


  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.rg.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }

  tags = {
    environment = "staging"
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



  tags = {
    participants = "VOVteam"
  }


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
