### Azure Base Framework 

## Set up
First we need to authenticate to Azure and use the right subscription

```console
az login

# once login via the browser is complete
# if you have MORE than one subscription, tell azure to use the right one

az account set --subscription <name or ID of subscription to use>

```

## Usage
Be sure to update the environment variables appropriately in `base.sh`</br>
The current env-vars there are 100% for placement only. If you're adding secrets, use a proper env-var or a vault [to-do]

```console
# to run with defaults
./base.sh

# to debug
sh -x base.sh
```

## TO DO LIST
- add ability to use a service-principal or managed identity for authentication
- add custom rules for the NSG(s) for security or routing purposes
- add VM creation and configuration (e.g. for Domain Controllers)
- add ability to have VMs live in an availability set
- add ability to have VMs placed within a pool behind a load-balancer (with & without a pip)
- write out service helpers (list VNETS, VMs, show inventory etc)
