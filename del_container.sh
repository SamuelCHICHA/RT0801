#!/usr/bin/bash

# assure la destruction d'un ou de plusieurs conteneurs dont les 
# identifiants sont passés en paramètres. Ce script permettra l'utilisation de jokers : cnt* 
# désignera  l'ensemble  des  conteneurs  dont  le  nom  commence  par  cnt.  Vous  pourrez 
# étendre à l'utilisation des expressions régulières pour désigner les conteneurs.

if [[ $# -lt 1 ]]
then
    echo "You need to specify container names"
fi

for name in "$@"
do
    OLDIFS=$IFS
    IFS=" "
    lxc_ls=$(lxc-ls --filter=$name)
    for container_name in $lxc_ls
    do
        # echo "$container_name"
        lxc-destroy -n "$container_name" -f
    done
    IFS=$OLDIFS
done