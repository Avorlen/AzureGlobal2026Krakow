terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-user1"
    storage_account_name = "stacuser1"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

module "keyvault" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=keyvault/v1.0.0"
  keyvault_name = "kevo1"
  network_acls = {
    bypass = "AzureServices"
  }
  resource_group = {
    location = "uksouth"
    name = "rg-user1"
  }
}

module "mssql_server" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=mssql_server/v1.0.0"
  resource_group = {
    location = "uksouth"
    name = "rg-user1"
  }
  sql_server_admin = "sqladmin"
  sql_server_version = "12.0"
  sql_server_name = "sqlse1"
}

module "service_plan" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=service_plan/v2.0.0"
  app_service_plan_name = "sepl1"
  resource_group = {
    location = "uksouth"
    name = "rg-user1"
  }
  sku_name = "B3"
  tags = {
    environment = "workshops"
    owner       = "user1"
    created_by  = "terraform"
  }
}
