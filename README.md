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
Be sure to update the environment variables appropriately in `base.sh`<br/>
The current env-vars there are 100% for placement only. If you're adding secrets, use a proper env-var or a vault [to-do]

```console
# to run with defaults
./base.sh

# to debug
sh -x base.sh
```
## Virtual Machines
A common pattern with hybrid architecture is to have domain controllers in the cloud federated<br/>
with existing, on-prem domain controllers to handle DNS for the company domain. The script found<br/>
here will deploy 2 VMs in an availability set, ready to be configured as domain controllers.<br/>
Run this script the same way as the `base.sh` file.

**Note**: The `virtualmachines.sh` script is stand-alone and will deploy its own resource-group, vnet, <br/>
Network Security Group and NSG rules. There is no dependence on the `base.sh` resources at all.

## TO DO LIST
- add ability to use a service-principal or managed identity for authentication
- add ability to have VMs placed within a pool behind a load-balancer (with & without a pip)
- write out service helpers (list VNETS, VMs, show inventory etc)
