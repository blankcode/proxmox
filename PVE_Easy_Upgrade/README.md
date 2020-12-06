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

Don't use the + and - of the same repository at one time. It won't "break" anything, but it won't do all you expect.
