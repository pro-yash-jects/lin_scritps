# System Update Tracker (`track_up`)

This script checks for system package updates across multiple Linux distributions (Debian, CentOS/RHEL, Arch) and logs the results. It also supports email notifications if updates are available.

Part of the [`lin_scripts`](https://github.com/pro-yash-jects/lin_scritps) collection.

---

## 🧠 Features

- Supports multiple distros: Debian, Ubuntu, CentOS, RHEL, Arch
- Logs update info to `/var/log/system_update_tracker.log`
- Sends email notifications when updates are found
- Optional (commented out) auto-update block for those who want automation
- Cron-friendly and secure

---

## 📦 How to Use

### 1. Clone the Repo
```bash
git clone https://github.com/pro-yash-jects/lin_scritps.git
cd lin_scritps/track_up
```

### 2. Set Up Email Recipients File
Create a file at `/etc/system_update_notify.conf` with one email per line:
```
abc@gmail.com
```
Secure it:
```bash
sudo chmod 600 /etc/system_update_notify.conf
```

### 3. Run the Script
```bash
sudo ./track_up.sh
```

### 4. (Optional) Enable Auto-Updates
Uncomment the appropriate block at the bottom of the script if you want it to install updates automatically.

---

## 🛠 Dependencies

- Standard Bash tools (`grep`, `awk`, `date`, etc.)
- `mail` and `msmtp` (for email notifications)

Install:
- Arch: `sudo pacman -S msmtp mailx`
- CentOS: `sudo yum install msmtp mailx`

---

## 🧪 Testing

To test email notifications, lower the threshold temporarily by faking update output or installing dummy packages.

---

## 📄 License

MIT — use freely, modify as needed. Attribution appreciated.

Maintained by [Yash](https://github.com/pro-yash-jects)
