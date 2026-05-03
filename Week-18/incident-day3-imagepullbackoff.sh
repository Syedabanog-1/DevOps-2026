#!/usr/bin/env bash
# ============================================================
# Week 18 - Day 3 Incident: Deployments Services and Ingress
# DevOps 2026 Track
# Scenario: imagepullbackoff
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
INCIDENT_DIR="/tmp/devops2026-week18-incident"
mkdir -p "${INCIDENT_DIR}"

print_banner() {
  echo -e "${BOLD}${RED}"
  echo "=========================================================="
  echo "  INCIDENT SIMULATION | Week 18 | imagepullbackoff"
  echo "=========================================================="
  echo -e "${RESET}"
}

simulate_incident() {
  echo -e "${CYAN}[1/2]${RESET} Simulating catastrophic failure..."
  
  echo "FATAL: imagepullbackoff encountered in Deployments Services and Ingress module." > "${INCIDENT_DIR}/error.log"
  echo -e "${RED}${BOLD}CRASH DETECTED!${RESET}"
  cat "${INCIDENT_DIR}/error.log"
  
  echo -e "\n${CYAN}[2/2]${RESET} Generating Root Cause Analysis (RCA)..."
  cat << EOF > "${INCIDENT_DIR}/RCA-$(date +%Y%m%d).md"
# Root Cause Analysis (RCA) - Deployments Services and Ingress

## 📅 Date: $(date)
## 📉 Incident: imagepullbackoff

## 🔍 What happened?
During standard operations of Deployments Services and Ingress, an unexpected issue 'imagepullbackoff' caused the pipeline to halt.

## 🛠 How we fixed it
1. Reviewed the error logs in \`/tmp\`.
2. Re-applied the configuration using standard DevOps recovery playbooks.
3. Verified the system was stable using health checks.

## 🧠 Lesson Learned
Always monitor Deployments Services and Ingress metrics to proactively catch imagepullbackoff before it affects end users.
EOF

  echo -e "\n${GREEN}${BOLD}Incident Simulated and Remediated!${RESET}"
  echo -e "Review your RCA report in: ${BOLD}${INCIDENT_DIR}${RESET}"
}

main() {
  print_banner
  simulate_incident
}
main "$@"
