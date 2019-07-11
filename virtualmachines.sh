#!/bin/bash

# set up env-vars!
rg_name='cc-prd-dc-rg'
location='canadacentral'
avset_name='cc-dc-avset'
dc_prefix='cc-dc-0'
network_vnet='cc-dc-network-vnet'
network_vnet_subnet='cc-dc-network-subnet'
dc_nsg_name='cc-dc-nsg'
nsg_rule_01='cc-dc-nsg-ssh-rule'
nsg_rule_02='cc-dc-nsg-http-rule'
nic_prefix='cc-dc-nic-0'
os_disk_prefix='cc-dc-os-disk-0'
admin_user='chooseAGoodUserName'
admin_password='ch4ngeToSomethingBetter!'

# create a new resource group for dc resources
echo -e "************************\n Creating Resource Group\n************************\n"
az group create --name $rg_name --location $location

# create the availability set first
echo -e "************************\n Creating Availability Set\n************************\n"
az vm availability-set create -n $avset_name \
                              -g $rg_name \
                              -l $location \
                              --platform-fault-domain-count 2 \
                              --platform-update-domain-count 2

# create a virtual network for the domain controllers
echo -e "************************\n Creating Virtual Network\n************************\n"
az network vnet create --resource-group $rg_name \
                       --name $network_vnet \
                       --address-prefix 192.168.0.0/16 \
                       --subnet-name $network_vnet_subnet \
                       --subnet-prefix 192.168.1.0/24

# Create a network security group
echo -e "************************\n Creating NSG\n************************\n"
az network nsg create --resource-group $rg_name --name $dc_nsg_name

# Create a network security group rule for port 3389.
echo -e "************************\n Creating NSG Rules\n************************\n"
az network nsg rule create --resource-group $rg_name --nsg-name $dc_nsg_name \
                           --name $nsg_rule_01 --protocol tcp \
                           --direction inbound --source-address-prefix '*' \
                           --source-port-range '*' --destination-address-prefix '*' \
                           --destination-port-range 3389 --access allow --priority 1000

# Create a network security group rule for port 80.
az network nsg rule create --resource-group $rg_name --nsg-name $dc_nsg_name \
                           --name $nsg_rule_02 --protocol tcp \
                           --direction inbound --priority 1001 \
                           --source-address-prefix '*' --source-port-range '*' \
                           --destination-address-prefix '*' --destination-port-range 80 \
                           --access allow --priority 2000

# Create two virtual network cards and associate with public IP address and NSG.
echo -e "************************\n Creating NICs for DCs\n************************\n"
for i in `seq 1 2`; do
  az network nic create --resource-group $rg_name --name $nic_prefix$i \
                        --vnet-name $network_vnet --subnet $network_vnet_subnet \
                        --network-security-group $dc_nsg_name
done

# Create two virtual machines.
echo -e "************************\n Creating DCs\n************************\n"
for i in `seq 1 2`; do
  az vm create --resource-group $rg_name --name $dc_prefix$i \
               --availability-set $avset_name --nics $nic_prefix$i \
               --image win2016datacenter --os-disk-name $os_disk_prefix$i \
               --admin-password $admin_password --admin-username $admin_user \
               --no-wait
done

echo -e "************************\n Check Portal for completion\n************************\n"
