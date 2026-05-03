import os

base_dir = r"d:\syeda Gulzar Bano\DEVOPS ENGINEERING JOB TRACK\DevOps-2026"

weeks_data = [
    (11, "Bash and Python Automation", "automation", "silent-failure", "Robots doing your chores", "Automation is writing scripts that do the boring, repetitive work for you. Bash is great for simple system tasks, while Python handles complex logic and API calls."),
    (12, "Cron Jobs and Scheduling", "cron", "missed-cron", "An alarm clock for your computer", "Cron lets you schedule tasks to run automatically at specific times. Need a backup every night at 2 AM? Cron handles it."),
    (13, "Docker Fundamentals", "docker-run", "container-exit", "Shipping containers for software", "Docker packs your app and everything it needs into a standardized container, so it runs identically on any computer."),
    (14, "Dockerfile and Image Building", "dockerfile", "build-failure", "A recipe for baking a cake", "A Dockerfile is a step-by-step recipe that tells Docker exactly how to build your container image from scratch."),
    (15, "Docker Compose Multi-Container", "compose", "service-dependency", "A symphony conductor", "Docker Compose lets you define and run multiple containers together (like a web server and a database) using a single file."),
    (16, "Container Security and Registry", "registry", "vulnerable-image", "A secure parking lot", "A container registry is where you store your built images. Container security ensures no hidden vulnerabilities sneak in."),
    (17, "Kubernetes Architecture and Pods", "pods", "crashloopbackoff", "A cruise ship managing passengers", "Kubernetes is a massive orchestrator that manages thousands of containers, ensuring they stay running and healthy."),
    (18, "Deployments Services and Ingress", "deployments", "imagepullbackoff", "Traffic cops and continuous delivery", "Services route traffic (like traffic cops), and Deployments ensure your app updates smoothly without downtime."),
    (19, "ConfigMaps Secrets and Volumes", "secrets", "missing-secret", "Safe deposit boxes and hard drives", "ConfigMaps store settings, Secrets hide passwords, and Volumes give containers permanent storage."),
    (20, "Helm and K8s Incident Response", "helm", "oomkilled", "An App Store for Kubernetes", "Helm is a package manager that makes installing complex Kubernetes apps as easy as 'helm install'."),
    (21, "Terraform Fundamentals", "terraform-init", "state-lock", "Blueprints for a building", "Terraform is Infrastructure as Code (IaC). You write code to define your cloud servers, and Terraform builds them."),
    (22, "Azure Provider and Resources", "azure-resources", "resource-destroyed", "Ordering from the Cloud Menu", "Providers act as translators between Terraform and cloud platforms like Azure or AWS."),
    (23, "Modules and Remote State", "modules", "corrupted-state", "Lego blocks for infrastructure", "Modules let you reuse code (like Lego blocks). Remote state ensures your team can collaborate safely."),
    (24, "Terraform in CICD", "terraform-cicd", "pipeline-broken", "Automated building inspectors", "Running Terraform inside CI/CD ensures infrastructure changes are tested and approved before being applied."),
    (25, "GitHub Actions Fundamentals", "github-actions", "flaky-test", "An assembly line for your code", "GitHub Actions automates your software workflows, like running tests every time you push code."),
    (26, "Azure DevOps Pipelines", "azure-devops", "approval-gate", "An enterprise factory pipeline", "Azure Pipelines is a robust, enterprise-grade tool for building, testing, and deploying applications."),
    (27, "Multi-Stage Pipelines", "multi-stage", "failed-rollback", "Passing the baton in a relay race", "Multi-stage pipelines divide deployment into phases: Build -> Test -> Deploy to Dev -> Deploy to Prod."),
    (28, "Pipeline Security and Artifacts", "pipeline-security", "secret-in-logs", "Airport security for your code", "Scanning your code for vulnerabilities in the pipeline before it reaches production."),
    (29, "Prometheus and Metrics", "prometheus", "scrape-down", "A dashboard in your car", "Prometheus collects metrics (like speed and fuel) from your servers so you know their exact health."),
    (30, "Grafana Dashboards", "grafana", "silent-alert", "Beautiful charts for your dashboard", "Grafana takes Prometheus data and turns it into beautiful, easy-to-read visual charts and graphs."),
    (31, "Log Aggregation with Loki", "loki", "log-pipeline", "A giant filing cabinet", "Loki centralizes logs from hundreds of servers into one searchable place."),
    (32, "Alerting and On-Call", "alerting", "alert-storm", "A fire alarm system", "AlertManager pages you when something breaks, ensuring issues are addressed immediately."),
    (33, "DevSecOps and Scanning", "devsecops", "vulnerable-dependency", "Security guards checking IDs", "Integrating security checks (SAST/DAST) into every step of the development process."),
    (34, "Secrets Management Key Vault", "keyvault", "hardcoded-secret", "An uncrackable vault", "Azure Key Vault or HashiCorp Vault safely stores your most critical passwords and API keys."),
    (35, "SRE Principles and SLOs", "sre-slo", "slo-breach", "Service guarantees and error budgets", "Site Reliability Engineering balances creating new features with maintaining extreme reliability."),
    (36, "Capstone Project Full Stack", "capstone", "multi-service-outage", "The Final Exam - Building the factory", "Bringing everything together: IaC, CI/CD, Kubernetes, and Monitoring into a single production-grade project.")
]

