#!/bin/bash
# It's based on dropbox_uploader.sh
# wget --no-check-certificate https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh
# wget --no-check-certificate https://raw.github.com/AntonioChen/Backup2Dropbox/master/backup2Dropbox.sh

SCRIPT_DIR="/root/backup"	#The folder of dropbox_uploader.sh
DROPBOX_DIR="/"			#The folder in Dropbox

BACKUP_FILE=0
FILE_SRC="/svn /www"		#The folder to backup, using blank between different paths

BACKUP_MYSQL=0
MYSQL_SERVER="localhost"
MYSQL_USER="root"
MYSQL_PASS="123456"

BACKUP_CRON=1
#---------------DON'T EDIT---------------
BACKUP_DST="/tmp"		#tmp folder

WEEK=$(date +"%A")
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
DESTFILE="$BACKUP_DST/$NOW.tar.gz"
TARFILE=""

# Select file
if [ $BACKUP_FILE -eq 1 ]
then
	echo "Select file."
	TARFILE=$FILE_SRC
else
	echo "Skip selecting file."
fi

# Mysql
if [ $BACKUP_MYSQL -eq 1 ]
then
	echo "Back up mysql."
	mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS --all-databases > "$NOW-Databases.sql"
	TARFILE=$TARFILE" $NOW-Databases.sql"
else
	echo "Skip backing up mysql."
fi

# Backup crontab
if [ $BACKUP_CRON -eq 1 ]
then
	echo "Back up crontab."
	crontab -l >> "$NOW-crontab.txt"
	TARFILE=$TARFILE" $NOW-crontab.txt"
else
	echo "Skip Backing up crontab."
fi

# Tar all files
if [ $BACKUP_FILE -eq 1 -o $BACKUP_MYSQL -eq 1 -o $BACKUP_CRON -eq 1 ]
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
	echo "rm -f $NOW-Databases.sql $NOW-crontab.txt $DESTFILE"
	rm -f "$NOW-Databases.sql $NOW-crontab.txt $DESTFILE"
else
	echo "No files to upload"
fi
echo "backup2Dropbox finished."
