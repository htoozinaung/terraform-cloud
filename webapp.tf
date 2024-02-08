/*
resource "azurerm_service_plan" "zServicePlanBlock" {
  name                = "zServicePlan"
  resource_group_name = local.resource_group_name
  location            = local.location
  os_type             = "Windows"
  sku_name            = "B1"
  depends_on = [ 
    azurerm_resource_group.appgrp
  ]
}
resource "azurerm_windows_web_app" "zWebAppBlock" {
  name                = "zWebApp20240208"
  resource_group_name = local.resource_group_name
  location            = local.location
  service_plan_id     = azurerm_service_plan.zServicePlanBlock.id

  site_config {
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v6.0"
    }
  }
  depends_on = [
    azurerm_service_plan.zServicePlanBlock
    ]
}
*/