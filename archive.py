#!/usr/bin/env python

import subprocess
import os
import sys
import paramiko

if __name__ == "__main__":
    nb_args = len(sys.argv)
    if nb_args != 7:
        print(f"Wrong number of arguments {nb_args}.")
        exit(1)
    archive_name = sys.argv[1]
    src_path = sys.argv[2]
    server_login = sys.argv[3]
    server_address = sys.argv[4]
    server_password = sys.argv[5]
    remote_path = sys.argv[6]
    
    #TODO Add files to archive
    tar = subprocess.run(["tar", "-czf", f"{archive_name}", f"{src_path}"], capture_output=True, text=True)
    if tar.returncode != 0:
        print(tar.stderr)
        exit(2)
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(hostname=server_address, username=server_login, password=server_password)
    sftp_client = ssh_client.open_sftp()
    sftp_client.put(archive_name, f"{remote_path}/{archive_name}")
    sftp_client.close()
    print(f"Archive {archive_name} created and uploaded to {server_login}@{server_address}/{remote_path}.")
    exit(0)
    