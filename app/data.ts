export type Status = "done" | "active" | "pending";

export interface Week {
  week: number;
  topic: string;
  lab: string;
  incident: string;
  status: Status;
}

export interface Phase {
  id: number;
  name: string;
  weeks: Week[];
  color: string;
  icon: string;
}

export const phases: Phase[] = [
  {
    id: 1,
    name: "Linux + Networking Foundations",
    color: "from-emerald-500 to-teal-600",
    icon: "🐧",
    weeks: [
      { week: 1, topic: "DevOps Overview & SSH", lab: "SSH Key Setup & Service User", incident: "SSH Permission Denied", status: "done" },
      { week: 2, topic: "Linux Filesystem & Core Commands", lab: "mkdir, cp, mv, grep workflows", incident: "Missing Config File Crash", status: "done" },
      { week: 3, topic: "Permissions & Ownership", lab: "chmod, chown, Service Accounts", incident: "Log Write Permission Denied", status: "done" },
      { week: 4, topic: "Processes & Monitoring", lab: "ps, kill, signals, pgrep", incident: "100% CPU Runaway Process", status: "done" },
      { week: 5, topic: "Logs, Disk & Networking", lab: "df, du, curl, grep, journalctl", incident: "Disk Full (No Space Left)", status: "done" },
    ],
  },
  {
    id: 2,
    name: "Git + Modern Workflow",
    color: "from-blue-500 to-indigo-600",
    icon: "🔀",
    weeks: [
      { week: 6, topic: "Git Fundamentals", lab: "Commits, revert, log, diff", incident: "git reset --hard → Reflog Recovery", status: "done" },
      { week: 7, topic: "Branching & Feature Toggles", lab: "Feature flags, merge, switch", incident: "Commits on Wrong Branch", status: "done" },
      { week: 8, topic: "PR Workflow & Code Review", lab: "CI simulation, lint gates", incident: "Merge Conflict Resolution", status: "done" },
    ],
  },
  {
    id: 3,
    name: "Python + YAML + Automation",
    color: "from-yellow-500 to-orange-500",
    icon: "🐍",
    weeks: [
      { week: 9,  topic: "Python for DevOps", lab: "CLI tools, file I/O, subprocess", incident: "Broken Python Script Triage", status: "done" },
      { week: 10, topic: "YAML Deep Dive", lab: "Anchors, multi-doc, validation", incident: "Malformed YAML Crash", status: "done" },
      { week: 11, topic: "Bash + Python Automation", lab: "Health-check scripts, argparse", incident: "Silent Script Failure", status: "done" },
      { week: 12, topic: "Cron Jobs & Scheduling", lab: "Crontab, systemd timers", incident: "Missed Cron, Disk Fills Up", status: "done" },
    ],
  },
  {
    id: 4,
    name: "Docker + Containers",
    color: "from-cyan-500 to-blue-500",
    icon: "🐳",
    weeks: [
      { week: 13, topic: "Docker Fundamentals", lab: "run, exec, inspect, logs", incident: "Container Exits Immediately", status: "done" },
      { week: 14, topic: "Dockerfile & Image Building", lab: "Multi-stage builds, layers", incident: "Image Build Failure Triage", status: "done" },
      { week: 15, topic: "Docker Compose Multi-Container", lab: "Multi-container apps", incident: "Service Dependency Crash", status: "done" },
      { week: 16, topic: "Container Security & Registry", lab: "Trivy scan, ACR push", incident: "Vulnerable Image Blocked", status: "done" },
    ],
  },
  {
    id: 5,
    name: "Kubernetes",
    color: "from-violet-500 to-purple-600",
    icon: "☸️",
    weeks: [
      { week: 17, topic: "K8s Architecture & Pods", lab: "kubectl run, exec, logs", incident: "CrashLoopBackOff", status: "done" },
      { week: 18, topic: "Deployments, Services & Ingress", lab: "Rolling updates, rollback", incident: "ImagePullBackOff", status: "done" },
      { week: 19, topic: "ConfigMaps, Secrets & Volumes", lab: "Mount secrets, PVC", incident: "Missing Secret Crash", status: "done" },
      { week: 20, topic: "Helm + K8s Incident Response", lab: "Helm install, upgrade, rollback", incident: "OOMKilled Pod", status: "done" },
    ],
  },
  {
    id: 6,
    name: "Terraform + Azure IaC",
    color: "from-purple-500 to-pink-600",
    icon: "🏗️",
    weeks: [
      { week: 21, topic: "Terraform Fundamentals", lab: "init, plan, apply, destroy", incident: "State Lock / Drift", status: "done" },
      { week: 22, topic: "Azure Provider & Resources", lab: "VMs, VNet, NSG provisioning", incident: "Resource Destroyed in Plan", status: "done" },
      { week: 23, topic: "Modules & Remote State", lab: "Module calls, Azure Blob backend", incident: "Corrupted State File", status: "done" },
      { week: 24, topic: "Terraform in CI/CD", lab: "Plan in PR, apply on merge", incident: "Broken Pipeline, Manual State Fix", status: "done" },
    ],
  },
  {
    id: 7,
    name: "CI/CD Pipelines",
    color: "from-rose-500 to-red-600",
    icon: "🚀",
    weeks: [
      { week: 25, topic: "GitHub Actions Fundamentals", lab: "Workflows, matrix builds", incident: "Flaky Test Blocking Deploy", status: "done" },
      { week: 26, topic: "Azure DevOps Pipelines", lab: "YAML pipelines, stages", incident: "Pipeline Approval Gate Failure", status: "done" },
      { week: 27, topic: "Multi-Stage Pipelines", lab: "Build → Test → Deploy", incident: "Failed Rollback Recovery", status: "done" },
      { week: 28, topic: "Pipeline Security & Artifacts", lab: "SAST, signing, caching", incident: "Secret Exposed in Logs", status: "done" },
    ],
  },
  {
    id: 8,
    name: "Monitoring + Observability",
    color: "from-teal-500 to-green-600",
    icon: "📊",
    weeks: [
      { week: 29, topic: "Prometheus & Metrics", lab: "Exporters, PromQL, scrape", incident: "Metrics Scrape Target Down", status: "done" },
      { week: 30, topic: "Grafana Dashboards", lab: "Panels, datasources, alerts", incident: "Silent Alert (Misconfigured Rule)", status: "done" },
      { week: 31, topic: "Log Aggregation with Loki", lab: "Loki, Promtail, log queries", incident: "Log Pipeline Failure", status: "done" },
      { week: 32, topic: "Alerting & On-Call", lab: "AlertManager, PagerDuty", incident: "Alert Storm Suppression", status: "done" },
    ],
  },
  {
    id: 9,
    name: "Security + SRE + Capstone",
    color: "from-amber-500 to-yellow-500",
    icon: "🔐",
    weeks: [
      { week: 33, topic: "DevSecOps & Scanning", lab: "SAST (Semgrep), DAST, Trivy", incident: "Vulnerable Dependency in Prod", status: "done" },
      { week: 34, topic: "Secrets Management", lab: "Azure Key Vault, OIDC auth", incident: "Hardcoded Secret in Code", status: "done" },
      { week: 35, topic: "SRE Principles & SLOs", lab: "SLI/SLO/SLA, error budgets", incident: "SLO Breach Post-Mortem", status: "done" },
      { week: 36, topic: "Capstone Project", lab: "Full-stack IaC + CI/CD + Monitoring", incident: "Multi-Service Outage RCA", status: "done" },
    ],
  },
];

export const totalWeeks = 36;
export const completedWeeks = phases.flatMap(p => p.weeks).filter(w => w.status === "done").length;
export const activeWeeks = phases.flatMap(p => p.weeks).filter(w => w.status === "active").length;
export const completionPct = Math.round((completedWeeks / totalWeeks) * 100);
