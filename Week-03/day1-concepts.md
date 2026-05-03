# Week 03 - Day 1: Users, Permissions & Ownership

## 🎯 Topic: chmod, chown, Groups, Service Accounts

---

## 1. Linux Permissions Model (The 3x3 Grid)

Linux permissions are assigned to three entities:
1. **User (u)** - The owner of the file.
2. **Group (g)** - The group that owns the file.
3. **Others (o)** - Everyone else on the system.

For each entity, you can grant three types of access:
- **Read (r)** = 4
- **Write (w)** = 2
- **Execute (x)** = 1

### Calculating Permissions (Octal):
Add the numbers together to get the permission level.
- `rwx` = 4 + 2 + 1 = **7**
- `rw-` = 4 + 2 + 0 = **6**
- `r--` = 4 + 0 + 0 = **4**

**Example:** `chmod 644 file.txt`
- User: `6` (`rw-`) - Read & Write
- Group: `4` (`r--`) - Read only
- Other: `4` (`r--`) - Read only

---

## 2. Important Commands

| Command | Action | Example |
|---------|--------|---------|
| `chmod` | Change mode/permissions | `chmod 755 script.sh` (make executable) |
| `chown` | Change owner/group | `chown myuser:mygroup app.log` |
| `id`    | Show user identity/groups | `id` or `id www-data` |
| `umask` | Default permission mask | `umask 022` (new files get 644, dirs 755) |

---

## 3. Service Ownership Models (Crucial for DevOps)

**Never run applications as `root`.** If the app is compromised, the attacker has full control of the server.

### The Standard Service Model:
1. Create a dedicated service user with no login shell (`useradd -s /sbin/nologin myapp`).
2. Give that user ownership ONLY to the directories it absolutely needs (e.g., `/var/log/myapp` and `/opt/myapp`).
3. Run the application process as that specific user (usually via `systemd`).

---

## 4. AI Integration (Day 1 Practice)

```bash
# Ask Claude or Copilot:
"If I have a file with permissions '-rwxr-xr--', what is the octal equivalent and what does it mean?"
"Write a bash script to recursively change ownership of /var/www/html to the www-data user."
```

---

## 🧠 Key Takeaways
1. `chmod` changes WHAT you can do; `chown` changes WHO owns it.
2. `777` is NEVER the right answer for fixing permission denied errors in production.
3. Always isolate services using dedicated, non-privileged users.
