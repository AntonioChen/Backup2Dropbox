#!/bin/bash
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
	mysqldump -u$MYSQL_USER -h$MYSQL_SERVER -p$MYSQL_PASS --all-databases > "$NOW-Databases.sql"
	TARFILE=$TARFILE" $NOW-Databases.sql"
else
	echo "Skip backing up mysql."
fi

# Backup crontab
if [ $BACKUP_CRON -eq 1 ]
then
	echo "Back up crontab."
	crontab -l > "$NOW-crontab.txt"
	TARFILE=$TARFILE" $NOW-crontab.txt"
else
	echo "Skip Backing up crontab."
fi

# Tar all files
if [ $BACKUP_FILE -eq 1 -o $BACKUP_MYSQL -eq 1 -o $BACKUP_CRON -eq 1 ]
then
	echo "Tar all files: $TARFILE except $EXCLUDE_SRC"
	tar cfz "$DESTFILE" $TARFILE --exclude "$EXCLUDE_SRC"

	#Delete old files
	echo "Delete old files"
	$SCRIPT_DIR/dropbox_uploader.sh delete "$DROPBOX_DIR/$WEEK"

	# Upload
	echo "Upload to dropbox"
	$SCRIPT_DIR/dropbox_uploader.sh upload "$DESTFILE" "$DROPBOX_DIR/$WEEK/$NOW.tar.gz"

	# Delete local tmp file
	echo "Delete local tmp file"
	rm -f "$NOW-Databases.sql" "$NOW-crontab.txt" "$DESTFILE"
else
	echo "No files to upload"
fi

echo "backup2Dropbox finished."
