#/*------------ Appgw RG --------------------*\#
resource "azurerm_resource_group" "appgw_rg" {
  name     = join("-", [local.rgappgw, "dev-appgw"])
  location = local.buildregion
}

#/*------------- Frontend Subnet --------------------*\#
resource "azurerm_subnet" "frontend" {
  name                 = join("-", [local.rgappgw, "frontend", "subnet"])
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

#/*------------- Frontend Subnet Association --------------------*\#
resource "azurerm_subnet_route_table_association" "appgw_assoc_frontend" {
  subnet_id      = azurerm_subnet.frontend.id
  route_table_id = data.azurerm_route_table.rtb.id
}

#/*------------- Frontend Subnet Nsg Association --------------------*\#
resource "azurerm_subnet_network_security_group_association" "claxdev_nsg_assoc_frontend" {
  subnet_id                 = azurerm_subnet.frontend.id
  network_security_group_id = data.azurerm_network_security_group.clax_nsg.id
}


#/*------------- Backend Subnet --------------------*\#
resource "azurerm_subnet" "backend" {
  name                 = join("-", [local.rgappgw, "backend", "subnet"])
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

#/*------------- Backend Subnet Association --------------------*\#
resource "azurerm_subnet_route_table_association" "appgw_assoc_backend" {
  subnet_id      = azurerm_subnet.backend.id
  route_table_id = data.azurerm_route_table.rtb.id
}

#/*------------- Backend Subnet Nsg Association --------------------*\#
resource "azurerm_subnet_network_security_group_association" "claxdev_nsg_assoc_backend" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = data.azurerm_network_security_group.clax_nsg.id
}

#/*---------------- Public IP --------------------*\#
resource "azurerm_public_ip" "pip" {
  name                = join("-", [local.rgappgw, "appgw", "pip"])
  resource_group_name = azurerm_resource_group.appgw_rg.name
  location            = local.buildregion
  allocation_method   = "Static"
  sku                 = "Standard"
}

#/*---------------- Local Variable For Appgw --------------------*\#
locals {
  backend_address_pool_name      = "${data.azurerm_virtual_network.vnet.name}-beap"
  frontend_port_name             = "${data.azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${data.azurerm_virtual_network.vnet.name}-feip"
  http_setting_name              = "${data.azurerm_virtual_network.vnet.name}-be-htst"
  listener_name                  = join("-", [data.azurerm_virtual_network.vnet.name, "httplstn"])
  request_routing_rule_name      = join("-", [data.azurerm_virtual_network.vnet.name, "rqrt"])
  redirect_configuration_name    = join("-", [data.azurerm_virtual_network.vnet.name, "rdrcfg"])
}

#/*--------------------- Appgw -----------------------*\#
resource "azurerm_application_gateway" "network" {
  name                = join("-", [local.rgappgw, "devappgw"])
  resource_group_name = azurerm_resource_group.appgw_rg.name
  location            = local.buildregion

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = join("-", [local.rgappgw, "gateway", "ipconfig"])
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 10
  }
  tags = local.common_tags
}