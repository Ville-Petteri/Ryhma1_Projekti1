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





