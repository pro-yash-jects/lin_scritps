z# Password Expiry Notifier

A bash script that monitors user password expiration dates and sends email notifications when passwords are about to expire.

## Overview

This script checks password expiration dates for users with real login shells (bash, zsh, sh) and sends email notifications when passwords are within the specified threshold (default: 12 days). It uses the `chage` command to retrieve password expiry information and `msmtp` to send notifications via email.

## Features

- Monitors password expiry for users with real login shells
- Configurable expiry threshold (default: 12 days)
- Email notifications to users with expiring passwords
- Logging of all notifications and warnings
- Supports custom email configuration per user
- Skip users with passwords that never expire

## Prerequisites

Before using this script, you need to install and configure the following components:

### 1. msmtp

Install msmtp (Mail Transfer Agent):

```bash
# Ubuntu/Debian
sudo apt-get install msmtp msmtp-mta

# CentOS/RHEL/Fedora
sudo yum install msmtp

# Arch
sudo pacman -S msmtp msmtp-mta mailx  
```

### 2. User Email Configuration File

Create the email configuration file `/etc/passwd_notifier_emails.conf` with the following format:

```
username1:user1@example.com
username2:user2@example.com
root:admin@example.com
```

Each line should contain `username:email_address` pairs.

## Installation

1. Clone the repository:
```bash
git clone https://github.com/pro-yash-jects/lin_scripts.git
cd pass_ex
```

2. Make the script executable:
```bash
chmod +x pass_ex.sh
```

3. Configure msmtp (see configuration section below)

4. Create the email configuration file:
```bash
sudo nano /etc/passwd_notifier_emails.conf
```

## msmtp Configuration

### Basic Configuration

Create the msmtp configuration file at `/etc/msmtprc` or `~/.msmtprc`:

```bash
# Set default values for all following accounts
defaults
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log

# Gmail configuration
account gmail
host smtp.gmail.com
port 587
from your-email@gmail.com
user your-email@gmail.com
password your-app-password

# Set default account
account default : gmail
```

### Securing Passwords with GPG

For enhanced security, store your email password encrypted using GPG:

#### 1. Generate GPG Key (if you don't have one)

```bash
gpg --gen-key
```

Follow the prompts to create your key.

#### 2. Create Encrypted Password File

```bash
# Create encrypted password file
echo "your-app-password" | gpg --encrypt -o ~/.msmtp-password.gpg -r your-email@gmail.com
```

#### 3. Update msmtp Configuration

Replace the `password` line in your `~/.msmtprc` with:

```bash
passwordeval "gpg --quiet --for-your-eyes-only --no-tty --decrypt ~/.msmtp-password.gpg"
```

#### 4. Set Secure Permissions

```bash
chmod 600 ~/.msmtprc
chmod 600 ~/.msmtp-password.gpg
```

### Gmail App Password Setup

Since Gmail doesn't support "Less Secure Apps" anymore, you need to:

1. Enable 2-Factor Authentication on your Gmail account
2. Generate an App Password:
   - Go to Google Account settings
   - Security → 2-Step Verification → App passwords
   - Select "Mail" or "Other" and generate a password
   - Use this 16-character password in your msmtp configuration


## Configuration

### Script Variables

Edit the script to modify these variables:

- `THRESHOLD`: Number of days before expiry to send notifications (default: 12)
- `LOGFILE`: Path to log file (default: `/var/log/passwd_expiry_notifier.log`)
- `EMAIL_FILE`: Path to email configuration file (default: `/etc/passwd_notifier_emails.conf`)

### Email Configuration

The script reads user email addresses from `/etc/passwd_notifier_emails.conf`. Each line should contain:

```
username:email@domain.com
```

## Usage

### Manual Execution

```bash
sudo ./pass_ex.sh
```

### Automated Execution (Cron)

Add to crontab to run daily:

```bash
# Edit crontab
sudo crontab -e

```

### Testing

To test the script without sending emails:

```bash
# Test for a specific user
sudo chage -l username

# Check if msmtp is working
echo "Test message" | msmtp recipient@example.com
```

## Logging

The script logs all activities to `/var/log/passwd_expiry_notifier.log`. Log entries include:

- Users with expiring passwords
- Email notifications sent
- Warnings for parsing errors
- Timestamps for all actions

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure script has execute permissions and is run as root
2. **Email Not Sending**: Check msmtp configuration and test manually
3. **GPG Decryption Fails**: Ensure GPG key is properly configured and accessible
4. **User Not Found**: Verify email configuration file format

### Debug Mode

For debugging msmtp issues:

```bash
# Test msmtp with verbose output
echo "Test message" | msmtp -d recipient@example.com
```

### Log Analysis

Check the log file for issues:

```bash
tail -f /var/log/passwd_expiry_notifier.log
```

## Security Considerations

1. **File Permissions**: Ensure configuration files have appropriate permissions (600)
2. **GPG Encryption**: Use GPG to encrypt email passwords
3. **Log Security**: Protect log files from unauthorized access
4. **Regular Updates**: Keep msmtp and system packages updated

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Open an issue on GitHub
- Check the troubleshooting section
- Review msmtp documentation

## Changelog

### v1.0.0
- Initial release
- Basic password expiry monitoring
- Email notifications via msmtp
- Configurable threshold and logging
