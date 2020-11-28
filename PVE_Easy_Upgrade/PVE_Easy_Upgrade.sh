# Proxmox VE Easy Upgrade
#   Writen By: Brian Blankenship
#   Email: brianblankenship1978@gmail.com
#   GitHub: https://github.com/blankcode
#   Git Repo: https://github.com/blankcode/proxmox/PVE_Easy_Upgrade

# I went from 5.X to 6.2 with this so I'd say it's safe.
# Today I went from 6.2 to 6.3 and a node I missed the last time from 5.0 to 6.3. No sweat.

grep -q "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" /etc/apt/sources.list && { echo " deb already added, skipping."; } || { echo "Adding deb."; echo -ne "\n# PVE pve-no-subscription repository provided by proxmox.com,\n# NOT recommended for production use\ndeb http://download.proxmox.com/debian/pve buster pve-no-subscription" >> /etc/apt/sources.list; } && apt update ; apt dist-upgrade -y ; apt update ; apt upgrade -y ; reboot ;


