#!/usr/bin/bash

# installera l'ensemble des packages nécessaires à l'utilisation de 
# conteneurs et à la création de bridge

if [[ "$EUID" -ne 0 ]]
then
    exec sudo "$0" "$@"
fi

echo "Fetching latest versions..."
if apt update &>/dev/null
then
    echo "Repos mis à jour."
else
    >&2 echo "Erreur lors de la mise à jour des repos."
fi

echo "Installing LXC..."

if apt install -y lxc &>/dev/null
then
    echo "LXC installed."
else
    >&2 echo "LXC could not be installed."
fi

echo "Installing IPRoute..."

if apt install -y iproute2 &>/dev/null
then
    echo "IPRoute installed."
else
    >&2 echo "IPRoute could not be installed."
fi

sudo -k
exit 0