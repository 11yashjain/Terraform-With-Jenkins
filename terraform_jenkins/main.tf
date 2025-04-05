provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rgasp" {
  location = var.location
  name = var.resource_group_name
}

resource "azurerm_service_plan" "plan" {
  location = azurerm_resource_group.rgasp.location
  name = var.service_plan_name
  os_type = var.os
  resource_group_name = azurerm_resource_group.rgasp.name
  sku_name = var.pricing_plan
}

resource "azurerm_linux_web_app" "serviceApp" {
  service_plan_id = azurerm_service_plan.plan.id
  location = azurerm_service_plan.plan.location
  name = var.linux_web_app_name
  resource_group_name = azurerm_resource_group.rgasp.name
  site_config {
    
  }
}

resource "azurerm_linux_web_app_slot" "deploySlot" {
  app_service_id = azurerm_linux_web_app.serviceApp.id
  name = var.linux_web_app_slot_name
  site_config {
  }
}