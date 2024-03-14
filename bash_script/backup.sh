#/bin/bash
curdate=$(date +%m-%d-%Y)
if [ ! -f /usr/bin/rsync ]; then
    sudo apt install -y rsync
fi
rsync -avb --delete --backup-dir=./backup/incremental/$curdate ./src ./target
