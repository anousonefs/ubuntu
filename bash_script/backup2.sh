#!/bin/bash

# Remote server details
remote_user="root"
remote_host=""
remote_src_path="~/dashboard-media"
curdate=$(date +%Y-%m-%d)


local_backup_dir="./backup/$curdate"

private_key_path="~/.ssh/ssn-node-red"

rsync -avb --delete --backup-dir="$local_backup_dir" -e "ssh -i $private_key_path" "$remote_user@$remote_host:$remote_src_path" ./target
