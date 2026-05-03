#!/usr/bin/env bash
# =============================================================================
# Week 02 - Day 3 INCIDENT: App cannot find config file
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# SCENARIO: An application fails to start because it cannot find its
#           configuration file. The configuration file was accidentally moved.
#           Your job: use find/locate to find it, fix the path, and verify.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week02-incident"
APP_BIN="${LAB_DIR}/app/start.sh"
CONFIG_NAME="app-settings.conf"
EXPECTED_CONFIG_PATH="${LAB_DIR}/app/config/${CONFIG_NAME}"
WRONG_CONFIG_PATH="${LAB_DIR}/backup/${CONFIG_NAME}"
RCA_FILE="${LAB_DIR}/RCA-week02-config-path.md"

log_incident() { echo -e "\n${RED}${BOLD}[INCIDENT]${RESET} $1"; }
log_rca()      { echo -e "\n${YELLOW}${BOLD}[RCA]${RESET} $1"; }
log_fix()      { echo -e "\n${GREEN}${BOLD}[FIX]${RESET} $1"; }
log_info()     { echo -e "  ${CYAN}▶${RESET} $1"; }

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "══════════════════════════════════════════════════════"
  echo "  🚨 INCIDENT SIM | Week 02 Day 3 | Config Not Found"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Setup Broken State ────────────────────────────────────────────────────────
simulate_incident() {
  log_incident "SCENARIO: Application fails to start in production!"
  
  rm -rf "${LAB_DIR}"
  mkdir -p "${LAB_DIR}/app/config"
  mkdir -p "${LAB_DIR}/backup"
  
  # Create the startup script that looks for the config
  cat > "${APP_BIN}" << EOF
#!/bin/bash
if [[ ! -f "${EXPECTED_CONFIG_PATH}" ]]; then
  echo "FATAL: Configuration file missing at ${EXPECTED_CONFIG_PATH}"
  exit 1
fi
echo "SUCCESS: Application started successfully."
EOF
  chmod +x "${APP_BIN}"
  
  # Deliberately place the config in the WRONG directory
  echo "db_connection=active" > "${WRONG_CONFIG_PATH}"
  
  log_info "Attempting to start the application..."
  echo ""
  ${APP_BIN} || true
  echo ""
  log_info "Application crashed. Deploy pipeline halted."
}

# ─── RCA: Root Cause Analysis ─────────────────────────────────────────────────
perform_rca() {
  log_rca "INVESTIGATING: Root Cause Analysis"
  
  echo -e "  ${CYAN}[CHECK 1]${RESET} What does the error say?"
  echo "  Error explicitly states: FATAL: Configuration file missing at ${EXPECTED_CONFIG_PATH}"
  
  echo -e "\n  ${CYAN}[CHECK 2]${RESET} Verify if the file is actually missing:"
  echo "  Command: ls -la ${EXPECTED_CONFIG_PATH}"
  echo "  Result: ls: cannot access '${EXPECTED_CONFIG_PATH}': No such file or directory"
  
  echo -e "\n  ${CYAN}[CHECK 3]${RESET} Search the entire system for the file:"
  echo "  Command: find ${LAB_DIR} -name \"${CONFIG_NAME}\""
  echo "  Result:"
  find "${LAB_DIR}" -name "${CONFIG_NAME}" | sed 's/^/    /'
  
  echo -e "\n  ${BOLD}Conclusion:${RESET} The file ${CONFIG_NAME} was moved to the backup directory"
  echo "  and is no longer in the app/config directory where the app expects it."
}

# ─── FIX: Apply Remediation ───────────────────────────────────────────────────
apply_fix() {
  log_fix "REMEDIATION: Restoring the config file"
  
  echo -e "  ${BOLD}Moving the file to the correct location:${RESET}"
  echo "  Command: mv ${WRONG_CONFIG_PATH} ${EXPECTED_CONFIG_PATH}"
  mv "${WRONG_CONFIG_PATH}" "${EXPECTED_CONFIG_PATH}"
  log_info "File moved."
  
  echo -e "\n  ${BOLD}Verifying application startup:${RESET}"
  echo ""
  ${APP_BIN}
  echo ""
  log_info "Application is running."
}

# ─── Generate RCA Document ────────────────────────────────────────────────────
generate_rca_doc() {
  log_fix "Generating formal RCA document"

  cat > "${RCA_FILE}" << RCADOC
# Incident RCA: Application Config Not Found
## Week 02 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Severity:** High (App Crash)
**Status:** ✅ RESOLVED

---

## Incident Summary
The application failed to start with a \`FATAL: Configuration file missing\` error.
The root cause was that the \`${CONFIG_NAME}\` file was accidentally moved to the \`backup\` directory.

## Resolution
Used the \`find\` command to locate the missing configuration file on the filesystem:
\`\`\`bash
find /tmp/devops2026-week02-incident -name "app-settings.conf"
\`\`\`
Moved the file back to its expected location:
\`\`\`bash
mv /tmp/devops2026-week02-incident/backup/app-settings.conf /tmp/devops2026-week02-incident/app/config/app-settings.conf
\`\`\`

## Prevention
- Implement automated configuration management (e.g., Ansible) to enforce file state.
- Make application startup scripts more resilient or log clearer paths.
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

  echo -e "\n${GREEN}${BOLD}  ✅ INCIDENT RESOLVED | Week 02 Day 3 — COMPLETE${RESET}"
}

main "$@"
