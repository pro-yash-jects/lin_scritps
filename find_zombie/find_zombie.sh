#!/bin/bash


LOGFILE="/var/log/zombie_processes.log"
EMAIL_FILE="/etc/zombie_notify.conf"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# find zombie
ZOMBIES=$(ps -eo pid,ppid,user,stat,comm --sort=pid | awk '$4 ~ /Z/')

# If no zombies, exit
if [ -z "$ZOMBIES" ]; then
    echo "[$TIMESTAMP] ✅ No zombie processes found." >> "$LOGFILE"
    exit 0
fi

# Log header
echo "[$TIMESTAMP] ⚠️ Zombie processes detected:" >> "$LOGFILE"
echo "$ZOMBIES" >> "$LOGFILE"

# Send email alert
if [ -f "$EMAIL_FILE" ]; then
    while IFS= read -r EMAIL; do
        [[ -z "$EMAIL" ]] && continue  # skip empty lines

        mail -s "🧟 Zombie Processes Detected on $(hostname)" "$EMAIL" <<EOF
Hello,

Zombie process(es) were detected on your system at $TIMESTAMP.

Details:
PID   PPID   USER   STAT   COMMAND
----------------------------------
$ZOMBIES

A zombie process is a defunct child process that hasn't been properly cleaned up.

You can inspect the parent PID (PPID) to determine if it needs to be manually terminated.

– Zombie Watchdog Script
EOF

    done < "$EMAIL_FILE"
fi

# --- OPTIONAL: Auto-reap parent of zombie (use at your own risk) ---
# echo "$ZOMBIES" | awk '{print $2}' | sort -u | while read PPID; do
#     kill -HUP "$PPID"
#     echo "[$TIMESTAMP] 🔪 Sent HUP to parent PID $PPID to reap zombie(s)." >> "$LOGFILE"
# done
