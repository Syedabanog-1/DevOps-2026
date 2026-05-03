# Week 04 - Day 1: Processes & Monitoring

## 🎯 Topic: Process Management, Resource Monitoring, and Signals

---

## 1. What is a Process?
A process is a running instance of a program. Every process has:
- **PID (Process ID):** A unique number identifying the process.
- **PPID (Parent Process ID):** The PID of the process that started it.
- **State:** Running, Sleeping, Stopped, or Zombie.

---

## 2. Process Monitoring Commands

| Command | Action | Use Case |
|---------|--------|----------|
| `ps aux` | List all running processes | Finding the PID of a crashed service |
| `top` | Real-time process monitoring | Quick check of CPU/Memory usage |
| `htop` | Interactive process viewer | Easier visualization and process killing (requires installation) |
| `free -m`| Show RAM usage in MB | Checking if a server is out of memory (OOM) |
| `df -h` | Show disk space | Checking for full disks (Week 5 preview) |

---

## 3. Signals & Termination (`kill`)

When you need to stop a process, you send it a **signal**.

| Signal | Number | Description | When to use |
|--------|--------|-------------|-------------|
| **SIGTERM**| 15 | Graceful termination | **Default.** Tells the app to save data and exit nicely. Always try this first! |
| **SIGKILL**| 9 | Immediate kill | **Force quit.** The app is instantly terminated by the kernel. Can cause data corruption. |
| **SIGHUP** | 1 | Hangup / Reload | Tells services (like Nginx) to reload configuration without stopping. |

**Examples:**
- Graceful stop: `kill 1234` (defaults to signal 15)
- Force kill: `kill -9 1234`
- Kill by name: `pkill nginx`

---

## 4. Backgrounding & Foregrounding (Job Control)

- Add `&` at the end of a command to run it in the background: `sleep 100 &`
- `jobs` lists background tasks.
- `fg %1` brings job #1 to the foreground.
- `CTRL+C` sends SIGINT (Interrupt).
- `CTRL+Z` sends SIGTSTP (Suspend/Pause).

---

## 5. AI Integration (Day 1 Practice)

```bash
# Ask Claude or Copilot:
"What does 'load average: 2.15, 1.50, 0.90' mean in the output of the 'top' command on a 4-core CPU?"
"Write a bash script that finds any process consuming more than 90% CPU and logs its PID."
```

---

## 🧠 Key Takeaways
1. Always try `kill -15` (SIGTERM) before `kill -9` (SIGKILL).
2. Use `ps aux | grep <name>` to quickly find a missing PID.
3. High CPU isn't always bad; high CPU *plus* unresponsiveness is an incident.
