resource "azurerm_resource_group" "forEach-scenario" {
  name     = "foreach-scenario"
  location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.forEach-scenario.name
}

resource "azurerm_subnet" "subnets" {
  for_each = {
    subnet1 = ["10.0.1.0/24"]
    subnet2 = ["10.0.2.0/24"]
  }
  name                 = each.key
  resource_group_name  = azurerm_resource_group.forEach-scenario.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = each.value
}

resource "azurerm_network_interface" "NICs" {


for_each = {
    Nic-vm1 = azurerm_subnet.subnets["subnet1"].id
    Nic-vm2 = azurerm_subnet.subnets["subnet2"].id
}
  
  name                = each.key
  location            = var.location
  resource_group_name = azurerm_resource_group.forEach-scenario.name

  

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value
    private_ip_address_allocation = "Dynamic"

  }
}
resource "azurerm_windows_virtual_machine" "VMs" {

    for_each = {

        VM1 = azurerm_network_interface.NICs["Nic-vm1"].id
        VM2 = azurerm_network_interface.NICs["Nic-vm2"].id
    }
  
  name                = each.key
  resource_group_name = azurerm_resource_group.forEach-scenario.name
  location            = var.location
  size                = "standard_b2ms"
  admin_username      = "TerraformTest"
  admin_password      = "Terraform@123"
  network_interface_ids = [
    each.value
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
