#!/usr/bin/python3

import subprocess
import os
import sys
import stat
import zipfile
import tarfile
import re

if __name__ == "__main__":
    nb_args = len(sys.argv)
    if nb_args != 3:
        print(f"Wrong number of arguments {nb_args}.")
        exit(1)
    archive_name = sys.argv[1]
    directory = sys.argv[2]
    
    match = re.match(r"(?P<name>[\w-]+).(?P<extension>tar|tar\.gz|zip)", archive_name)
    if match is None:
        print("Archive name not matching requirements")
        exit(2) 
    # Vérification existence archive
    if not os.path.exists(archive_name):
        print(f"File {archive_name} does not exist.")
        exit(3)
    if not os.path.isfile(archive_name):
        print(f"{archive_name} is not a file")
        exit(3)
    
    try:    
        os.mkdir(directory)
    except Exception as e:
        print(e)
        exit(4)
    
    # Vérification droit archive
    if match.group('extension') == "zip":
        try:
            with zipfile.ZipFile(archive_name, mode="r") as zip:
                zip.extractall(directory)
        except Exception as e:
            print(e)
            exit(4)
    elif match.group('extension') == "tar":
        try:
            with tarfile.open(archive_name) as tar:
                tar.extractall(directory)
        except Exception as e:
            print(e)
            exit(4)
    elif match.group('extension') == "tar.gz" or match.group('extension') == "tgz":
        try:
            with tarfile.open(archive_name, mode="r:gz") as tar:
                tar.extractall(directory)
        except Exception as e:
            print(e)
            exit(4)
    exit(0)
    
    
    
    