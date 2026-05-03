#!/usr/bin/env bash
# ============================================================
# Week 10 - Day 3 Incident: The Broken YAML
# DevOps 2026 Track
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
INCIDENT_DIR="/tmp/devops2026-week10-incident"
mkdir -p "${INCIDENT_DIR}"

print_banner() {
  echo -e "${BOLD}${RED}"
  echo "=========================================================="
  echo "  INCIDENT SIMULATION | Week 10 | The Broken Space"
  echo "=========================================================="
  echo -e "${RESET}"
}

simulate_incident() {
  echo -e "${CYAN}[1/2]${RESET} Creating a BROKEN YAML file..."
  
  # ERROR: The dash is not indented correctly
  cat << 'EOF' > "${INCIDENT_DIR}/broken_settings.yaml"
server:
  port: 8080
  logs:
- path: "/var/log/app.log" # <--- ERROR: This should be indented!
EOF

  echo -e "${RED}${BOLD}CRASH DETECTED!${RESET}"
  echo "The computer tried to read the settings and failed:"
  
  set +e
  python3 -c 'import yaml, sys; yaml.safe_load(sys.stdin)' < "${INCIDENT_DIR}/broken_settings.yaml" 2> "${INCIDENT_DIR}/error.log"
  set -e
  
  cat "${INCIDENT_DIR}/error.log"
  
  echo -e "\n${CYAN}[2/2]${RESET} How to fix it?"
  echo -e "In YAML, the dash ${BOLD}- ${RESET} must align with the content above it."
  echo -e "The computer is confused because it doesn't know where the 'logs' section ends."

  cat << EOF > "${INCIDENT_DIR}/RCA-$(date +%Y%m%d).md"
# Root Cause Analysis (RCA) - Broken YAML

## 📅 Date: $(date)
## 📉 Incident: Settings file failed to load

## 🔍 What happened?
A simple indentation mistake (missing spaces) made the file unreadable for the computer.

## 🛠 How we fixed it
Indented the list items under 'logs' with two spaces.

## 🧠 Lesson Learned
Spaces are like punctuation in YAML. Even one missing space can break the whole system!
EOF

  echo -e "\n${GREEN}${BOLD}Incident Simulated!${RESET}"
  echo -e "Look at the error and the fix notes in: ${BOLD}${INCIDENT_DIR}${RESET}"
}

main() {
  print_banner
  simulate_incident
}
main "$@"