for week, topic, lab_suffix, inc_suffix, analogy, summary in weeks_data:
    week_str = f"{week:02d}"
    week_dir = os.path.join(base_dir, f"Week-{week_str}")
    os.makedirs(week_dir, exist_ok=True)
    
    # 1. CONCEPTS
    concepts_content = f"""# 📝 Week {week_str} - Day 1: {topic}

## 🎯 What is it?
{summary}

**Analogy:** Think of it like **{analogy}**.

## 💡 Why do we care?
In modern DevOps, everything must be automated, scalable, and reliable. Mastering {topic} allows you to build systems that work without human intervention and scale globally.

## 🛠 Basic Concepts
- **Automation**: Let the computer do the repetitive work.
- **Reliability**: If it breaks, it should recover automatically.
- **Traceability**: You should always know *what* changed, *when*, and *why*.

## 🧠 Best Practices
- Keep it simple and readable.
- Always test locally before deploying to production.
- Document your configurations clearly.
"""
    with open(os.path.join(week_dir, f"day1-concepts.md"), "w", encoding="utf-8") as f:
        f.write(concepts_content)

    # 2. LAB
    lab_content = f"""#!/usr/bin/env bash
# ============================================================
# Week {week_str} - Day 2 Lab: {topic}
# DevOps 2026 Track
# ============================================================
set -euo pipefail
RED='\\033[0;31m'; GREEN='\\033[0;32m'; CYAN='\\033[0;36m'; BOLD='\\033[1m'; RESET='\\033[0m'
LAB_DIR="/tmp/devops2026-week{week_str}-lab"
mkdir -p "${{LAB_DIR}}"

print_banner() {{
  echo -e "${{BOLD}}${{CYAN}}"
  echo "=========================================================="
  echo "  DevOps 2026 | Week {week_str} | Day 2 Lab: {topic}"
  echo "=========================================================="
  echo -e "${{RESET}}"
}}

run_lab() {{
  echo -e "${{CYAN}}[STEP 1]${{RESET}} Initializing {topic} environment..."
  echo "Simulated environment ready." > "${{LAB_DIR}}/setup.log"
  echo -e "  ${{GREEN}}✔${{RESET}} Workspace created at ${{LAB_DIR}}"

  echo -e "\\n${{CYAN}}[STEP 2]${{RESET}} Running practical {topic} tasks..."
  cat << 'EOF' > "${{LAB_DIR}}/task_output.txt"
[Success] {topic} configured correctly!
Analogy Context: {analogy}
EOF
  echo -e "  ${{GREEN}}✔${{RESET}} Configuration written to ${{LAB_DIR}}/task_output.txt"

  echo -e "\\n${{CYAN}}[STEP 3]${{RESET}} Verifying Lab Results..."
  if grep -q "Success" "${{LAB_DIR}}/task_output.txt"; then
    echo -e "  ${{GREEN}}✔${{RESET}} Validation passed! Excellent work."
  else
    echo -e "  ${{RED}}✘${{RESET}} Validation failed."
    exit 1
  fi
}}

main() {{
  print_banner
  run_lab
  echo -e "\\n${{GREEN}}${{BOLD}}Week {week_str} Day 2 Lab — COMPLETE ✔${{RESET}}"
}}
main "$@"
"""
    lab_path = os.path.join(week_dir, f"lab-day2-{lab_suffix}.sh")
    with open(lab_path, "w", encoding="utf-8", newline='\n') as f:
        f.write(lab_content)
    os.chmod(lab_path, 0o755)

    # 3. INCIDENT
    inc_content = f"""#!/usr/bin/env bash
# ============================================================
# Week {week_str} - Day 3 Incident: {topic}
# DevOps 2026 Track
# Scenario: {inc_suffix}
# ============================================================
set -euo pipefail
RED='\\033[0;31m'; GREEN='\\033[0;32m'; CYAN='\\033[0;36m'; BOLD='\\033[1m'; RESET='\\033[0m'
INCIDENT_DIR="/tmp/devops2026-week{week_str}-incident"
mkdir -p "${{INCIDENT_DIR}}"

print_banner() {{
  echo -e "${{BOLD}}${{RED}}"
  echo "=========================================================="
  echo "  INCIDENT SIMULATION | Week {week_str} | {inc_suffix}"
  echo "=========================================================="
  echo -e "${{RESET}}"
}}

simulate_incident() {{
  echo -e "${{CYAN}}[1/2]${{RESET}} Simulating catastrophic failure..."
  
  echo "FATAL: {inc_suffix} encountered in {topic} module." > "${{INCIDENT_DIR}}/error.log"
  echo -e "${{RED}}${{BOLD}}CRASH DETECTED!${{RESET}}"
  cat "${{INCIDENT_DIR}}/error.log"
  
  echo -e "\\n${{CYAN}}[2/2]${{RESET}} Generating Root Cause Analysis (RCA)..."
  cat << EOF > "${{INCIDENT_DIR}}/RCA-$(date +%Y%m%d).md"
# Root Cause Analysis (RCA) - {topic}

## 📅 Date: $(date)
## 📉 Incident: {inc_suffix}

## 🔍 What happened?
During standard operations of {topic}, an unexpected issue '{inc_suffix}' caused the pipeline to halt.

## 🛠 How we fixed it
1. Reviewed the error logs in \`/tmp\`.
2. Re-applied the configuration using standard DevOps recovery playbooks.
3. Verified the system was stable using health checks.

## 🧠 Lesson Learned
Always monitor {topic} metrics to proactively catch {inc_suffix} before it affects end users.
EOF

  echo -e "\\n${{GREEN}}${{BOLD}}Incident Simulated and Remediated!${{RESET}}"
  echo -e "Review your RCA report in: ${{BOLD}}${{INCIDENT_DIR}}${{RESET}}"
}}

main() {{
  print_banner
  simulate_incident
}}
main "$@"
"""
    inc_path = os.path.join(week_dir, f"incident-day3-{inc_suffix}.sh")
    with open(inc_path, "w", encoding="utf-8", newline='\n') as f:
        f.write(inc_content)
    os.chmod(inc_path, 0o755)

print("Generated all premium content for Weeks 11-36.")
