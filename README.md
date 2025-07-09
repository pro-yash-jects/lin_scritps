# lin_scripts

⚙️ A collection of lightweight, practical Bash scripts for Linux system administration.  
These tools are built to automate routine sysadmin tasks — including monitoring, reporting, archiving, cleanup, and more.

Each script is designed to be cron-friendly, minimal, and compatible with most major Linux distributions (CentOS, Arch, Debian-based systems, etc.).

---

## 🧠 Overview

This repository contains scripts aimed at simplifying day-to-day Linux system administration tasks.

These scripts:
- Require minimal dependencies (only standard Linux CLI tools)
- Work across multiple distros with adaptive logic
- Are easy to audit, edit, and plug into cron jobs
- Follow good practices for security and system compatibility

More scripts will be added over time.

---

## 📦 Getting Started

### Clone the Repo:
```bash
git clone https://github.com/pro-yash-jects/lin_scritps.git
cd lin_scritps
```

### Run a Script:
```bash
sudo ./script_name.sh
```

> 🔐 Some scripts require root privileges or pre-setup (e.g., email configs).

### Make a Script Executable:
```bash
chmod +x script_name.sh
```

---

## 🔧 Requirements

Most scripts rely only on standard coreutils like:
- `awk`, `grep`, `find`, `cut`, `date`, etc.

Some optional scripts may require:
- `msmtp` + `mailx` (for sending email alerts)


---

## 🔐 Security Notes

Some scripts use config files (e.g., user-to-email mappings) that should be root-only readable:
```bash
sudo chmod 600 /etc/custom_config.conf
```

Passwords used with `msmtp` are encrypted using GPG and never stored in plaintext.

---

## 🚀 Use Cases (Examples)

This repo may include scripts for:
- Notifying users about upcoming password expiries
- Archiving stale files
- Blocking suspicious login attempts
- System health checks
- Log parsing & reporting

Each script is self-contained and explained via inline comments.

---

## 🤝 Contributing

Want to improve an existing script or add a new one?
- Fork the repo
- Create a new branch
- Open a PR

Ideas, fixes, or feedback are always welcome via issues or discussions.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).  
Use it, modify it, redistribute it — attribution appreciated, not required.

---

Built and maintained by [Yash](https://github.com/pro-yash-jects)
