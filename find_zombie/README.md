# Zombie Process Detector (`find_zombie`)

This script detects zombie processes on your system and logs the details. It also supports optional email alerts to notify admins when zombies are found. Built to be minimal, secure, and cron-friendly.

Part of the [`lin_scripts`](https://github.com/pro-yash-jects/lin_scritps) collection.

---

## 🧠 What It Does

- Scans the process table for zombie processes (`STAT = Z`)
- Logs detected zombies to `/var/log/zombie_processes.log`
- Sends email alerts to recipients listed in `/etc/zombie_notify.conf`
- Can be run manually or via cron
- Includes an optional (commented-out) auto-reap block to try killing the parent process

---

## 🧪 What Is a Zombie Process?

A zombie is a defunct child process that has completed execution but hasn't been reaped by its parent. It remains in the process table, potentially consuming PID slots over time. This script helps detect and alert when such processes appear.

---

## 🧪 Testing the Script with `zombie.c`

To help with testing, this project includes a `zombie.c` file that creates a zombie process.  
You can compile and run it like this:

```bash
gcc zombie.c -o zombie
./zombie
```

This will spawn a child that exits immediately, while the parent continues to run — creating a true zombie process that your script can detect.

---

## 🛠 How to Use

### 1. Clone the Repo
```bash
git clone https://github.com/pro-yash-jects/lin_scritps.git

cd lin_scritps/find_zombie
```

### 2. Set Up Email Notifications (Optional)
Create a file at `/etc/zombie_notify.conf` with one email per line:
```
abc@gmail.com
xyz@gmail.com
```
Then secure it:
```bash
sudo chmod 600 /etc/zombie_notify.conf
```

### 3. Run the Script
```bash
sudo ./find_zombie.sh
```

### 4. Set as a Cron Job (Optional)
```bash
sudo crontab -e
```
Add:
```
*/30 * * * * /path/to/find_zombie.sh
```

---

## 🧩 Dependencies

- Standard Unix tools: `ps`, `awk`, `grep`, `mail`
- For email: `msmtp` + `mailx`

---

## ⚠️ Optional Auto-Reap

The script includes a commented-out section that will send a `SIGHUP` to the parent processes of detected zombies. Use it with caution — only if you're confident about what those parents are doing.

---

## 📄 License

MIT — free to use and adapt.

Maintained by [Yash](https://github.com/pro-yash-jects)
