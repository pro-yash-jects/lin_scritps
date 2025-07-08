#!/bin/bash

#VARIABLES

THRESHOLD=5
BLOCKED_LIST="/var/log/blocked_ips.txt"
LOGFILE_OUT="/var/log/suspicious_logins.log"

# checks log source according to different distros

if [ -f /var/log/secure ]; then
    LOGFILE="/var/log/secure"
    LOGTYPE="file"
	#for centos and rhel kind of systems
elif [ -f /var/log/auth.log ]; then
    LOGFILE="/var/log/auth.log"
    LOGTYPE="file"
	#for debian systems
elif command -v journalctl &>/dev/null; then
    LOGTYPE="journalctl"
	#for arch systems
else
    echo "[ERROR] No valid log source found." >&2
    exit 1
fi

# create blocked list file 
touch "$BLOCKED_LIST"

# --- Get failed SSH login attempts ---
if [ "$LOGTYPE" = "file" ]; then
    ATTEMPTS=$(grep "sshd" "$LOGFILE" | grep "Failed password" | awk '{for(i=1;i<=NF;i++) if ($i=="from") print $(i+1)}')
else
    ATTEMPTS=$(journalctl --since "15 minutes ago" | grep "sshd" | grep "Failed password" \
  | awk '{for(i=1;i<=NF;i++) if ($i=="from") print $(i+1)}')

fi

# --- Count failed attempts per IP ---
echo "$ATTEMPTS" | sort | uniq -c | while read COUNT IP; do
    if [ "$COUNT" -ge "$THRESHOLD" ]; then

        # Skip if already blocked
        if grep -q "$IP" "$BLOCKED_LIST"; then
            continue
        fi

        # Block the IP using iptables
        iptables -A INPUT -s "$IP" -j DROP
	echo "Blocked $IP"
        # Log the action
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        echo "[$TIMESTAMP] Blocked IP: $IP | Failed Attempts: $COUNT" >> "$LOGFILE_OUT"
        echo "$IP" >> "$BLOCKED_LIST"

    fi
done

