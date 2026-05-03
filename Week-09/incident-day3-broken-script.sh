#!/usr/bin/env bash
# ============================================================
# Week 09 - Day 3 Incident: Broken Python Automation
# DevOps 2026 Track
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
INCIDENT_DIR="/tmp/devops2026-week09-incident"
mkdir -p "${INCIDENT_DIR}"

print_banner() {
  echo -e "${BOLD}${RED}"
  echo "=========================================================="
  echo "  INCIDENT SIMULATION | Week 09 | Broken Python Script"
  echo "=========================================================="
  echo -e "${RESET}"
}

simulate_incident() {
  echo -e "${CYAN}[1/3]${RESET} Deploying production script..."
  
  cat << 'EOF' > "${INCIDENT_DIR}/deploy_monitor.py"
#!/usr/bin/env python3
import sys
import json

def process_config(path):
    # CRITICAL BUG: No error handling for missing file
    with open(path, 'r') as f:
        data = json.load(f)
    return data

if __name__ == "__main__":
    print("Starting deployment monitor...")
    # INCIDENT: Passing a non-existent file path
    config = process_config("/etc/non-existent-config.json")
    print(f"Config loaded: {config}")
EOF
  chmod +x "${INCIDENT_DIR}/deploy_monitor.py"
  
  echo -e "${CYAN}[2/3]${RESET} Triggering automated deployment..."
  sleep 1
  
  echo -e "${RED}${BOLD}CRASH DETECTED!${RESET}"
  set +e
  python3 "${INCIDENT_DIR}/deploy_monitor.py" 2> "${INCIDENT_DIR}/error.log"
  set -e
  
  cat "${INCIDENT_DIR}/error.log"
  
  echo -e "\n${CYAN}[3/3]${RESET} Generating Root Cause Analysis (RCA) template..."
  
  cat << EOF > "${INCIDENT_DIR}/RCA-$(date +%Y%m%d).md"
# Root Cause Analysis (RCA) - Week 09 Incident

## 📅 Date: $(date)
## 📉 Incident: Python Automation Crash in Production

## 🔍 Investigation
- **Error Observed**: FileNotFoundError in \`deploy_monitor.py\`
- **Impact**: Automation pipeline halted, no health checks performed.

## 🛠 Resolution Steps
1. [ ] Implement \`try...except\` block for file operations.
2. [ ] Add validation to ensure config files exist before opening.
3. [ ] Improve logging to capture file paths being accessed.

## 🧠 Lessons Learned
- Never assume external resources (files, APIs) are always available.
- Implement robust exception handling for all I/O operations.
EOF

  echo -e "\n${GREEN}${BOLD}Incident Simulated!${RESET}"
  echo -e "Review the error and RCA template in: ${BOLD}${INCIDENT_DIR}${RESET}"
}

main() {
  print_banner
  simulate_incident
}
main "$@"
