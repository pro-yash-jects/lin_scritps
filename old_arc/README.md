# File Archiver Script

A bash script that automatically archives old files from user directories to help maintain system cleanliness and free up disk space.

## Description

`old_arc.sh` is an automated file archiving solution that identifies files older than a specified threshold and creates tar archives of them. The script targets common user directories and provides logging for audit purposes.

## Features

- **Automatic file discovery**: Scans specified directories for files older than threshold
- **Tar archive creation**: Creates uncompressed tar archives with timestamp naming
- **Comprehensive logging**: Logs all archiving activities with timestamps
- **Configurable threshold**: Easy to modify age threshold for file archiving
- **Safe operation**: Includes commented deletion option for careful deployment
- **Multiple directory support**: Targets Downloads, Documents, Desktop, Pictures, and Videos

## Prerequisites

- **Bash shell**: Script requires bash environment
- **tar utility**: For creating archives (usually pre-installed on Linux systems)
- **find command**: For locating old files (standard on Unix-like systems)
- **Sufficient disk space**: Ensure adequate space in archive directory for tar files

## Installation

1. **Download the script**:
   ```bash
   wget https://raw.githubusercontent.com/pro-yash-jects/file-archiver/main/old_arc.sh
   # or clone the repository
   git clone https://github.com/pro-yash-jects/lin_scripts.git
   cd old_arc
   ```

2. **Make the script executable**:
   ```bash
   chmod +x old_arc.sh
   ```

3. **Configure the script variables** (see Configuration section below)

## Configuration

Before running the script, modify the following variables in the script:

### Essential Variables

```bash
# Change this to your username
TUSER="r00ted"

# Number of days - files older than this will be archived
THRESHOLD_DAYS=10

# Directory where archives will be stored
ARCHIVE_DIR="/home/$TUSER/FileArchives"

# Log file location
LOGFILE="/var/log/file_archiver.log"
```

### Target Directories

By default, the script targets these directories:
- `/home/$TUSER/Downloads`
- `/home/$TUSER/Documents`
- `/home/$TUSER/Desktop`
- `/home/$TUSER/Pictures`
- `/home/$TUSER/Videos`

To modify target directories, edit the `TARGET_DIRS` array:
```bash
TARGET_DIRS=(
    "/home/$TUSER/Downloads"
    "/home/$TUSER/Documents"
    "/home/$TUSER/Desktop"
    "/home/$TUSER/Pictures"
    "/home/$TUSER/Videos"
    "/home/$TUSER/Music"        # Add additional directories as needed
)
```

## Usage

### Manual Execution

```bash
# Run the script manually
sudo ./old_arc.sh
```

### Automated Execution with Cron

For regular automated archiving, add a cron job:

```bash
# Edit crontab
crontab -e

# Add one of these lines:
# Run daily at 2 AM
0 2 * * * /path/to/old_arc.sh

# Run weekly on Sunday at 3 AM
0 3 * * 0 /path/to/old_arc.sh

# Run monthly on the 1st at 1 AM
0 1 1 * * /path/to/old_arc.sh
```

### Dry Run Mode

To see what files would be archived without actually creating archives:

```bash
# Uncomment the 'cat "$TMP_ARCHIVE_LIST"' line in the script
# This will display the list of files that would be archived
```

## File Deletion

The script includes a commented-out deletion feature. To enable automatic deletion of original files after archiving:

1. **Test thoroughly first**: Run the script several times to ensure it works correctly
2. **Uncomment the deletion line**:
   ```bash
   # Change this line:
   #rm -f "$file"
   
   # To:
   rm -f "$file"
   ```

⚠️ **Warning**: Once enabled, this will permanently delete original files after archiving. Ensure you have proper backups and have tested the archiving process thoroughly.

## Log Files

The script creates detailed logs at `/var/log/file_archiver.log` (or your specified location) containing:
- Timestamp of each archived file
- Archive creation confirmations
- Information about runs with no files to archive

### Log File Permissions

Ensure the script has write permissions to the log file location:
```bash
# Create log file and set permissions
sudo touch /var/log/file_archiver.log
sudo chown $USER:$USER /var/log/file_archiver.log
```

## Archive Management

### Archive Naming Convention

Archives are named with timestamps: `archive_YYYY-MM-DD_HH-MM-SS.tar`

### Extracting Archives

To extract files from an archive:
```bash
# Extract all files
tar -xf /path/to/archive_2024-01-15_14-30-25.tar

# Extract specific file
tar -xf /path/to/archive_2024-01-15_14-30-25.tar path/to/specific/file

# List contents without extracting
tar -tf /path/to/archive_2024-01-15_14-30-25.tar
```

### Archive Cleanup

Consider implementing archive cleanup to prevent unlimited growth:
```bash
# Remove archives older than 90 days
find "$ARCHIVE_DIR" -name "archive_*.tar" -mtime +90 -delete
```

## Troubleshooting

### Common Issues

1. **Permission denied errors**:
   ```bash
   chmod +x old_arc.sh
   # Ensure script has execute permissions
   ```

2. **Log file write errors**:
   ```bash
   # Check log file permissions
   ls -la /var/log/file_archiver.log
   # Create if doesn't exist
   sudo touch /var/log/file_archiver.log
   sudo chown $USER:$USER /var/log/file_archiver.log
   ```

3. **Archive directory creation fails**:
   ```bash
   # Ensure parent directory exists and has proper permissions
   mkdir -p "/home/$TUSER/FileArchives"
   ```

4. **No files found**:
   - Check if target directories exist
   - Verify threshold days setting
   - Ensure files actually exist and are older than threshold

## Security Considerations

- **File permissions**: Ensure script and log files have appropriate permissions
- **Archive location**: Store archives in a secure location with proper access controls
- **Backup verification**: Always verify archives can be extracted before enabling deletion
- **Path traversal**: The script uses absolute paths to prevent directory traversal issues

## Customization

### Compression Options

To add compression to archives:
```bash
# Change archive creation line from:
tar -cf "$ARCHIVE_DIR/$ARCHIVE_NAME" -T "$TMP_ARCHIVE_LIST"

# To (for gzip compression):
tar -czf "$ARCHIVE_DIR/$ARCHIVE_NAME.tar.gz" -T "$TMP_ARCHIVE_LIST"
```

### Email Notifications

To add email notifications on archive creation:
```bash
# Add after archive creation
echo "Archive created: $ARCHIVE_DIR/$ARCHIVE_NAME" | mail -s "File Archive Created" user@example.com
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or contributions, please visit the GitHub repository or create an issue.

---

**Note**: Always test this script in a safe environment before using it on important data. Consider creating backups of your important files before running automated archiving scripts.
