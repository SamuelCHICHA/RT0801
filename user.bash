#!/usr/bin/bash

username=$USER
if ! id_cmd=$(id $username 2>&1)
then
    echo "Failure: $id_cmd"
    exit 1
fi
if ! uid=$(echo "$id_cmd" | grep -oP "(?<=uid=)\d+")
then
    echo "Failure: could not find the uid"
    exit 2 
fi
if ! groups=$(echo "$id_cmd" | grep -oP "(?<=groups=).*")
then
    echo "Failure: could not find the groups"
    exit 2
fi
if ! group_names=$(echo "$groups" | grep -oP "(?<=\()\w+(?=\))")
then
    echo "Failure: could not find the group names"
    exit 2
fi
echo "User name: $username"
echo "User id: $uid"
echo "Groups:"
echo "$group_names"
path="user_information.txt"
i=0
while [[ $i -lt 100 && -f "$path" ]]
do
    i=$((i + 1))
    path="user_information($i).txt"
done
if [[ $i -eq 100 ]]
then
    echo "Could not store the information in a new file"
    exit 3
fi
echo "User name: $username" > "$path"
echo "User id: $uid" >> "$path"
echo "Groups: $group_names" >> "$path"
exit 0