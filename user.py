#!/usr/bin/python3

import sys
import subprocess
import os
import re
import getpass

if __name__ == "__main__":
    username = input("Type your username: ")
    id_result = subprocess.run(["id", f"{username}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if id_result.returncode != 0:
        print(id_result.stderr.decode())
        exit(1)
    match = re.match(r"uid=(?P<uid>\d+)\(\w+\) gid=.* groups=(?P<groups>\d+\(\w+\)(,\d+\((\w+)\))*)", id_result.stdout.decode())
    if match is None:
        print("Could not find information about the specified user.")
        print(id_result.stdout.decode())
        exit(3)
    uid = match.group('uid')
    print(f"User name: {username}")
    print(f"User id: {uid}")
    groups = re.findall(r"\((\w+)\)", match.group('groups'))
    print(f"Groups: {', '.join(groups)}")
    path = input("Where do you want to store the information ?")
    try:
        with open(path, "w") as file:
            file.write(f"User name: {username}\n")
            file.write(f"User id: {uid}\n")
            file.write(f"Groups: {', '.join(groups)}\n")
    except FileNotFoundError as fnfe:
        print(fnfe)
        exit(2)
    exit(0)