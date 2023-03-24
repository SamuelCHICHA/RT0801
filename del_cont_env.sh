#!/usr/bin/bash

# assurera  l'effacement  des  packages  installés  par  le  script inst_cont_env.sh

if [[ "$EUID" -ne 0 ]]
then
    exec sudo "$0" "$@"
fi

apt remove -y lxc
apt remove -y iproute
sudo -k
exit 0