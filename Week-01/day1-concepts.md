# Week 01 - Day 1: Concepts & Architecture

## 🎯 Topic: DevOps Overview, SDLC, Environments, SSH

---

## 1. What is DevOps?

DevOps is a **cultural and technical movement** that bridges the gap between:
- **Development** (writing code)
- **Operations** (running systems in production)

**Core Pillars:**
- Collaboration & shared ownership
- Automation (CI/CD, IaC, scripting)
- Continuous feedback (monitoring & observability)
- Fast, safe delivery

### DevOps Loop (Infinite)
```
Plan → Code → Build → Test → Release → Deploy → Operate → Monitor → Plan...
```

---

## 2. SDLC (Software Development Life Cycle)

| Phase     | What Happens                             | DevOps Responsibility |
|-----------|------------------------------------------|-----------------------|
| Plan      | Requirements gathering                   | Backlog, Story sizing |
| Code      | Developers write features                | Git branching, PRs    |
| Build     | Compile, package, containerize           | CI pipelines          |
| Test      | Unit, integration, security scans        | Automated test suites |
| Release   | Approval gates, versioning               | Release pipelines     |
| Deploy    | Push to environment                      | CD pipelines, Helm    |
| Operate   | Keep system running                      | On-call, runbooks     |
| Monitor   | Observe health, performance, errors      | Grafana, Alerts       |

---

## 3. Environments

```
DEV → SIT → UAT → PROD
```

| Environment | Purpose                              | Who Owns It       |
|-------------|--------------------------------------|-------------------|
| DEV         | Daily development, feature work      | Developers        |
| SIT         | System Integration Testing           | QA / DevOps       |
| UAT         | User Acceptance Testing              | Business / QA     |
| PROD        | Live system for end users            | Ops / DevOps      |

**Key Rule:** Changes ALWAYS flow left to right. Never deploy directly to PROD.

---

## 4. SSH (Secure Shell)

SSH is a cryptographic protocol for **secure remote server access**.

### How SSH Key Auth Works:
```
You (Client)                  Remote Server
────────────                  ─────────────
Private Key  ──(matches)──→  Public Key (in ~/.ssh/authorized_keys)
             ←── Access Granted ──
```

### Key Types (2026 Standard):
- **ED25519** ← Preferred (fast, small, secure)
- RSA 4096 (legacy, still common)

### Basic Server Hygiene:
- Always disable root SSH login (`PermitRootLogin no`)
- Use key-based auth only (`PasswordAuthentication no`)
- Change default SSH port from 22 (optional security)
- Keep system packages updated

---

## 5. AI Integration (Day 1 Practice)

Use AI to deepen understanding:

```bash
# Ask Claude or Copilot:
"Explain the difference between DEV, SIT, UAT and PROD environments
with real-world examples for a DevOps engineer"

"What is the most secure SSH configuration for a production Linux server in 2026?"

"Generate a Mermaid diagram showing the DevOps infinite loop"
```

---

## 🧠 Key Takeaways
1. DevOps = Culture + Automation + Measurement + Sharing
2. SDLC flows DEV → SIT → UAT → PROD, never backwards
3. SSH keys (ED25519) > passwords for server access
4. AI is your pair programmer — use it NOW, every day
