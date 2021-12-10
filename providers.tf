terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.88.1"
    }
  }


  backend "azurerm" {
    resource_group_name  = "NetworkWatcherRG"
    storage_account_name = "satestram2"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }


}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "eb8aa245-ac1a-4e2d-ad76-4685ce3a9273"

}