#!/usr/bin/env bash
# =============================================================================
# Week 03 - Day 3 INCIDENT: Permission Denied for Service
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# SCENARIO: A background service crashes immediately upon startup because
#           it gets a "Permission Denied" when trying to write to its log file.
#           Your job: diagnose the ownership/permission issue and fix it safely.
# NOTE: Must be run as root.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

SERVICE_USER="webworker"
LOG_DIR="/var/log/webapp"
LOG_FILE="${LOG_DIR}/application.log"
RCA_FILE="${LOG_DIR}/RCA-week03-permission-denied.md"

log_incident() { echo -e "\n${RED}${BOLD}[INCIDENT]${RESET} $1"; }
log_rca()      { echo -e "\n${YELLOW}${BOLD}[RCA]${RESET} $1"; }
log_fix()      { echo -e "\n${GREEN}${BOLD}[FIX]${RESET} $1"; }
log_info()     { echo -e "  ${CYAN}▶${RESET} $1"; }

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root.${RESET}" 
   exit 1
fi

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "══════════════════════════════════════════════════════"
  echo "  🚨 INCIDENT SIM | Week 03 Day 3 | Permission Denied"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Setup Broken State ────────────────────────────────────────────────────────
simulate_incident() {
  log_incident "SCENARIO: Service crashes due to log file permissions!"
  
  # Ensure user and directories exist
  mkdir -p "${LOG_DIR}"
  id "${SERVICE_USER}" &>/dev/null || useradd -r -s /usr/sbin/nologin "${SERVICE_USER}"
  
  # Deliberately break the permissions: Make log file owned by root and read-only
  touch "${LOG_FILE}"
  chown root:root "${LOG_FILE}"
  chmod 644 "${LOG_FILE}"
  
  log_info "Attempting to start the service as user '${SERVICE_USER}'..."
  echo ""
  
  # Simulate the service trying to write to the log
  if su -s /bin/bash -c "echo 'Starting up...' >> ${LOG_FILE}" "${SERVICE_USER}" 2>/dev/null; then
     echo "Service started."
  else
     echo -e "  ${RED}FATAL: /bin/bash: line 1: ${LOG_FILE}: Permission denied${RESET}"
  fi
  
  echo ""
  log_info "Application crashed. Alert triggered."
}

# ─── RCA: Root Cause Analysis ─────────────────────────────────────────────────
perform_rca() {
  log_rca "INVESTIGATING: Root Cause Analysis"
  
  echo -e "  ${CYAN}[CHECK 1]${RESET} Check permissions on the specific log file:"
  echo "  Command: ls -l ${LOG_FILE}"
  ls -l "${LOG_FILE}" | sed 's/^/    /'
  
  echo -e "\n  ${CYAN}[CHECK 2]${RESET} Check who the service is running as:"
  echo "  The service runs as: ${SERVICE_USER}"
  
  echo -e "\n  ${BOLD}Conclusion:${RESET} The file ${LOG_FILE} is owned by 'root'."
  echo "  The user '${SERVICE_USER}' only has read permissions (rw-r--r--) on it."
  echo "  Therefore, the service cannot append logs to it."
}

# ─── FIX: Apply Remediation ───────────────────────────────────────────────────
apply_fix() {
  log_fix "REMEDIATION: Fixing ownership securely"
  
  echo -e "  ${BOLD}Incorrect Fix (DO NOT DO THIS):${RESET}"
  echo "  chmod 777 ${LOG_FILE}  <-- Massive security vulnerability"
  
  echo -e "\n  ${BOLD}Correct Fix:${RESET}"
  echo "  Command: chown ${SERVICE_USER}:${SERVICE_USER} ${LOG_FILE}"
  
  chown "${SERVICE_USER}:${SERVICE_USER}" "${LOG_FILE}"
  log_info "Ownership updated."
  
  echo "  Command: ls -l ${LOG_FILE}"
  ls -l "${LOG_FILE}" | sed 's/^/    /'
  
  echo -e "\n  ${BOLD}Verifying application startup:${RESET}"
  echo ""
  if su -s /bin/bash -c "echo 'Starting up...' >> ${LOG_FILE}" "${SERVICE_USER}"; then
      echo -e "  ${GREEN}SUCCESS: Service started successfully and wrote to log.${RESET}"
  fi
}

# ─── Generate RCA Document ────────────────────────────────────────────────────
generate_rca_doc() {
  log_fix "Generating formal RCA document"

  cat > "${RCA_FILE}" << RCADOC
# Incident RCA: Permission Denied on App Logs
## Week 03 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Severity:** High (Service Crash)
**Status:** ✅ RESOLVED

---

## Incident Summary
The \`webapp\` service failed to start, logging a \`Permission denied\` error when attempting to write to \`/var/log/webapp/application.log\`.

## Root Cause
The log file was incorrectly owned by \`root\` instead of the service account (\`webworker\`).
\`-rw-r--r-- 1 root root 0 May  3 18:00 /var/log/webapp/application.log\`

This usually happens if a developer or operator runs the application manually using \`sudo\` or as \`root\`, creating the log file with root ownership before the background service starts.

## Resolution
We changed the ownership of the file to the correct service account using \`chown\`:
\`\`\`bash
chown webworker:webworker /var/log/webapp/application.log
\`\`\`
The application was restarted and verified to be working. We explicitly avoided using \`chmod 777\` as it violates the principle of least privilege.

## Prevention
- Standardize service deployments via Systemd and Ansible to ensure correct ownership.
- Add log rotation config (logrotate) that creates new log files with \`create 0640 webworker webworker\`.
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

  echo -e "\n${GREEN}${BOLD}  ✅ INCIDENT RESOLVED | Week 03 Day 3 — COMPLETE${RESET}"
}

main "$@"
