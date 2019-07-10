#!/bin/bash

# set env-vars first!
rg_name='cc-prd-rg'
location='canadacentral'
prod_vnet='cc-prd-vnet'
dev_vnet='cc-dev-vnet'
gateway_vnet='cc-gateway-vnet'
dev_app_subnet='cc-dev-app-subnet'
dev_web_subnet='cc-dev-web-subnet'
prod_app_subnet='cc-prd-app-subnet'
prod_web_subnet='cc-prd-web-subnet'
gateway_subnet='GatewaySubnet'
base_nsg_name='cc-base-nsg'
vnet_pip_name='cc-vnet-gateway-pip'


# create the resource group
echo -e "************************\n Creating Resource Groups\n************************\n"
az group create --name $rg_name --location $location

# create the virtual networks
echo -e "************************\n Creating Virtual Networks\n************************\n"
az network vnet create -g $rg_name -l $location -n $dev_vnet
az network vnet create -g $rg_name -l $location -n $prod_vnet
az network vnet create -g $rg_name -l $location -n $gateway_vnet

# create a base NSG
echo -e "************************\n Creating NSG's\n************************\n"
az network nsg create -g $rg_name -l $location -n $base_nsg_name

#create a public IP for the vnet gateway
echo -e "************************\n Creating Public IP Address\n************************\n"
az network public-ip create -g $rg_name -n $vnet_pip_name

# create the subnets
echo -e "************************\n Creating All Subnets\n************************\n"
az network vnet subnet create -g $rg_name --vnet-name $dev_vnet -n $dev_app_subnet --address-prefixes 10.0.1.0/24 --network-security-group $base_nsg_name
az network vnet subnet create -g $rg_name --vnet-name $dev_vnet -n $dev_web_subnet --address-prefixes 10.0.2.0/24 --network-security-group $base_nsg_name
az network vnet subnet create -g $rg_name --vnet-name $prod_vnet -n $prod_app_subnet --address-prefixes 10.0.3.0/24 --network-security-group $base_nsg_name
az network vnet subnet create -g $rg_name --vnet-name $prod_vnet -n $prod_web_subnet --address-prefixes 10.0.4.0/24 --network-security-group $base_nsg_name
az network vnet subnet create -g $rg_name --vnet-name $gateway_vnet -n $gateway_subnet --address-prefixes 10.0.5.0/24 --network-security-group $base_nsg_name

# create a vnet gateway
echo -e "************************\n Creating VNET Gateway\n************************\n"
az network vnet-gateway create -g $rg_name \
                               -l $location \
                               -n $gateway_vnet \
                               --public-ip-address $vnet_pip_name \
                               --vnet $gateway_vnet \
                               --gateway-type Vpn \
                               --sku VpnGw1 \
                               --vpn-type RouteBased \
                               --no-wait


echo -e "************************\n Base Framework Complete! \n************************\n"
