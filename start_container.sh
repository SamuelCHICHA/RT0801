#!/usr/bin/bash

# assure le démarrage d'un ou de plusieurs conteneurs dont les 
# identifiants sont passés en paramètres. Ce script permettra l'utilisation de jokers : cnt* 
# désignera  l'ensemble  des  conteneurs  dont  le  nom  commence  par  cnt.  Vous  pourrez 
# étendre à l'utilisation des expressions régulières pour désigner les conteneurs. 

if [[ $# -lt 1 ]]
then
    echo "You need to specify container names"
fi

# Risk of multiple occurences of container
lxc_ls=()
for name in "$@"
do
    lxc_ls+=($(sudo lxc-ls --filter=$name))
done
unique_lxc_ls=$(echo "$lxc_ls" | sort | uniq)
for container_name in $unique_lxc_ls
do
    lxc-start -n "$container_name"
done