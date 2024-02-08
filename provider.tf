terraform {
  cloud {
    organization = "HtooZin"

    workspaces {
      name = "workspace-DEV"
    }
  }
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.90.0"
    }
  }
}

#for myterraform app registration
provider "azurerm" {
  subscription_id = "2a5096bf-94e1-4437-b100-66549491b696"
  #Directory (tenant) ID
  tenant_id       = "c21d1a8c-4809-498b-93ca-130a1368da96"
  #Application (client) ID
  client_id = "bd25fb3d-4a56-4fe5-890d-303a6722cd6f"
  client_secret = "mz48Q~Cdpy1Esg.xvryxd6Vd3mhiSeI6jwTsmbKo"
  features {}
}


/*
#for terraform app registration
provider "azurerm" {
  subscription_id = "2a5096bf-94e1-4437-b100-66549491b696"
  #Directory (tenant) ID
  tenant_id       = "c21d1a8c-4809-498b-93ca-130a1368da96"
  #Application (client) ID
  client_id = "007d97df-2be7-414a-bd01-b21bdb29554b"
  client_secret = "vL98Q~wNvkwb23u90UzndlOuREtOrh7mhQ2oIbpS"
  features {}
}
*/
