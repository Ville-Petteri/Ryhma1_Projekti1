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
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
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
data "template_file" "asennus" {
  template = file("VMSS_Custom_data.sh")
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
    custom_data          = base64encode(data.template_file.asennus.rendered)
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

#keyvault

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "rg" {
  name                        = "${var.prefix}keyvault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}



