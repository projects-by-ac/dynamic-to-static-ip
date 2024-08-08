#!/bin/bash

# Description: change dynamic to static ip for ubuntu-server setup
# Author: Amancio C.

    #HIGH INTENSITY (NORMAL)
    GREEN="\e[0;92m"
    YELLOW="\e[0;93m"
    WHITE="\e[0;97m"

    #HIGH INTENSITY (BOLD)
    BGREEN="\e[1;92m"
    BYELLOW="\e[1;93m"
    BWHITE="\e[1;97m"

    #HIGH INTENSITY (UNDERLINE)
    UGREEN="\e[4;92m"
    UYELLOW="\e[4;93m"
    UWHITE="\e[4;97m"

    #RESET/END
    ENDCOLOR="\e[0m"

    #SHOW DATE
    Now=$(date)

    #CURRENT USERNAME
    username=$(whoami)

## POST INSTALL WELCOME MESSAGE

echo ""
echo -e "${BYELLOW}                                                       ,_,${ENDCOLOR} 
              ${BYELLOW}https://github.com/projects-by-ac${ENDCOLOR}       ${YELLOW}(O,O)  
      ________________________________________________(   )__
                                                       " "

              ╔═╗╦═╗╔═╗ ╦╔═╗╔═╗╔╦╗╔═╗  ┌┐ ┬ ┬  ╔═╗╔═╗  
              ╠═╝╠╦╝║ ║ ║║╣ ║   ║ ╚═╗  ├┴┐└┬┘  ╠═╣║      
              ╩  ╩╚═╚═╝╚╝╚═╝╚═╝ ╩ ╚═╝  └─┘ ┴   ╩ ╩╚═╝     
        (@>                                                  
      __{||__________________________________________________
         ""||${ENDCOLOR}
${YELLOW}          |   Author:${ENDCOLOR} Amancio C.
${YELLOW}          |   Description:${ENDCOLOR} Script {Dynamic to Static IP}
"
echo ""
echo -e "initializing script on ${GREEN}$Now${ENDCOLOR}"
echo ""
sleep 1
echo -e "${BYELLOW}.......................................................................${ENDCOLOR}"
echo ""
echo -e "${BYELLOW}WELCOME! INSTALLING SCRIPT FOR THE FOLLOWING USER:${ENDCOLOR}"
echo ""
echo -e "${BGREEN}$username${ENDCOLOR}"
echo "" 
read -p "Do you want to proceed? (y/n)" -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo ""
echo -e "${BYELLOW}script will start running in${ENDCOLOR}"
sleep 1
echo -e "${BYELLOW}3...${ENDCOLOR}"
sleep 1
echo -e "${BYELLOW}2...${ENDCOLOR}"
sleep 1
echo -e "${BYELLOW}1...${ENDCOLOR}"
sleep 1
echo ""
echo -e "${BYELLOW}*/running script${ENDCOLOR}"
echo ""
sleep 1
echo -e "${BYELLOW}.......................................................................${ENDCOLOR}"
echo ""

# Find the active network interface
active_interface=$(ip -o route show to default | awk '{print $5}')

# Get the current IP address, netmask, and gateway
current_ip=$(ip addr show $active_interface | awk '/inet / {print $2}' | cut -d/ -f1)
current_netmask=$(ip addr show $active_interface | awk '/inet / {print $2}' | cut -d/ -f2)
current_gateway=$(ip route show default | awk '/default/ {print $3}')
current_hostname=$(hostname)

# Check if DHCP is enabled for IPv4 from Netplan configuration
dhcp4=$(grep -q "dhcp4: true" /etc/netplan/*.yaml && echo "yes" || echo "no")

# Check if DHCP is enabled for IPv6 from Netplan configuration
dhcp6=$(grep -q "dhcp6: true" /etc/netplan/*.yaml && echo "yes" || echo "no")

# Show the overview of the current IP address, netmask, and gateway
echo -e "${BYELLOW}CURRENT (DEFAULT) NETWORK SETTINGS:${ENDCOLOR}"
echo ""
echo -e "Current Hostname: ${BGREEN}$current_hostname${ENDCOLOR}"
echo -e "Current IP address: ${BGREEN}$current_ip${ENDCOLOR}"
echo -e "Current Netmask: ${BGREEN}255.255.255.0/$current_netmask${ENDCOLOR}"
echo -e "Current Gateway: ${BGREEN}$current_gateway${ENDCOLOR}"
echo ""
echo -e "DHCP4 Enabled: ${BGREEN}$dhcp4${ENDCOLOR}"
echo -e "DHCP6 Enabled: ${BGREEN}$dhcp6${ENDCOLOR}"
echo ""
echo "-----------------------------------------------------------------------"
echo -e "${BYELLOW}if you press Enter with 'no input' it will default to the current${ENDCOLOR}"
echo -e "${BYELLOW}existing network settings and change the dynamic IP to a static IP${ENDCOLOR}"
echo -e "${BYELLOW}with DHCP4/DHCP6 Disabled and Hostname set to: '$current_hostname'${ENDCOLOR}"
echo "-----------------------------------------------------------------------"
echo ""

# Prompt the user for the new static IP address
read -p "Set Static IP address (default: $current_ip): " new_ip
new_ip=${new_ip:-$current_ip}
echo ""

# Prompt the user for the netmask
read -p "Set Netmask CIDR (default: $current_netmask): " netmask
netmask=${netmask:-$current_netmask}
echo ""

# Prompt the user for the gateway
read -p "Set Gateway (default: $current_gateway): " gateway
gateway=${gateway:-$current_gateway}
echo ""

# Prompt the user for dhcp4
read -p "Enable DHCP4? (y/n): " dhcp4
case $dhcp4 in
  [Yy]) dhcp4="true";;
  [Nn]) dhcp4="false";;
  *) dhcp4="false";;
esac
echo ""

# Prompt the user for dhcp6
read -p "Enable DHCP6? (y/n): " dhcp6
case $dhcp6 in
  [Yy]) dhcp6="true";;
  [Nn]) dhcp6="false";;
  *) dhcp6="false";;
esac
echo ""

# Prompt the user for dns servers
read -p "Set DNS-Servers (default: 1.1.1.1,8.8.8.8): " dns_servers
dns_servers=${dns_servers:-"1.1.1.1,8.8.8.8"}
echo ""

# Prompt the user for hostname
read -p "Set Hostname (default: $current_hostname): " hostname
hostname=${hostname:-$current_hostname}
echo ""

# Find the netplan configuration file
netplan_file=$(ls /etc/netplan/ | grep -E '^[0-9]{2}-.*\.yaml$')

# Backup the original netplan configuration
cp /etc/netplan/$netplan_file /etc/netplan/$netplan_file.bak

echo "-----------------------------------------------------------------------"
echo -e "${BYELLOW}NETPLAN CONFIGURATION FILE:${ENDCOLOR}${BGREEN} /etc/netplan/$netplan_file${ENDCOLOR}"
echo "-----------------------------------------------------------------------"
echo ""

# Create a new netplan configuration file
cat <<EOF | sudo tee /etc/netplan/$netplan_file
network:
  version: 2
  renderer: networkd
  ethernets:
    $active_interface:
      dhcp4: $dhcp4
      dhcp6: $dhcp6
      addresses: [$new_ip/$netmask]
      routes:
        - to: default
          via: $gateway
      nameservers:
        addresses: [$dns_servers]
        search: [$hostname.local]
EOF
echo ""
echo "-----------------------------------------------------------------------"
echo ""
echo -e "${BYELLOW}Static IP address configured successfully${ENDCOLOR}"
echo ""
echo "-----------------------------------------------------------------------"
echo -e "${BYELLOW}after applying the netplan configuration file your current connection${ENDCOLOR}"
echo -e "${BYELLOW}will exit and you'll be able to access your new static ip address from:${ENDCOLOR}"
echo "-----------------------------------------------------------------------"
echo ""
echo -e "                     Hostname: ${BGREEN}$hostname.local${ENDCOLOR}"
echo -e "                   IP address: ${BGREEN}$new_ip/$netmask${ENDCOLOR}"
echo -e "                      Gateway: ${BGREEN}$gateway${ENDCOLOR}"
echo ""
echo "-----------------------------------------------------------------------"
echo ""

# Prompt the user to apply the netplan configuration
read -p "Apply the netplan configuration? (y/n): " apply_netplan
if [[ $apply_netplan == [Yy] ]]; then
    # Set the hostname
    sudo hostnamectl set-hostname $hostname
    # Apply the netplan configuration
    sudo netplan apply
    echo ""
    echo -e "${BYELLOW}Netplan configuration applied successfully${ENDCOLOR}"
    exit 0
else
    # Revert the changes made earlier
    sudo mv /etc/netplan/$netplan_file.bak /etc/netplan/$netplan_file
    echo ""
    echo -e "${BYELLOW}Changes reverted. Netplan configuration Not applied.${ENDCOLOR}"
fi
