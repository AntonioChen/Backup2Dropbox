#!/bin/bash
# It's based on dropbox_uploader.sh
# https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh

SCRIPT_DIR="/root/Backup"	#The folder of dropbox_uploader.sh
DROPBOX_DIR="/VPSBackup"	#The folder in Dropbox

BACKUP_FILE=1
FILE_SRC="/svn /www"		#The folder to backup, using blank between different paths

BACKUP_MYSQL=1
MYSQL_SERVER="localhost"
MYSQL_USER="root"
MYSQL_PASS="123456"

#---------------DON'T EDIT---------------
BACKUP_DST="/tmp"				#tmp folder

WEEK=$(date +"%A")
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
DESTFILE="$BACKUP_DST/$NOW.tar.gz"
TARFILE=""
# Backup file
if [ $BACKUP_FILE -eq 1 ]
then
echo "Backup file."
TARFILE=$FILE_SRC
else
echo "Skip backup file."
fi

# Backup mysql
if [ $BACKUP_MYSQL -eq 1 ]
then
echo "Backup mysql."
mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS --all-databases > "$NOW-Databases.sql"
TARFILE=$TARFILE" $NOW-Databases.sql"
else
echo "Skip backup mysql."
fi

# Tar all files
if [ $BACKUP_FILE -eq 1 -o $BACKUP_MYSQL -eq 1 ]
then
echo "Tar all files: $TARFILE"
tar cfz "$DESTFILE" $TARFILE

#Delete old files
echo "Delete old files"
$SCRIPT_DIR/dropbox_uploader.sh delete "$DROPBOX_DIR/$WEEK"

# Upload
echo "Upload to dropbox"
$SCRIPT_DIR/dropbox_uploader.sh upload "$DESTFILE" "$DROPBOX_DIR/$WEEK/$NOW.tar.gz"

# Delete local tmp file
echo "Delete local tmp file"
rm -f "$NOW-Databases.sql" "$DESTFILE"

else
echo "No files to upload"
fi
echo "backup2Dropbox finished."