# Proxmox VE Easy Upgrade
#   Written By: Brian Blankenship
#   Email: brianblankenship1978@gmail.com
#   GitHub: https://github.com/blankcode
#   Git Repo: https://github.com/blankcode/proxmox/PVE_Easy_Upgrade

# I went from 5.X to 6.2 with this so I'd say it's safe.
# Today I went from 6.2 to 6.3 and a node I missed the last time from 5.0 to 6.3. No sweat.

# GetOPS
OPTS=$(getopt -o hr  -- "$@")
eval set -- "$OPTS"
while true; do
  case "$1" in
    -h) helps; shift;;
    -r) REBOOT_NOW=Y; shift 2;;
    --) shift; break;;
  esac
done

helps() {
  echo "
  Usage:
    $0 -h \# Print this message.
    $0    \# Will __ASK__ to reboot at the end.
    $0 -r \# Will _FORCE_  a reboot at the end.

  Actions:
    Add the \"PVE pve-no-subscription repository provided by proxmox.com\" to the \"/etc/apt/sources.list\" file.
    If successful:
      apt update; apt dist-upgrade -y; \# Get New Distribution Update
      apt update; apt upgrade -y;      \# Get any updates after the distro.
      Determine if a reboot is wanted at this time or not.
  ";
};

askto_reboot() { echo "Reboot or Not?"; read REBOOT_NOW; [[ "$REBOOT_NOW" == "Y" ]] && { echo "reboot"; } || [[ "$REBOOT_NOW" != "N" ]] || { echo "Enter \'Y\' or \'N\'"; }; };

force_reboot() { reboot; };

should_reboot() { [[ "$REBOOT_NOW" == "Y" ]] && { force_reboot; } || { askto_reboot; }; };

grep -q "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" /etc/apt/sources.list && { echo " deb already added, skipping."; } || { echo "Adding deb."; echo -ne "\n# PVE pve-no-subscription repository provided by proxmox.com,\n# NOT recommended for production use\ndeb http://download.proxmox.com/debian/pve buster pve-no-subscription" >> /etc/apt/sources.list; } && apt update; apt dist-upgrade -y; apt update; apt upgrade -y; should_reboot
