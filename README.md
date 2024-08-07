## Dynamic to Static IP Configuration Script for Ubuntu Server 24.04

### Overview
This Bash script is designed to simplify the process of changing a dynamic IP address to a static IP address on Ubuntu Server 24.04.  
It provides a comprehensive step-by-step walkthrough, making it user-friendly for individuals with limited technical expertise but need their Ubuntu server up and running with a static IP configuration.
#
### Features
- **Welcome Message**: Provides an initial greeting and a brief overview of the script’s functionality.
- **User Authentication**: Displays the current user executing the script and prompts for confirmation to proceed.
- **Network Interface Detection**: Identifies an active network interface (ensure only one connection/ethernet cable is plugged in).
- **Current Network Settings**: Retrieves and displays the current IP address, netmask, gateway, and checks the status of DHCP4 and DHCP6.
- **User Input Prompts**: Prompts the user to enter a new static IP, netmask, gateway, DNS servers, and hostname.
- **Netplan Configuration Management**: Locates the existing netplan configuration file, creates a backup, and generates a new configuration file based on user input.
- **Apply Configuration**: Prompts the user to apply the new netplan configuration. If the user chooses not to apply, the script reverts to the original configuration and terminates.
#
###
![static-ip](https://github.com/user-attachments/assets/f8342ae2-d15e-4cdd-9e18-f50f900ac65c)
#
### Usage
1. **Run the Script**: Execute the script as root on your Ubuntu Server 24.04.
2. **Follow the Prompts**: The script will guide you through each step, from detecting the current network settings to applying the new static IP configuration.
3. **Confirmation**: Confirm the changes to apply the new configuration or revert to the original settings if needed.

### Requirements
- Ubuntu Server 24.04
- Bash

### Installation
Clone the repository:
```bash
git clone https://github.com/projects-by-ac/dynamic-to-static-ip.git
```

Navigate to the script directory:
```bash
cd dynamic-to-static-ip
```

Make the script executable:
```bash
sudo chmod +x static-ip.sh
```

Run the script:
```bash
sudo ./static-ip.sh
```

### This script has been thoroughly tested on Ubuntu Server 24.04
