# SSH Intrusion Detection and Auto-Block Script

A lightweight bash script that monitors SSH login attempts and automatically blocks IP addresses with excessive failed login attempts using iptables.

## Overview

This script provides automated protection against SSH brute-force attacks by:
- Monitoring SSH logs for failed login attempts
- Counting failed attempts per IP address
- Automatically blocking IPs that exceed the configured threshold
- Maintaining a persistent blocked IP list
- Logging all blocking actions for audit purposes

## Features

- **Multi-Distribution Support**: Works with CentOS/RHEL, Debian/Ubuntu, and Arch Linux
- **Configurable Threshold**: Set custom limits for failed login attempts
- **Persistent Blocking**: Maintains a blocked IP list across script runs
- **Comprehensive Logging**: Records all blocking actions with timestamps
- **Duplicate Protection**: Prevents re-blocking already blocked IPs

## Requirements

- Linux system with SSH service running
- Root privileges (for iptables manipulation)
- One of the following log sources:
  - `/var/log/secure` (CentOS/RHEL)
  - `/var/log/auth.log` (Debian/Ubuntu)
  - `journalctl` (systemd-based systems)

## Installation

1. Download the script:
```bash
git clone https://github.com/pro-yash-jects/lin_scripts.git

cd lin_scripts/sus_login
```

2. Make it executable:
```bash
chmod +x sus_login.sh
```

3. Run with root privileges:
```bash
sudo ./sus_login.sh
```

## Configuration

### Variables (at the top of the script)

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `THRESHOLD` | 5 | Number of failed attempts before blocking |
| `BLOCKED_LIST` | `/var/log/blocked_ips.txt` | File to store blocked IP addresses |
| `LOGFILE_OUT` | `/var/log/suspicious_logins.log` | Log file for blocking actions |

### Customization Examples

**Lower threshold for stricter security:**
```bash
THRESHOLD=3
```

**Custom file locations:**
```bash
BLOCKED_LIST="/etc/security/blocked_ips.txt"
LOGFILE_OUT="/var/log/security/ssh_blocks.log"
```

## Usage

### Manual Execution
```bash
sudo ./sus_login.sh
```

### Automated Execution (Recommended)
Set up a cron job to run the script every 15 minutes:

```bash
sudo crontab -e
```

Add the following line:
```bash
*/15 * * * * /path/to/sus_login.sh
```


## Log Files

### Blocked IPs List (`/var/log/blocked_ips.txt`)
Contains one IP address per line of all blocked IPs:
```
192.168.1.100
203.0.113.45
198.51.100.30
```

### Action Log (`/var/log/suspicious_logins.log`)
Contains timestamped blocking actions:
```
[2025-07-08 14:30:15] Blocked IP: 192.168.1.100 | Failed Attempts: 7
[2025-07-08 14:45:22] Blocked IP: 203.0.113.45 | Failed Attempts: 12
```

## Troubleshooting

### Common Issues

**1. "No valid log source found" Error**
```bash
# Check if log files exist
ls -la /var/log/secure /var/log/auth.log

# Check if journalctl is available
which journalctl
```

**2. Permission Denied**
```bash
# Run with sudo
sudo ./sus_login.sh

# Check file permissions
ls -la sus_login.sh
```

**3. iptables Command Not Found**
```bash
# Install iptables (Debian/Ubuntu)
sudo apt-get install iptables

# Install iptables (CentOS/RHEL)
sudo yum install iptables-services
```

### Debugging

Enable verbose output by adding debug statements:
```bash
# Add after the shebang line
set -x  # Enable debug mode
```

Check current iptables rules:
```bash
sudo iptables -L INPUT -v -n
```

## Security Considerations

### Important Warnings

1. **Backup Your iptables Rules**: Before running, backup your current iptables configuration:
```bash
sudo iptables-save > /tmp/iptables-backup.rules
```

2. **Whitelist Your IP**: Ensure your management IP is whitelisted to prevent self-lockout:
```bash
sudo iptables -I INPUT -s YOUR_IP -j ACCEPT
```

3. **Test in Non-Production**: Test the script in a non-production environment first

### Limitations

- **Legitimate User Lockout**: May block legitimate users who mistype passwords
- **IP Spoofing**: Cannot prevent attacks using spoofed IP addresses
- **Distributed Attacks**: Less effective against distributed brute-force attacks
- **IPv6**: Currently only supports IPv4 addresses

## Advanced Usage

### Unblocking IPs

To unblock an IP address:
```bash
# Remove from iptables
sudo iptables -D INPUT -s IP_ADDRESS -j DROP


```

### Viewing Blocked IPs
```bash
# View all blocked IPs
cat /var/log/blocked_ips.txt

# View recent blocks
tail -f /var/log/suspicious_logins.log
```

### Custom Integration

The script can be extended to:
- Send email notifications
- Integrate with fail2ban
- Use different blocking methods (firewalld, ufw)
- Add geographic IP filtering

## System Compatibility

| Distribution | Log Source | Status |
|-------------|------------|---------|
| CentOS 7/8 | `/var/log/secure` | ✅ Supported |
| RHEL 7/8/9 | `/var/log/secure` | ✅ Supported |
| Ubuntu 18.04+ | `/var/log/auth.log` | ✅ Supported |
| Debian 9+ | `/var/log/auth.log` | ✅ Supported |
| Arch Linux | `journalctl` | ✅ Supported |
| Fedora | `journalctl` | ✅ Supported |

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This script is provided "as is" without warranty. Use at your own risk.

## Support

For issues and questions:
- Check the troubleshooting section
- Review system logs
- Ensure proper permissions and requirements


