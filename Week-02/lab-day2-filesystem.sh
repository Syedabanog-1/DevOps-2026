#!/usr/bin/env bash
# =============================================================================
# Week 02 - Day 2 Lab: Filesystem & Core Commands
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# Description: This lab creates a mock application directory structure,
#              simulates log generation, and demonstrates file manipulation.
# =============================================================================

set -euo pipefail

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week02-lab"

log_step() { echo -e "\n${CYAN}${BOLD}[STEP]${RESET} $1"; }
log_ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "══════════════════════════════════════════════════════"
  echo "   DevOps 2026 | Week 02 | Day 2 Lab: Filesystem"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Step 1: Directory Structure Creation ─────────────────────────────────────
create_structure() {
  log_step "Creating application directory structure"
  
  # Clean previous runs
  rm -rf "${LAB_DIR}"
  
  # Make parent and subdirectories using -p
  mkdir -p "${LAB_DIR}/app/config"
  mkdir -p "${LAB_DIR}/app/logs"
  mkdir -p "${LAB_DIR}/app/bin"
  mkdir -p "${LAB_DIR}/backup"
  
  log_ok "Created directory structure at ${LAB_DIR}"
}

# ─── Step 2: File Creation & Manipulation ──────────────────────────────────────
manipulate_files() {
  log_step "Creating and manipulating files"
  
  # Create a dummy config file
  echo "server_port=8080" > "${LAB_DIR}/app/config/server.conf"
  echo "db_host=localhost" >> "${LAB_DIR}/app/config/server.conf"
  log_ok "Created config file: app/config/server.conf"
  
  # Create a dummy executable
  echo "#!/bin/bash" > "${LAB_DIR}/app/bin/start.sh"
  echo "echo 'Starting server...'" >> "${LAB_DIR}/app/bin/start.sh"
  chmod +x "${LAB_DIR}/app/bin/start.sh"
  log_ok "Created executable script: app/bin/start.sh"
  
  # Copy config to backup
  cp "${LAB_DIR}/app/config/server.conf" "${LAB_DIR}/backup/server.conf.bak"
  log_ok "Backed up config file using 'cp'"
}

# ─── Step 3: Log Generation & Searching ────────────────────────────────────────
generate_and_search_logs() {
  log_step "Generating mock logs and searching with grep"
  
  local log_file="${LAB_DIR}/app/logs/application.log"
  
  # Generate logs
  echo "[INFO] Server started successfully" > "${log_file}"
  echo "[INFO] Listening on port 8080" >> "${log_file}"
  echo "[WARNING] High memory usage detected" >> "${log_file}"
  echo "[ERROR] Database connection failed: timeout" >> "${log_file}"
  echo "[INFO] Retrying database connection..." >> "${log_file}"
  echo "[ERROR] Database connection failed: authentication refused" >> "${log_file}"
  log_ok "Generated log file: app/logs/application.log"
  
  echo -e "\n  ${BOLD}Simulating 'grep ERROR ${log_file}'${RESET}"
  echo "  ----------------------------------------------------"
  grep "ERROR" "${log_file}" || true
  echo "  ----------------------------------------------------"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  create_structure
  manipulate_files
  generate_and_search_logs
  
  echo -e "\n${GREEN}${BOLD}Week 02 Day 2 Lab — COMPLETE ✔${RESET}"
}

main "$@"
