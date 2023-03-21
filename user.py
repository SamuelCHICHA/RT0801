#!/usr/bin/python3

import os
import getpass
import grp

if __name__ == "__main__":
    username = getpass.getuser()
    uid = os.getuid()
    groups_ids = os.getgroups()
    print(f"User name: {username}")
    print(f"User id: {uid}")
    groups = [group.gr_name for group in grp.getgrall() if group.gr_gid in groups_ids]
    print(f"Groups: {', '.join(groups)}")
    path = "user_information.txt"
    i = 0
    while i < 100 and os.path.exists(path):
        i += 1
        path = f"user_information({i}).txt"
    if i == 100:
        print("Could not store the information in a new file")
        exit(1)
    try:
        with open(path, "w") as file:
            file.write(f"User name: {username}\n")
            file.write(f"User id: {uid}\n")
            file.write(f"Groups: {', '.join(groups)}\n")
    except Exception as e:
        print(e)
        exit(2)
    exit(0)