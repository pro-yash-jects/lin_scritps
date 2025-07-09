#!/bin/bash

### System Update Tracker (Multi-Distro)
# Author: Yash

LOGFILE="/var/log/system_update_tracker.log"
EMAIL_FILE="/etc/system_update_notify.conf"
DISTRO=""
UPDATES=""
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Detect OS and assign update command
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "[$TIMESTAMP] ❌ Could not detect OS." >> "$LOGFILE"
    exit 1
fi

# Get updates based on distro
case "$DISTRO" in
    debian|ubuntu)
        UPDATES=$(apt list --upgradable 2>/dev/null | grep -v "^Listing..." | tail -n +1)
        ;;
    centos|rhel|rocky|almalinux)
        UPDATES=$(yum check-update 2>/dev/null)
        ;;
    arch)
        UPDATES=$(checkupdates 2>/dev/null)
        ;;
    *)
        echo "[$TIMESTAMP] ❌ Unsupported distro: $DISTRO" >> "$LOGFILE"
        exit 1
        ;;
esac

# If updates available, log and email
if [ -n "$UPDATES" ]; then
    echo "[$TIMESTAMP] ✅ Updates available on $DISTRO:" >> "$LOGFILE"
    echo "$UPDATES" >> "$LOGFILE"

    # Email notification
    if [ -f "$EMAIL_FILE" ]; then
        while IFS= read -r EMAIL; do
	    [[ -z "$EMAIL" ]] && continue	
            mail -s "🔄 System Updates Available" "$EMAIL" <<EOF
Hello,

Your system ($DISTRO) has pending updates as of $TIMESTAMP.

The following packages can be updated:

$UPDATES

You may want to run updates manually, or enable auto-updates.

– Update Tracker Script
EOF
        done < "$EMAIL_FILE"
    fi
else
    echo "[$TIMESTAMP] ✅ No updates found on $DISTRO." >> "$LOGFILE"
fi

# --- OPTIONAL: Uncomment to auto-install updates ---
# case "$DISTRO" in
#     debian|ubuntu)
#         apt update && apt upgrade -y
#         ;;
#     centos|rhel|rocky|almalinux)
#         yum update -y
#         ;;
#     arch)
#         pacman -Syu --noconfirm
#         ;;
# esac
