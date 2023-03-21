#!/usr/bin/bash

if [[ $# -ne 2 ]]
then
    echo "Wrong number of arguments $#."
    exit 1
fi

archive_name=$1
directory=$2

if ! extension=$(echo "$archive_name" | grep -oP "[A-Za-z_-]+.()")
then
    echo "Archive name not matching requirements"
    exit 2
fi

if [[ ! -f "$archive_name" ]]
then
    echo "$archive_name is not a file"
    exit 3
fi

if ! mkdir "$directory"
then
    exit 4
fi

if [[ "$archive_name" == *.zip ]]
then
    if ! unzip "$archive_name" -d "$directory"
    then
        echo "Unzip error"
        exit 5
    fi
elif [[ "$archive_name" == *.tar ]]
then
    if ! tar -xf "$archive_name" -C "$directory"
    then
        echo "Tar error"
        exit 5
    fi
elif [[ "$archive_name" == *.tar.gz ]]
then
    if ! tar -xzf "$archive_name" -C "$directory"
    then
        echo "Tar error"
        exit 5
    fi
else
    echo "Unrecognized file extension"
    exit 6
fi

exit 0