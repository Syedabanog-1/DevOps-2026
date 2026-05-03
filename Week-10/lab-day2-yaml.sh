#!/usr/bin/env bash
# ============================================================
# Week 10 - Day 2 Lab: Learning YAML
# DevOps 2026 Track
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
LAB_DIR="/tmp/devops2026-week10-lab"
mkdir -p "${LAB_DIR}"

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "=========================================================="
  echo "  DevOps 2026 | Week 10 | Day 2 Lab: My First YAML"
  echo "=========================================================="
  echo -e "${RESET}"
}

run_lab() {
  echo -e "${CYAN}[STEP 1]${RESET} Creating a simple YAML file: ${BOLD}config.yaml${RESET}"
  
  cat << 'EOF' > "${LAB_DIR}/config.yaml"
# This is my first YAML configuration
app_name: "My Awesome App"
version: 1.0.0
features:
  - dark_mode
  - notifications
  - auto_save
owner:
  name: "Syeda Gulzar Bano"
  role: "DevOps Engineer"
EOF
  echo -e "  ${GREEN}✔${RESET} File created."

  echo -e "\n${CYAN}[STEP 2]${RESET} Reading the YAML data"
  echo -e "${BOLD}File Contents:${RESET}"
  cat "${LAB_DIR}/config.yaml"

  echo -e "\n${CYAN}[STEP 3]${RESET} Checking if it's correct (Validation)"
  # Using Python to check if it's valid YAML (simplest way without extra installs)
  if python3 -c 'import yaml, sys; yaml.safe_load(sys.stdin)' < "${LAB_DIR}/config.yaml" 2>/dev/null; then
    echo -e "  ${GREEN}✔${RESET} The YAML is perfect!"
  else
    echo -e "  ${RED}✘${RESET} Something is wrong with the YAML syntax."
  fi
}

main() {
  print_banner
  run_lab
  echo -e "\n${GREEN}${BOLD}Week 10 Day 2 Lab — COMPLETE ✔${RESET}"
}
main "$@"
