#!/usr/bin/bash

echo -n "Type your username: "
read -r username
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
# echo "Groups: $groups"
echo "Group names:"
echo "$group_names"
exit 0