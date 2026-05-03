#!/usr/bin/env bash
# =============================================================================
# Week 05 - Day 3 INCIDENT: Disk Full
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# SCENARIO: A database or application fails to write data because the disk
#           is 100% full. You must identify the large files consuming space,
#           safely delete or truncate them, and document the RCA.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week05-incident"
APP_DATA_DIR="${LAB_DIR}/var/lib/myapp"
LOG_DIR="${LAB_DIR}/var/log/myapp"
RCA_FILE="${LAB_DIR}/RCA-week05-disk-full.md"

log_incident() { echo -e "\n${RED}${BOLD}[INCIDENT]${RESET} $1"; }
log_rca()      { echo -e "\n${YELLOW}${BOLD}[RCA]${RESET} $1"; }
log_fix()      { echo -e "\n${GREEN}${BOLD}[FIX]${RESET} $1"; }
log_info()     { echo -e "  ${CYAN}▶${RESET} $1"; }

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "══════════════════════════════════════════════════════"
  echo "  🚨 INCIDENT SIM | Week 05 Day 3 | Disk Full"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Setup Broken State ────────────────────────────────────────────────────────
simulate_incident() {
  log_incident "SCENARIO: Database fails to start — 'No space left on device'"
  
  rm -rf "${LAB_DIR}"
  mkdir -p "${APP_DATA_DIR}"
  mkdir -p "${LOG_DIR}"
  
  # Create a massive dummy log file to simulate an application going crazy
  log_info "Simulating a runaway log file consuming all disk space..."
  dd if=/dev/zero of="${LOG_DIR}/application_debug.log" bs=1M count=100 2>/dev/null
  
  # Simulate normal DB files
  touch "${APP_DATA_DIR}/db_data.dat"
  
  log_info "Attempting to write new data to the database..."
  
  # We simulate the failure by pretending the disk is full. 
  # In reality, this would be `touch` failing, but we fake the error for the lab.
  echo -e "  ${RED}FATAL: write error: No space left on device${RESET}"
  echo -e "  ${RED}Database service crashed.${RESET}"
}

# ─── RCA: Root Cause Analysis ─────────────────────────────────────────────────
perform_rca() {
  log_rca "INVESTIGATING: Root Cause Analysis"
  
  echo -e "  ${CYAN}[CHECK 1]${RESET} Confirm disk space usage globally:"
  echo "  Command: df -h"
  echo "  (Simulated Output: /dev/sda1 is 100% full)"
  
  echo -e "\n  ${CYAN}[CHECK 2]${RESET} Hunt down the largest directories in the simulated root:"
  echo "  Command: du -h -d 2 ${LAB_DIR} | sort -hr"
  
  echo "  ----------------------------------------------------"
  du -h -d 2 "${LAB_DIR}" | sort -hr | head -n 5 | sed 's/^/  /'
  echo "  ----------------------------------------------------"
  
  echo -e "\n  ${CYAN}[CHECK 3]${RESET} Identify the specific large file:"
  echo "  Command: ls -lhS ${LOG_DIR} | head -n 5"
  ls -lhS "${LOG_DIR}" | head -n 5 | sed 's/^/  /'
  
  echo -e "\n  ${BOLD}Conclusion:${RESET} A debug log file 'application_debug.log' has"
  echo "  ballooned to 100MB, consuming the remaining disk space."
}

# ─── FIX: Apply Remediation ───────────────────────────────────────────────────
apply_fix() {
  log_fix "REMEDIATION: Freeing disk space safely"
  
  echo -e "  ${BOLD}Correct way to clear a log file being actively written to:${RESET}"
  echo "  Command: > ${LOG_DIR}/application_debug.log"
  echo "  (Do NOT use 'rm', as running processes will keep the file descriptor open"
  echo "  and the space will not actually be freed until the process restarts!)"
  
  # Truncate the file
  > "${LOG_DIR}/application_debug.log"
  log_info "Log file truncated."
  
  echo -e "\n  ${BOLD}Verifying available space:${RESET}"
  ls -lh "${LOG_DIR}/application_debug.log" | sed 's/^/  /'
  
  echo -e "\n  ${BOLD}Verifying database startup:${RESET}"
  echo "  Attempting write to db_data.dat..."
  echo "New record" >> "${APP_DATA_DIR}/db_data.dat"
  echo -e "  ${GREEN}SUCCESS: Database started and data written.${RESET}"
}

# ─── Generate RCA Document ────────────────────────────────────────────────────
generate_rca_doc() {
  log_fix "Generating formal RCA document"

  cat > "${RCA_FILE}" << RCADOC
# Incident RCA: Disk Full (No Space Left on Device)
## Week 05 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Severity:** Critical (Database Outage)
**Status:** ✅ RESOLVED

---

## Incident Summary
The primary database crashed and refused to start, logging \`No space left on device\`.
The root cause was a runaway debug log file that filled the entire partition.

## Troubleshooting Steps
1. Executed \`df -h\` to confirm the primary partition was at 100% capacity.
2. Executed \`du -h --max-depth=2 /var | sort -hr\` to find the largest directories.
3. Discovered \`/var/log/myapp\` was consuming 99% of the disk.
4. Executed \`ls -lhS /var/log/myapp\` and identified \`application_debug.log\` as the culprit.

## Resolution
- Truncated the log file in place using \`> /var/log/myapp/application_debug.log\`.
  *(Note: We specifically avoided using \`rm\` because if the application process was still holding the file descriptor open, \`rm\` would remove the pointer but the OS would not free the actual disk space until the app restarted).*
- Restarted the database service successfully.

## Prevention
1. **Log Rotation:** Configure \`logrotate\` for \`/var/log/myapp/*.log\` to compress daily and keep only 7 days of history.
2. **Monitoring:** Set up Datadog/Prometheus alerts to trigger a Warning at 80% disk usage and Critical at 90%, preventing 100% outages.
3. **App Config:** Ensure debug logging is disabled in production environments.
RCADOC

  echo -e "\n  ${GREEN}✔${RESET} RCA document saved: ${RCA_FILE}"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  simulate_incident
  perform_rca
  apply_fix
  generate_rca_doc

  echo -e "\n${GREEN}${BOLD}  ✅ INCIDENT RESOLVED | Week 05 Day 3 — COMPLETE${RESET}"
}

main "$@"
