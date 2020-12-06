# PVE_Easy_Upgrade

One-Liner; Start and Wander Off; Proxmox Virtual Environment Easy Upgrade Script.

- This was tested on five (5) PVE 5.0 deployments with ZERO (0) unexpected issues. <br>If you are using the "free" version there will always be an error during the "apt update". See Below.

      root@pve-alpha:~# apt update<br>
      Hit:1 http://ftp.us.debian.org/debian buster InRelease<br>
      Get:2 http://ftp.us.debian.org/debian buster-updates InRelease [51.9 kB]<br>
      Get:3 http://security.debian.org buster/updates InRelease [65.4 kB]<br>
      Get:4 http://security.debian.org buster/updates/main amd64 Packages [251 kB]<br>
      Get:5 http://security.debian.org buster/updates/main Translation-en [137 kB]<br>
      Err:6 https://enterprise.proxmox.com/debian/pve buster InRelease<br>
        401  Unauthorized [IP: 144.217.225.162 443]<br>
      Hit:7 http://download.proxmox.com/debian/pve buster InRelease<br>
      Reading package lists... Done<br>
      E: Failed to fetch https://enterprise.proxmox.com/debian/pve/dists/buster/InRelease<br>
        401  Unauthorized [IP: 144.217.225.162 443]<br>
      E: The repository 'https://enterprise.proxmox.com/debian/pve buster InRelease' is not signed.<br>
      N: Updating from such a repository can't be done securely, and is therefore disabled by default.<br>
      N: See apt-secure(8) manpage for repository creation and user configuration details.<br>

---

## Usage:

      PVE_Easy_Upgrade.sh -h \# Print this message.
      PVE_Easy_Upgrade.sh    \# Will __ASK__ to reboot at the end.
      PVE_Easy_Upgrade.sh -r \# Will _FORCE_  a reboot at the end.

## Actions:

      Add the "PVE pve-no-subscription repository provided by proxmox.com" to the "/etc/apt/sources.list" file.
      If successful:
        apt update; apt dist-upgrade -y; # Get New Distribution Update
        apt update; apt upgrade -y;      # Get any updates after the distro.
        Determine if a reboot is wanted at this time or not.

Use "Proxmox Update Control" (puc.sh) to remove the errors and perform updates via the UI.

# Proxmox Update Control (puc.sh)

    Options:
      -h   helps. This Message.
      --check   What's ENABLE/DISABLED
      --add     Add the Community Repository in an ENABLED state
      -c DISABLE Community Repository
      +c ENABLE Community Repository
      -e DISABLE Enterprise Repository
      +e ENABLE Enterprise Repository

    "puc.sh --add -e" # New install, ADDING the Community Repository and DISABLING Enterprise Repository.
