#!/bin/bash
# It's based on dropbox_uploader.sh
# wget --no-check-certificate https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh
# wget --no-check-certificate https://raw.github.com/AntonioChen/Backup2Dropbox/master/backup2Dropbox.sh

SCRIPT_DIR="/root/backup"	#The folder of dropbox_uploader.sh
DROPBOX_DIR=""			#The folder in Dropbox

BACKUP_FILE=0
FILE_SRC="/svn /www"		#The folder to backup, using blank between different paths
EXCLUDE_SRC="/root/lnmp0.9"	#The exclude folder

BACKUP_MYSQL=0
MYSQL_SERVER="localhost"
MYSQL_USER="root"
MYSQL_PASS="123456"

BACKUP_CRON=1

#---------------DON'T EDIT---------------
export SCRIPT_DIR
export DROPBOX_DIR

export BACKUP_FILE
export FILE_SRC
export EXCLUDE_SRC

export BACKUP_MYSQL
export MYSQL_SERVER
export MYSQL_USER
export MYSQL_PASS

export BACKUP_CRON

$SCRIPT_DIR/backup.sh