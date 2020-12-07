#!/usr/bin/bash

# Proxmox Update Control
#   Written By: Brian Blankenship
#   Email: brianblankenship1978@gmail.com
#   GitHub: https://github.com/blankcode
#   Git Repo: https://github.com/blankcode/proxmox/PVE_Easy_Upgrade

# I went from 5.X to 6.2 with this so I'd say it's safe.
# Today I went from 6.2 to 6.3 and a node I missed the last time from 5.0 to 6.3. No sweat.

# GetOPS
OPTS=$(getopt -o hc --long "de,dc,ee,ec"  -- "$@")
eval set -- "$OPTS"
while true; do
  case "$1" in
    -h) helps; shift;;
    -e) disable_ent; shift;;
    -c) disable_comm; shift;;
    +e) enable_ent; shift;;
    +c) enable_comm; shift;;
    --check) check_states; shift;;
    --add) add_comm_repo; shift;;
    --) shift; break;;
  esac
done

# Options Safety Checks for Contradicting Commands

helps() { echo "
Script Name:
  $0 | Proxmox Update Control

Options:
  -h      helps. This Message.
  --check What's ENABLE/DISABLED
  --add     Add the Community Repository
  -e        Disable Enterprise Repository
  -c        Disable Community Repository
  +e        Enable Enterprise Repository
  +c        Enable Community Repository

Usage:
  $0 --check
  $0 --add    # New install, just ADDING the Community Repository.
  $0 --add -e # New install, ADDING the Community Repository and DISABLING Enterprise Repository.
  $0 -e
  $0 +e
  $0 +c -e  
  $0 +e -c    # If you went from the Community to the Enterprise model by acquiering a license.

Created By: 
  Name:   Brian Blankenship
  Date:   2020/12/06 (Dec 12, 2020)
  GitHub: https://github.com/blankcode
  "
};

# The Whats and Wheres
SOURCE_LIST_POINTER="/etc/apt/sources.list"
SOURCE_LIST_POINTER_OLD=$(echo -ne "/tmp/"$(echo $SOURCE_LIST_POINTER | rev | cut -d/ -f1 | rev)".old")
RELEASE_POINTER="http://download.proxmox.com/debian/pve" # PVE Community Pointer
CURRENT_RELEASE=$(grep main "$SOURCE_LIST_POINTER" | grep -v update | awk '{print $3}')
ENTERPRISE_POINTER="/etc/apt/sources.list.d/pve-enterprise.list"
ENTERPRISE_POINTER_OLD=$(echo -ne "/tmp/"$(echo $ENTERPRISE_POINTER | rev | cut -d/ -f1 | rev)".old")

# pve-enterprise\community toggles
# Community Repo
# Add the community repository
add_comm_repo() { 
  [[ $(grep -Po "pve-no-subscription" $SOURCE_LIST_POINTER) == "pve-no-subscription" ]] && { 
    echo "\"Community Repository\" already added, skipping."; 
    } || { 
      echo "Adding deb."; 
      cp  $SOURCE_LIST_POINTER $SOURCE_LIST_POINTER_OLD; 
      echo -ne "\n# PVE pve-no-subscription repository provided by proxmox.com,\n# NOT recommended for production use\ndeb http://download.proxmox.com/debian/pve "$CURRENT_RELEASE" pve-no-subscription\n" >> $SOURCE_LIST_POINTER; 
      echo -ne "\n\nChanges:\n"; 
      diff $SOURCE_LIST_POINTER_OLD $SOURCE_LIST_POINTER; 
      }; 
  }; 

# Disable Community
disable_comm() { 
  [[ $(grep "pve-no-subscription" "$SOURCE_LIST_POINTER" | grep -Po "^#deb" | cut -c2-4) == "deb" ]] && {
    echo "\"Community Repository\" Is already DISABLED." 
    } || {
      echo "DISABLING \"Community Repository\" (pve-no-subscription).";
      cp  $SOURCE_LIST_POINTER $SOURCE_LIST_POINTER_OLD; 
      LINE_NUMBER=$(grep -n "pve-no-subscription" $SOURCE_LIST_POINTER | grep deb | cut -d: -f1); 
      sed -i -e "$(echo $LINE_NUMBER)s/^deb/#deb/" $SOURCE_LIST_POINTER; 
      echo -ne "\n\nChanges:\n"; 
      diff $SOURCE_LIST_POINTER_OLD $SOURCE_LIST_POINTER; 
      }; 
  }; 

# Enable Community
enable_comm() { 
  [[ $(grep "pve-no-subscription" "$SOURCE_LIST_POINTER" | grep -Po "^#deb" | cut -c2-4) != "deb" ]] && { 
    echo "\"Community Repository\" Is already ENABLED."; 
    } || {  
      echo "ENABLING \"Community Repository\" (pve-no-subscription)."; 
      cp  $SOURCE_LIST_POINTER $SOURCE_LIST_POINTER_OLD; 
      LINE_NUMBER=$(grep -n "pve-no-subscription" $SOURCE_LIST_POINTER | grep deb | cut -d: -f1); 
      sed -i -e "$(echo $LINE_NUMBER)s/^#deb/deb/"  $SOURCE_LIST_POINTER; 
      echo -ne "\n\nChanges:\n"; 
      diff $SOURCE_LIST_POINTER_OLD $SOURCE_LIST_POINTER; 
      }; 
  }; 

# Enterprise Repo
# Disable Enterprise
disable_ent() {
  [[ $(grep "pve-enterprise" "$ENTERPRISE_POINTER" | grep -Po "^#deb" | cut -c2-4) == "deb" ]] && { 
      echo "\"pve-enterprise\" Is already DISABLED." 
    } || { 
      echo "DISABLING pve-enterprise.";
      cp  $ENTERPRISE_POINTER $ENTERPRISE_POINTER_OLD; 
      LINE_NUMBER=$(grep -n "pve-no-subscription" $ENTERPRISE_POINTER | grep deb | cut -d: -f1); 
      sed -i -e "$(echo $LINE_NUMBER)s/^deb/#deb/" $ENTERPRISE_POINTER;
      echo -ne "\n\nChanges:\n";
      diff $ENTERPRISE_POINTER_OLD $ENTERPRISE_POINTER; 
      }; 
  }; 

# Enable Enterprise
enable_ent() { 
  [[ $(grep "pve-enterprise" "$ENTERPRISE_POINTER" | grep -Po "^#deb" | cut -c2-4) != "deb" ]] && { 
      echo "\"pve-enterprise\" Is already ENABLED." 
    } || { 
      echo "ENABLING pve-enterprise.";
      cp  $ENTERPRISE_POINTER $ENTERPRISE_POINTER_OLD; 
      LINE_NUMBER=$(grep -n "pve-no-subscription" $ENTERPRISE_POINTER | grep deb | cut -d: -f1); 
      sed -i -e "$(echo $LINE_NUMBER)s/^#deb/deb/" $ENTERPRISE_POINTER; 
      echo -ne "\n\nChanges:\n"; 
      diff $ENTERPRISE_POINTER_OLD $ENTERPRISE_POINTER; 
      }; 
  }; 

# What's ENABLE/DISABLED
check_states() {
  echo "Contents of "$SOURCE_LIST_POINTER;
  cat $SOURCE_LIST_POINTER;
  echo;
  echo "Contents of "$ENTERPRISE_POINTER
  cat $ENTERPRISE_POINTER;
  };

exit 0