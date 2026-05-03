#!/usr/bin/env bash
# =============================================================================
# Week 05 - Day 2 Lab: Logs, Disk & Networking Diagnostics
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# Description: This lab simulates checking system disk usage, hunting for
#              large files, parsing logs, and performing network tests.
# =============================================================================

set -euo pipefail

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week05-lab"

log_step() { echo -e "\n${CYAN}${BOLD}[STEP]${RESET} $1"; }
log_ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "══════════════════════════════════════════════════════"
  echo "   DevOps 2026 | Week 05 | Day 2 Lab: Diagnostics"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Step 1: Disk Usage Diagnostics ───────────────────────────────────────────
check_disk_space() {
  log_step "Checking System Storage (df and du)"
  
  echo -e "  ${BOLD}1. Overall filesystem disk space (df -h):${RESET}"
  df -h | grep -v "tmpfs" | head -n 5 | sed 's/^/  /'
  
  echo -e "\n  ${BOLD}2. Generating mock data to test 'du':${RESET}"
  mkdir -p "${LAB_DIR}/app/data"
  dd if=/dev/zero of="${LAB_DIR}/app/data/large_cache.bin" bs=1M count=50 2>/dev/null
  log_ok "Generated 50MB mock file."
  
  echo -e "\n  ${BOLD}3. Finding largest directories (du -sh):${RESET}"
  du -sh "${LAB_DIR}"/* | sed 's/^/  /'
}

# ─── Step 2: Log Analysis ──────────────────────────────────────────────────────
analyze_logs() {
  log_step "Analyzing application logs"
  
  local mock_log="${LAB_DIR}/nginx_error.log"
  
  # Generate mock logs
  echo '2026/05/03 10:00:00 [notice] 1234#0: start worker processes' > "${mock_log}"
  echo '2026/05/03 10:05:12 [error] 1234#0: *1 open() "/var/www/html/favicon.ico" failed (2: No such file)' >> "${mock_log}"
  echo '2026/05/03 10:06:45 [error] 1234#0: *2 upstream timed out (110: Connection timed out) while reading response header' >> "${mock_log}"
  echo '2026/05/03 10:07:01 [error] 1234#0: *3 upstream timed out (110: Connection timed out) while reading response header' >> "${mock_log}"
  
  log_ok "Mock Nginx error log created."
  
  echo -e "\n  ${BOLD}Extracting 'timeout' errors using grep/awk:${RESET}"
  grep "timed out" "${mock_log}" | awk -F '] ' '{print "  " $2}'
}

# ─── Step 3: Network Diagnostics ───────────────────────────────────────────────
network_tests() {
  log_step "Performing Network Connectivity Tests"
  
  echo -e "  ${BOLD}1. Testing DNS Resolution (ping localhost):${RESET}"
  if ping -c 1 localhost > /dev/null; then
      log_ok "Ping to localhost successful."
  else
      echo -e "  ${RED}Ping failed.${RESET}"
  fi
  
  echo -e "\n  ${BOLD}2. Testing HTTP Application Endpoint (curl):${RESET}"
  # We use httpbin.org to safely test a 200 OK response
  local url="https://httpbin.org/status/200"
  echo "  Command: curl -s -o /dev/null -w '%{http_code}' ${url}"
  
  local http_status=$(curl -s -o /dev/null -w "%{http_code}" "${url}")
  if [[ "${http_status}" == "200" ]]; then
      log_ok "Received HTTP 200 OK from endpoint."
  else
      echo -e "  ${RED}Endpoint returned HTTP ${http_status}.${RESET}"
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  check_disk_space
  analyze_logs
  network_tests
  
  echo -e "\n${GREEN}${BOLD}Week 05 Day 2 Lab — COMPLETE ✔${RESET}"
}

main "$@"
