#!/bin/bash

#variables

TUSER="r00ted"
THRESHOLD_DAYS=10
ARCHIVE_DIR="/home/$TUSER/FileArchives"
LOGFILE="/var/log/file_archiver.log"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE_NAME="archive_$TIMESTAMP.tar"
TMP_ARCHIVE_LIST="/tmp/old_files_$TIMESTAMP.txt"

#target directories

TARGET_DIRS=(
    "/home/$TUSER/Downloads"
    "/home/$TUSER/Documents"
    "/home/$TUSER/Desktop"
    "/home/$TUSER/Pictures"
    "/home/$TUSER/Videos"
)

#make the dir if doesn't exist
mkdir -p "$ARCHIVE_DIR"

#make temp file and store the name of files to be archived
> "$TMP_ARCHIVE_LIST"
for dir in "${TARGET_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        find "$dir" -type f -mtime +$THRESHOLD_DAYS >> "$TMP_ARCHIVE_LIST"
    fi
done

#cat "$TMP_ARCHIVE_LIST"

#create the archive (without compression)
if [ -s "$TMP_ARCHIVE_LIST" ]; then
    tar -cf "$ARCHIVE_DIR/$ARCHIVE_NAME" -T "$TMP_ARCHIVE_LIST"

    # Log and delete originals
    while IFS= read -r file; do
        echo "[$(date)] Archived: $file" >> "$LOGFILE"
        #rm -f "$file"
    done < "$TMP_ARCHIVE_LIST"

    echo "[$(date)] Archive created: $ARCHIVE_DIR/$ARCHIVE_NAME" >> "$LOGFILE"
else
    echo "[$(date)] No files older than $THRESHOLD_DAYS days found." >> "$LOGFILE"
fi

rm -f "$TMP_ARCHIVE_LIST"
