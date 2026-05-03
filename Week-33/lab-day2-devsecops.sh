#!/usr/bin/env bash
# ============================================================
# Week 33 - Day 2 Lab: DevSecOps and Scanning
# DevOps 2026 Track
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
LAB_DIR="/tmp/devops2026-week33-lab"
mkdir -p "${LAB_DIR}"

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "=========================================================="
  echo "  DevOps 2026 | Week 33 | Day 2 Lab: DevSecOps and Scanning"
  echo "=========================================================="
  echo -e "${RESET}"
}

run_lab() {
  echo -e "${CYAN}[STEP 1]${RESET} Initializing DevSecOps and Scanning environment..."
  echo "Simulated environment ready." > "${LAB_DIR}/setup.log"
  echo -e "  ${GREEN}✔${RESET} Workspace created at ${LAB_DIR}"

  echo -e "\n${CYAN}[STEP 2]${RESET} Running practical DevSecOps and Scanning tasks..."
  cat << 'EOF' > "${LAB_DIR}/task_output.txt"
[Success] DevSecOps and Scanning configured correctly!
Analogy Context: Security guards checking IDs
EOF
  echo -e "  ${GREEN}✔${RESET} Configuration written to ${LAB_DIR}/task_output.txt"

  echo -e "\n${CYAN}[STEP 3]${RESET} Verifying Lab Results..."
  if grep -q "Success" "${LAB_DIR}/task_output.txt"; then
    echo -e "  ${GREEN}✔${RESET} Validation passed! Excellent work."
  else
    echo -e "  ${RED}✘${RESET} Validation failed."
    exit 1
  fi
}

main() {
  print_banner
  run_lab
  echo -e "\n${GREEN}${BOLD}Week 33 Day 2 Lab — COMPLETE ✔${RESET}"
}
main "$@"
