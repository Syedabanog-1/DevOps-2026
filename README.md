# 🚀 DevOps 2026 — 36-Week Job-Ready Engineering Track

<div align="center">

![DevOps](https://img.shields.io/badge/DevOps-2026-blue?style=for-the-badge&logo=azure-devops)
![Status](https://img.shields.io/badge/Status-In%20Progress-green?style=for-the-badge)
![Weeks](https://img.shields.io/badge/Weeks-36-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-purple?style=for-the-badge)

**A production-grade, autonomous 36-week DevOps engineering curriculum.**  
Every week includes: concept notes, hands-on labs (executed via WSL/Linux), incident simulations, and Root Cause Analysis (RCA) reports.

[View Progress](#-progress-tracker) · [Curriculum](#-curriculum) · [Usage](#-usage)

</div>

---

## 🎯 Program Objectives

This curriculum is designed to make an engineer **job-ready for a Senior DevOps / Platform Engineering role** by:

1. Mastering Linux, Networking, and CLI proficiency
2. Implementing modern Git workflows (Trunk-Based Development, PRs, CI gates)
3. Automating infrastructure with Python, Bash, YAML, and Terraform
4. Orchestrating containerized workloads with Docker and Kubernetes
5. Building production-grade CI/CD pipelines on GitHub Actions and Azure DevOps
6. Operating monitoring stacks (Prometheus, Grafana, Loki)
7. Implementing DevSecOps, Secrets Management, and SRE practices

---

## 📚 Curriculum

### Phase 1: Linux + Networking Foundations (Weeks 1–5) ✅
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 01 | DevOps Overview & SSH | SSH Key Setup | SSH Permission Denied |
| 02 | Linux Filesystem & Core Commands | mkdir, cp, mv, grep | Missing Config File |
| 03 | Permissions & Ownership | chmod, chown, Service Users | Log Write Permission Denied |
| 04 | Processes & Monitoring | ps, kill, signals | High CPU Runaway Process |
| 05 | Logs, Disk & Networking | df, du, curl, grep | Disk Full (No Space Left) |

### Phase 2: Git + Modern Workflow (Weeks 6–8) ✅
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 06 | Git Fundamentals | Commits, revert, log | git reset --hard recovery via reflog |
| 07 | Branching & Feature Toggles | Feature flags, merge | Commits made to wrong branch |
| 08 | PR Workflow & Code Review | CI simulation, lint gates | Merge conflict resolution |

### Phase 3: Python + YAML + Automation (Weeks 9–12)
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 09 | Python for DevOps | CLI tools, file I/O, subprocess | Broken Python script triage |
| 10 | YAML Deep Dive | Anchors, multi-doc, validation | Malformed YAML crash |
| 11 | Bash + Python Automation | Health-check scripts, argparse | Silent script failure |
| 12 | Cron Jobs & Scheduling | Crontab, systemd timers | Missed cron, disk fills up |

### Phase 4: Docker + Containers (Weeks 13–16)
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 13 | Docker Fundamentals | Run, exec, inspect, logs | Container exits immediately |
| 14 | Dockerfile & Image Building | Multi-stage builds, layers | Image build failure triage |
| 15 | Docker Compose | Multi-container apps | Service dependency crash |
| 16 | Container Security & Registry | Trivy scan, ECR/ACR push | Vulnerable image blocked |

### Phase 5: Kubernetes (Weeks 17–20)
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 17 | K8s Architecture & Pods | kubectl run, exec, logs | CrashLoopBackOff |
| 18 | Deployments, Services & Ingress | Rolling updates, rollback | ImagePullBackOff |
| 19 | ConfigMaps, Secrets & Volumes | Mount secrets, PVC | Missing secret crash |
| 20 | Helm + K8s Incident Response | Helm install, upgrade, rollback | OOMKilled pod |

### Phase 6: Terraform + Azure IaC (Weeks 21–24)
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 21 | Terraform Fundamentals | init, plan, apply, destroy | State lock / drift |
| 22 | Azure Provider & Resources | VMs, VNet, NSG | Resource destroyed in plan |
| 23 | Modules & Remote State | Module calls, Azure Blob backend | Corrupted state file |
| 24 | Terraform in CI/CD | Plan in PR, apply on merge | Broken pipeline, manual state fix |

### Phase 7: CI/CD Pipelines (Weeks 25–28)
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 25 | GitHub Actions | Workflows, matrix builds | Flaky test blocking deploy |
| 26 | Azure DevOps Pipelines | YAML pipelines, stages | Pipeline approval gate failure |
| 27 | Multi-Stage Pipelines | Build → Test → Deploy | Failed rollback recovery |
| 28 | Pipeline Security & Artifacts | SAST, signing, caching | Secret exposed in logs |

### Phase 8: Monitoring + Observability (Weeks 29–32)
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 29 | Prometheus & Metrics | Exporters, PromQL, scrape | Metrics scrape target down |
| 30 | Grafana Dashboards | Panels, datasources, alerts | Silent alert (misconfigured rule) |
| 31 | Log Aggregation | Loki, Promtail, log queries | Log pipeline failure |
| 32 | Alerting & On-Call | AlertManager, PagerDuty | Alert storm suppression |

### Phase 9: Security + SRE + Capstone (Weeks 33–36)
| Week | Topic | Lab | Incident Simulation |
|------|-------|-----|---------------------|
| 33 | DevSecOps & Scanning | SAST (Semgrep), DAST, Trivy | Vulnerable dependency in prod |
| 34 | Secrets Management | Azure Key Vault, OIDC auth | Hardcoded secret in code |
| 35 | SRE Principles & SLO | SLI/SLO/SLA, error budgets | SLO breach post-mortem |
| 36 | Capstone Project | Full stack: IaC + CI/CD + Monitoring | Multi-service outage RCA |

---

## 📁 Repository Structure

```
DevOps-2026/
├── .github/
│   └── workflows/
│       └── ci.yml            # GitHub Actions CI workflow
├── Week-01/
│   ├── day1-concepts.md      # Theory & concept notes
│   ├── lab-day2-*.sh         # Hands-on lab script (WSL executable)
│   └── incident-day3-*.sh    # Incident simulation + RCA generator
├── Week-02/ ...
├── Week-36/
└── README.md
```

---

## 🚦 Progress Tracker

| Phase | Weeks | Status |
|-------|-------|--------|
| Phase 1: Linux + Networking | 1–5 | ✅ Complete |
| Phase 2: Git + Modern Workflow | 6–8 | ✅ Complete |
| Phase 3: Python + YAML + Automation | 9–12 | ✅ Complete |
| Phase 4: Docker + Containers | 13–16 | ✅ Complete |
| Phase 5: Kubernetes | 17–20 | ✅ Complete |
| Phase 6: Terraform + Azure IaC | 21–24 | ✅ Complete |
| Phase 7: CI/CD Pipelines | 25–28 | ✅ Complete |
| Phase 8: Monitoring + Observability | 29–32 | ✅ Complete |
| Phase 9: Security + SRE + Capstone | 33–36 | ✅ Complete |

---

## 🛠 Usage

### Prerequisites
- Windows with WSL2 (Ubuntu recommended)
- Git, Python 3.9+, Docker Desktop
- Azure CLI (`az`) and Terraform installed

### Running a Lab
```bash
# Execute any lab script directly in WSL:
wsl bash Week-09/lab-day2-python.sh

# Run as root for permission/system labs:
wsl -u root bash Week-03/lab-day2-permissions.sh
```

### Running an Incident Simulation
```bash
# Simulate an incident and auto-generate the RCA markdown:
wsl bash Week-05/incident-day3-disk-full.sh
# RCA will be saved to /tmp/devops2026-*/RCA-*.md
```

---

## 🤝 Author

**Syeda Gulzar Bano** | DevOps Engineering Track 2026  
GitHub: [@Syedabanog-1](https://github.com/Syedabanog-1)

---

*Built autonomously using the Antigravity AI DevOps Architect workflow.*
