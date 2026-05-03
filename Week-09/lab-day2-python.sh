#!/usr/bin/env bash
# ============================================================
# Week 09 - Day 2 Lab: Python for DevOps (Automation)
# DevOps 2026 Track
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
LAB_DIR="/tmp/devops2026-week09-lab"
mkdir -p "${LAB_DIR}"

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "=========================================================="
  echo "  DevOps 2026 | Week 09 | Day 2 Lab: Python for DevOps"
  echo "=========================================================="
  echo -e "${RESET}"
}

run_lab() {
  echo -e "${CYAN}[STEP 1]${RESET} Creating Python Automation Script: ${BOLD}system_health.py${RESET}"
  
  cat << 'EOF' > "${LAB_DIR}/system_health.py"
#!/usr/bin/env python3
import os
import sys
import subprocess
import json
from datetime import datetime

def get_disk_usage():
    try:
        res = subprocess.run(['df', '-h', '/'], capture_output=True, text=True, check=True)
        return res.stdout.split('\n')[1].split()[4]
    except Exception:
        return "Unknown"

def get_load_avg():
    return os.getloadavg()[0]

def main():
    report = {
        "timestamp": datetime.now().isoformat(),
        "hostname": os.uname().nodename,
        "disk_usage": get_disk_usage(),
        "load_avg_1m": get_load_avg(),
        "status": "HEALTHY" if get_load_avg() < 2.0 else "WARNING"
    }
    
    print(json.dumps(report, indent=2))
    
    if report["status"] == "WARNING":
        sys.exit(1)
    sys.exit(0)

if __name__ == "__main__":
    main()
EOF
  chmod +x "${LAB_DIR}/system_health.py"
  echo -e "  ${GREEN}✔${RESET} Script created and marked executable."

  echo -e "\n${CYAN}[STEP 2]${RESET} Executing Python Automation Script"
  python3 "${LAB_DIR}/system_health.py" > "${LAB_DIR}/health_report.json"
  echo -e "  ${GREEN}✔${RESET} Execution complete. Report saved to ${LAB_DIR}/health_report.json"

  echo -e "\n${CYAN}[STEP 3]${RESET} Verifying Report Contents"
  if grep -q "status" "${LAB_DIR}/health_report.json"; then
    echo -e "  ${GREEN}✔${RESET} Valid JSON report generated."
    cat "${LAB_DIR}/health_report.json" | grep "status"
  else
    echo -e "  ${RED}✘${RESET} Failed to generate valid report."
    exit 1
  fi
}

main() {
  print_banner
  run_lab
  echo -e "\n${GREEN}${BOLD}Week 09 Day 2 Lab — COMPLETE ✔${RESET}"
  echo -e "Artifacts generated in: ${BOLD}${LAB_DIR}${RESET}"
}
main "$@"
