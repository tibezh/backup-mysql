#!/bin/sh

# Define database credentials.
DB_USER="root"
DB_PASS="123"
DB_HOST="localhost"
DB_NAME="crm"

# Define auto remove.
# For example: Remove files oldest than 5 days
DUMP_LIVE_DAYS=5

# Set permissions.
umask a+r

# Define backup dir.
BACKUP_DIR="/var/backups/mysql/${DB_NAME}"
if [ ! -d $BACKUP_DIR ]; then
  mkdir -p $BACKUP_DIR
  chmod 777 $BACKUP_DIR
fi

# Define filename.
DATE=$(date '+%d_%m_%Y_%H_%M_%S')
FILENAME="${DB_NAME}_${DATE}.sql"
FILE_DUMP="${BACKUP_DIR}/${FILENAME}"


# Make backup.
mysqldump -u$DB_USER -p$DB_PASS -h$DB_HOST $DB_NAME > $FILE_DUMP

# Make archive,
tar cfzP "${FILE_DUMP}.tar.gz" $FILE_DUMP
# Remove sql file.
rm $FILE_DUMP

# Remove old files.
find $BACKUP_DIR -type f -mtime "+${DUMP_LIVE_DAYS}" -exec rm -frv  {} \;
