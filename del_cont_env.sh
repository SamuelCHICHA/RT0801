#!/usr/bin/bash

# assurera  l'effacement  des  packages  installés  par  le  script inst_cont_env.sh

if [[ "$EUID" -ne 0 ]]
then
    exec sudo "$0" "$@"
fi

echo "Uninstalling LXC..."

if apt remove -y lxc &>/dev/null
then
    echo "LXC Uninstalled."
else
    >&2 echo "Could not uninstall LXC."
fi

echo "Uninstalling IPRoute"

if apt remove -y iproute &>/dev/null
then
    echo "IPRoute uninstalled."
else
    >&2 echo "Could not uninstall IPRoute."
fi
sudo -k
exit 0