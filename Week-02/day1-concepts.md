# Week 02 - Day 1: Linux Filesystem & Core Commands

## 🎯 Topic: Filesystem Hierarchy, Navigation, Core Utilities

---

## 1. The Linux Filesystem Standard (FHS)

Linux treats everything as a file (even hardware devices). The root of the filesystem is `/`.

### Key Directories (Know these for the job):
- `/` - The Root directory.
- `/bin` & `/usr/bin` - Essential user command binaries (ls, grep, cat).
- `/sbin` - System binaries (commands for root).
- `/etc` - Configuration files (e.g., `/etc/nginx/nginx.conf`, `/etc/ssh/sshd_config`).
- `/var` - Variable data. Crucially, logs live in `/var/log`.
- `/home` - User directories (`/home/alice`).
- `/root` - The root user's home directory.
- `/tmp` - Temporary files (cleared on reboot).
- `/opt` - Optional/third-party software.

---

## 2. Paths: Absolute vs. Relative

- **Absolute Path:** Starts from root (`/`). Example: `/var/log/syslog`
- **Relative Path:** Starts from current location. Example: `./logs/syslog` (where `.` means current directory and `..` means parent directory).

---

## 3. Core Commands (Daily usage in DevOps)

| Command | Action | Real-world example |
|---------|--------|--------------------|
| `pwd` | Print working directory | "Where am I currently in the shell?" |
| `ls` | List contents | `ls -la` (list all, long format to see hidden files and perms) |
| `cd` | Change directory | `cd /var/log` |
| `mkdir` | Make directory | `mkdir -p /opt/myapp/config` (creates parents if missing) |
| `cp` | Copy file/dir | `cp nginx.conf nginx.conf.bak` |
| `mv` | Move/Rename | `mv old-log.txt archive/` |
| `rm` | Remove | `rm -rf tmp-dir/` (Dangerous! Be careful) |
| `cat` | Concatenate/print | `cat /etc/os-release` |
| `less` | View paginated | `less /var/log/syslog` (Press 'q' to quit, '/' to search) |
| `grep` | Search text | `grep "ERROR" /var/log/app.log` |
| `tail` | View end of file | `tail -f /var/log/app.log` (follows logs in real-time) |

---

## 4. AI Integration (Day 1 Practice)

Use AI to explain specific command flags:

```bash
# Ask Claude or Copilot:
"What does the -p flag do in mkdir -p /var/www/html?"
"How do I use grep to find all case-insensitive occurrences of 'timeout' in /var/log/syslog?"
```

---

## 🧠 Key Takeaways
1. `/etc` is for configs, `/var/log` is for logs.
2. `tail -f` and `grep` are your best friends during an outage.
3. Always verify your working directory (`pwd`) before running destructive commands (`rm`).
