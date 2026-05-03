# Week 05 - Day 1: Logs, Disk, and Networking Basics

## 🎯 Topic: Log Analysis, Disk Management, and Core Networking

---

## 1. Logs & System Journal

Logs are the primary source of truth during an incident.
- **Traditional Logs:** Stored in `/var/log` (e.g., `/var/log/syslog`, `/var/log/auth.log`, `/var/log/nginx/access.log`).
- **journald (Systemd Journal):** Modern Linux uses `journald` to collect binary logs.
  - View all logs: `journalctl`
  - View specific service logs: `journalctl -u nginx`
  - Follow real-time: `journalctl -f -u nginx`
- **Log Rotation:** Logs grow forever unless rotated. Linux uses `logrotate` to compress and delete old logs automatically (configured in `/etc/logrotate.d/`).

---

## 2. Disk & Inodes

Storage incidents are incredibly common (e.g., "No space left on device").
- **df -h:** Display free disk space on all mounted filesystems in human-readable format (MB/GB).
- **du -sh /path/to/dir:** Show total size of a specific directory. Useful for hunting down large files.
- **Inodes (`df -i`):** Inodes represent files on the filesystem. If you have millions of tiny 1kb files, you can run out of *inodes* even if you have 50GB of *disk space* left!

---

## 3. Core Networking (Ping, DNS, HTTP)

When an app cannot reach a database or external API, check these layers:
1. **IP Routing (ping):** `ping 8.8.8.8` (Checks basic ICMP connectivity. Note: Some servers block ping).
2. **DNS Resolution (dig/nslookup):** `dig api.github.com` (Translates human readable names to IP addresses).
3. **HTTP/API Connectivity (curl):** `curl -v https://api.github.com` (Tests the application layer, SSL handshake, and HTTP response codes).

### Cloud Networking Preview (Azure)
- **VNet (Virtual Network):** Your private cloud network.
- **Subnets:** Slices of your VNet (e.g., public subnet for Load Balancers, private subnet for Databases).
- **NSG (Network Security Group):** Cloud firewalls that allow/deny traffic on specific ports.

---

## 4. AI Integration (Day 1 Practice)

```bash
# Ask Claude or Copilot:
"Explain the output of 'df -h' and 'df -i', and why a server might fail with 'No space left' when 'df -h' shows 20GB free."
"Write a bash script that uses curl to check if a website returns an HTTP 200 OK status, and prints an error if it doesn't."
```

---

## 🧠 Key Takeaways
1. Use `journalctl -u <service>` instead of tailing raw files when working with systemd services.
2. If disk is full, use `du -h --max-depth=1 /` to find the culprit directory.
3. Network troubleshooting is a layered process: Ping (L3) → DNS (L7) → Curl (L7).
