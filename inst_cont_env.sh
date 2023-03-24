#!/usr/bin/bash

# installera l'ensemble des packages nécessaires à l'utilisation de 
# conteneurs et à la création de bridge

if [[ "$EUID" -ne 0 ]]
then
    exec sudo "$0" "$@"
fi

apt update
apt install -y lxc
apt install -y iproute2
sudo -k
exit 0