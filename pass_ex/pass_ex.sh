#!/bin/bash

#variables
THRESHOLD=7
LOGFILE="/var/log/passwd_expiry_notifier.log"
TODAY=$(date +%s)  # current date in epoch seconds
EMAIL_FILE="/etc/passwd_notifier_emails.conf"

#get user emails from conf file
get_user_email() {
    grep "^$1:" "$EMAIL_FILE" 2>/dev/null | cut -d':' -f2-
}

# Only check users with real login shells
USERS=$(awk -F: '$7 ~ /(bash|zsh|sh)$/ {print $1}' /etc/passwd)

for user in $USERS; do
    EXPIRY_DATE=$(chage -l "$user" | grep "Password expires" | cut -d: -f2 | xargs)

    if [[ "$EXPIRY_DATE" == "never" || -z "$EXPIRY_DATE" ]]; then
        continue  # skip users with no expiry
    fi

    # Convert expiry date to epoch
    EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "[WARN] Could not parse expiry date for $user: $EXPIRY_DATE" >> "$LOGFILE"
        continue
    fi

    DAYS_LEFT=$(( (EXPIRY_EPOCH - TODAY) / 86400 ))

    if [ "$DAYS_LEFT" -le "$THRESHOLD" ]; then
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        echo "[$TIMESTAMP] User '$user' password expires in $DAYS_LEFT days on $EXPIRY_DATE" >> "$LOGFILE"
        echo "$user"
	EMAIL=$(get_user_email "$user")

        if [ -n "$EMAIL" ]; then
            mail -s "⚠️ Password Expiry Warning for '$user'" "$EMAIL" <<EOF
Hi $user,

This is an automated alert: your password is set to expire in $DAYS_LEFT day(s), on $EXPIRY_DATE.

Please change it soon to avoid being locked out:
  login then run "passwd"

— System Security Notifier
EOF
        else
            echo "[$TIMESTAMP] No email mapped for user '$user'" >> "$LOGFILE"
        fi
    fi
done
