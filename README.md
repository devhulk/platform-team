# TFC Producer/Consumer Demo

## Description

Illustrate how an organization can compose workspaces to provide and consume different forms of infrastructure.


## Setup

* User Token in Owners Group, or Admin level permissions (Team / Org token works for some resources but not all)
* This example creates minimum of three workspaces (azure-db, azure-networking, product_team_a)
* These repositories need to be created with (dev | qa | prod) branches. We will reference them when creating resources.
* I created Variable Sets to make it a little easier for the Azure specific auth Environment variables. Had to do this part manually because I didn't see a variable_set resource for the tfe provider.
* Setup the [az cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and login with ```az login``` 


## Current Resources Created

* Networking with 3 subnets
* Cosmos DB - (sql or mongodb)
* Windows VM
* Run-Trigger between Networking and Product Team Workspaces

## Underlying Private Modules

* [terraform-azure-networking](https://github.com/devhulk/terraform-azure-networking)
* [terraform-azure-cosmosdb](https://github.com/devhulk/terraform-azure-cosmosdb)
* [terraform-azure-windows-vm](https://github.com/devhulk/terraform-azure-windows-vm)

Other Modules Not Currently In Use:

* [terraform-azure-datalake](https://github.com/devhulk/terraform-azure-datalake)
* [terraform-azure-linux-vm](https://github.com/devhulk/terraform-azure-linux-vm)

# Clean Up
For some reason the tfe module doesn't auto destroy resources, or I just don't see it. In the interim I have a cleanup script that can be run post demo and destroy to make sure resources are deleted. Its under ```demo/cleanup_demo.js```. I also don't mark anything as "DoNotDelete" so resources may get taken care of by the external Azure measures we have in place, wouldn't count on it though.  
# Next Steps

* Combining modules into composable Application Architectures (n-tier, serverless, microservices, pub-sub, etc)
