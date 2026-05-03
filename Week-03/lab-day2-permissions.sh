#!/usr/bin/env bash
# =============================================================================
# Week 03 - Day 2 Lab: Users, Permissions & Ownership
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# Description: Creates a mock service user, sets up an application directory,
#              and applies strict ownership and permissions.
# NOTE: Must be run as root (or with sudo).
# =============================================================================

set -euo pipefail

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

SERVICE_USER="webworker"
APP_DIR="/opt/webapp"
LOG_DIR="/var/log/webapp"

log_step() { echo -e "\n${CYAN}${BOLD}[STEP]${RESET} $1"; }
log_ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }
log_warn() { echo -e "  ${YELLOW}⚠${RESET} $1"; }

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "══════════════════════════════════════════════════════"
  echo "   DevOps 2026 | Week 03 | Day 2 Lab: Permissions"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root.${RESET}" 
   exit 1
fi

# ─── Step 1: Create Service User ───────────────────────────────────────────────
create_user() {
  log_step "Creating dedicated service user: ${SERVICE_USER}"
  
  if id "${SERVICE_USER}" &>/dev/null; then
      log_warn "User ${SERVICE_USER} already exists. Resetting."
      userdel -f "${SERVICE_USER}" || true
  fi
  
  # Create user with no login shell (security best practice)
  useradd -r -s /usr/sbin/nologin "${SERVICE_USER}"
  log_ok "Created user ${SERVICE_USER} with no login shell."
  
  echo "  Identity info:"
  id "${SERVICE_USER}" | sed 's/^/    /'
}

# ─── Step 2: Directory Setup & Ownership ───────────────────────────────────────
setup_directories() {
  log_step "Setting up application and log directories"
  
  # App directory (Read-only for the service, owned by root to prevent tampering)
  mkdir -p "${APP_DIR}"
  echo "echo 'Web App Running...'" > "${APP_DIR}/run.sh"
  chown -R root:root "${APP_DIR}"
  chmod 755 "${APP_DIR}"
  chmod 755 "${APP_DIR}/run.sh"
  log_ok "Set up ${APP_DIR} (Owned by root, executable by everyone)"

  # Log directory (Writable by the service)
  mkdir -p "${LOG_DIR}"
  chown -R "${SERVICE_USER}:${SERVICE_USER}" "${LOG_DIR}"
  chmod 755 "${LOG_DIR}"
  log_ok "Set up ${LOG_DIR} (Owned by ${SERVICE_USER}, writable by ${SERVICE_USER})"
}

# ─── Step 3: Verifying Permissions ─────────────────────────────────────────────
verify_permissions() {
  log_step "Verifying permission constraints"
  
  # Test 1: Can the user write to the log directory?
  if su -s /bin/bash -c "touch ${LOG_DIR}/access.log" "${SERVICE_USER}"; then
      log_ok "User ${SERVICE_USER} successfully wrote to ${LOG_DIR}"
  else
      echo -e "  ${RED}Failed: User could not write to log directory.${RESET}"
  fi
  
  # Test 2: Can the user modify the application code? (Should FAIL)
  echo "  Testing if ${SERVICE_USER} can tamper with the app code (Should get Permission Denied)..."
  if su -s /bin/bash -c "echo 'malicious code' >> ${APP_DIR}/run.sh" "${SERVICE_USER}" 2>/dev/null; then
      echo -e "  ${RED}Security Failure: User tampered with app code!${RESET}"
  else
      log_ok "Security Check Passed: User ${SERVICE_USER} CANNOT modify ${APP_DIR}/run.sh"
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  create_user
  setup_directories
  verify_permissions
  
  echo -e "\n${GREEN}${BOLD}Week 03 Day 2 Lab — COMPLETE ✔${RESET}"
}

main "$@"
