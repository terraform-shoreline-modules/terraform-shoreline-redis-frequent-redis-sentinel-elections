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

module "frequent_redis_sentinel_elections_incident" {
  source    = "./modules/frequent_redis_sentinel_elections_incident"

  providers = {
    shoreline = shoreline
  }
}