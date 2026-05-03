#!/usr/bin/env bash
# ============================================================
# Week 22 - Day 3 Incident: Azure Provider and Resources
# DevOps 2026 Track
# Scenario: resource-destroyed
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
INCIDENT_DIR="/tmp/devops2026-week22-incident"
mkdir -p "${INCIDENT_DIR}"

print_banner() {
  echo -e "${BOLD}${RED}"
  echo "=========================================================="
  echo "  INCIDENT SIMULATION | Week 22 | resource-destroyed"
  echo "=========================================================="
  echo -e "${RESET}"
}

simulate_incident() {
  echo -e "${CYAN}[1/2]${RESET} Simulating catastrophic failure..."
  
  echo "FATAL: resource-destroyed encountered in Azure Provider and Resources module." > "${INCIDENT_DIR}/error.log"
  echo -e "${RED}${BOLD}CRASH DETECTED!${RESET}"
  cat "${INCIDENT_DIR}/error.log"
  
  echo -e "\n${CYAN}[2/2]${RESET} Generating Root Cause Analysis (RCA)..."
  cat << EOF > "${INCIDENT_DIR}/RCA-$(date +%Y%m%d).md"
# Root Cause Analysis (RCA) - Azure Provider and Resources

## 📅 Date: $(date)
## 📉 Incident: resource-destroyed

## 🔍 What happened?
During standard operations of Azure Provider and Resources, an unexpected issue 'resource-destroyed' caused the pipeline to halt.

## 🛠 How we fixed it
1. Reviewed the error logs in \`/tmp\`.
2. Re-applied the configuration using standard DevOps recovery playbooks.
3. Verified the system was stable using health checks.

## 🧠 Lesson Learned
Always monitor Azure Provider and Resources metrics to proactively catch resource-destroyed before it affects end users.
EOF

  echo -e "\n${GREEN}${BOLD}Incident Simulated and Remediated!${RESET}"
  echo -e "Review your RCA report in: ${BOLD}${INCIDENT_DIR}${RESET}"
}

main() {
  print_banner
  simulate_incident
}
main "$@"
