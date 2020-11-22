# PVE_Easy_Upgrade

One-Liner; Start and Wander Off; Proxmox Virtual Environment Easy Upgrade Script.

- This was tested on five (5) PVE 5.1 deployments with ZERO (0) unexpected issues. If you are using the "free" version there will always be an error during the "apt update".

      root@pve-alpha:~# apt update
      Hit:1 http://ftp.us.debian.org/debian buster InRelease
      Get:2 http://ftp.us.debian.org/debian buster-updates InRelease [51.9 kB]
      Get:3 http://security.debian.org buster/updates InRelease [65.4 kB]
      Get:4 http://security.debian.org buster/updates/main amd64 Packages [251 kB]
      Get:5 http://security.debian.org buster/updates/main Translation-en [137 kB]
      Err:6 https://enterprise.proxmox.com/debian/pve buster InRelease
        401  Unauthorized [IP: 144.217.225.162 443]
      Hit:7 http://download.proxmox.com/debian/pve buster InRelease
      Reading package lists... Done
      E: Failed to fetch https://enterprise.proxmox.com/debian/pve/dists/buster/InRelease  401  Unauthorized [IP: 144.217.225.162 443]
      E: The repository 'https://enterprise.proxmox.com/debian/pve buster InRelease' is not signed.
      N: Updating from such a repository can't be done securely, and is therefore disabled by default.
      N: See apt-secure(8) manpage for repository creation and user configuration details.
