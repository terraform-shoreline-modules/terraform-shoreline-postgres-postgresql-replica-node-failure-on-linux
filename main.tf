terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "postgresql_replica_node_failure_on_linux" {
  source    = "./modules/postgresql_replica_node_failure_on_linux"

  providers = {
    shoreline = shoreline
  }
}