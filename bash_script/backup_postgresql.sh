#!/bin/bash

# Configuration
CONTAINER_NAME="root-postgres-1"  # Your PostgreSQL container name
DB_NAME="mydb"                       # The name of your database
DB_USER="postgres"                   # The PostgreSQL user with sufficient privileges
BACKUP_DIR="backups"                # Directory to store local backups
REMOTE_USER="root"                   # Remote server SSH username
REMOTE_HOST=""  # Remote server IP or hostname
REMOTE_DIR=".edoc_backups"  # Remote server directory to store backups

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get the current date and time for naming the backup file
DATE=$(date +%F_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"

# Dump PostgreSQL database
docker exec -t "$CONTAINER_NAME" pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"
#tar -czvf minio_data_backup_$(date +%Y%m%d_%H%M%S).tar.gz /path/to/local/data/folder


# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"

    # Transfer the backup to the remote server using scp or rsync
    #scp "$BACKUP_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
    rsync -avz --progress "$BACKUP_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

    # Optionally, clean up old local backup files (keep last 7 backups, for example)
    find "$BACKUP_DIR" -type f -mtime +7 -name "*.sql" -exec rm {} \;

else
    echo "Backup failed!"
fi
