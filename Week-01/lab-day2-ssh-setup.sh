#!/usr/bin/env bash
# =============================================================================
# Week 01 - Day 2 Lab: SSH Setup & Server Basics
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# Usage: bash lab-day2-ssh-setup.sh
# Description: Automates SSH key generation, displays connection instructions,
#              creates a service user, and sets up sudo access.
# AI Used: Claude Code CLI for script structure and hardening checks
# =============================================================================

set -euo pipefail

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Config ────────────────────────────────────────────────────────────────────
KEY_NAME="id_ed25519_devops"
KEY_DIR="${HOME}/.ssh"
KEY_PATH="${KEY_DIR}/${KEY_NAME}"
SERVICE_USER="devopslab"

# ─── Helpers ───────────────────────────────────────────────────────────────────
log_step() { echo -e "\n${CYAN}${BOLD}[STEP]${RESET} $1"; }
log_ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }
log_warn() { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
log_err()  { echo -e "  ${RED}✘${RESET} $1"; }

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "══════════════════════════════════════════════════════"
  echo "   DevOps 2026 | Week 01 | Day 2 Lab: SSH Setup"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Step 1: Generate SSH Key ──────────────────────────────────────────────────
generate_ssh_key() {
  log_step "Generating SSH ED25519 Key Pair"

  mkdir -p "${KEY_DIR}"
  chmod 700 "${KEY_DIR}"

  if [[ -f "${KEY_PATH}" ]]; then
    log_warn "Key already exists at ${KEY_PATH}. Skipping generation."
  else
    ssh-keygen -t ed25519 -C "devops-2026-lab" -f "${KEY_PATH}" -N ""
    log_ok "Key generated: ${KEY_PATH}"
    log_ok "Public key:    ${KEY_PATH}.pub"
  fi

  echo ""
  echo -e "${BOLD}Public Key Content (copy this to your server's authorized_keys):${RESET}"
  echo "─────────────────────────────────────────────────────"
  cat "${KEY_PATH}.pub"
  echo "─────────────────────────────────────────────────────"
}

# ─── Step 2: Check SSH Config Best Practices ──────────────────────────────────
check_ssh_config() {
  log_step "SSH Config Security Check (local perspective)"

  # Check key permissions
  KEY_PERMS=$(stat -c "%a" "${KEY_PATH}" 2>/dev/null || echo "unknown")
  if [[ "${KEY_PERMS}" == "600" ]]; then
    log_ok "Private key permissions are correct (600)"
  else
    log_warn "Private key permissions: ${KEY_PERMS} (should be 600)"
    chmod 600 "${KEY_PATH}" && log_ok "Fixed private key permissions to 600"
  fi

  PUB_PERMS=$(stat -c "%a" "${KEY_PATH}.pub" 2>/dev/null || echo "unknown")
  if [[ "${PUB_PERMS}" == "644" ]]; then
    log_ok "Public key permissions are correct (644)"
  else
    chmod 644 "${KEY_PATH}.pub" && log_ok "Fixed public key permissions to 644"
  fi
}

# ─── Step 3: SSH Connection Instructions ──────────────────────────────────────
print_connection_guide() {
  log_step "How to Connect to a Remote VM"

  echo -e "${BOLD}Basic SSH Connection:${RESET}"
  echo "  ssh -i ${KEY_PATH} <username>@<server-ip>"
  echo ""
  echo -e "${BOLD}With custom port:${RESET}"
  echo "  ssh -i ${KEY_PATH} -p <port> <username>@<server-ip>"
  echo ""
  echo -e "${BOLD}Add key to SSH agent (recommended):${RESET}"
  echo "  eval \$(ssh-agent -s)"
  echo "  ssh-add ${KEY_PATH}"
  echo ""
  echo -e "${BOLD}Test connection verbosely (great for debugging):${RESET}"
  echo "  ssh -vvv -i ${KEY_PATH} <username>@<server-ip>"
}

# ─── Step 4: Service User Creation Script (for Linux servers) ─────────────────
generate_server_setup_script() {
  log_step "Generating Server-Side User Setup Script"

  SERVER_SCRIPT="${HOME}/DevOps-2026/Week-01/scripts/server-user-setup.sh"
  mkdir -p "$(dirname "${SERVER_SCRIPT}")"

  cat > "${SERVER_SCRIPT}" << 'SERVERSCRIPT'
#!/usr/bin/env bash
# =============================================================================
# Server-side: Create service user with sudo, set up SSH authorized_keys
# Run this ON the remote server as root or existing sudo user
# =============================================================================
set -euo pipefail

SERVICE_USER="devopslab"
SSH_DIR="/home/${SERVICE_USER}/.ssh"
AUTH_KEYS="${SSH_DIR}/authorized_keys"

# Replace this with your actual public key content
PUBLIC_KEY="PASTE_YOUR_PUBLIC_KEY_HERE"

# Create user if not exists
if id "${SERVICE_USER}" &>/dev/null; then
  echo "User ${SERVICE_USER} already exists"
else
  useradd -m -s /bin/bash "${SERVICE_USER}"
  echo "Created user: ${SERVICE_USER}"
fi

# Grant sudo access (no password for lab — tighten in PROD)
echo "${SERVICE_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${SERVICE_USER}
chmod 440 /etc/sudoers.d/${SERVICE_USER}

# Set up SSH authorized_keys
mkdir -p "${SSH_DIR}"
echo "${PUBLIC_KEY}" >> "${AUTH_KEYS}"
chmod 700 "${SSH_DIR}"
chmod 600 "${AUTH_KEYS}"
chown -R "${SERVICE_USER}:${SERVICE_USER}" "${SSH_DIR}"

echo "✔ User ${SERVICE_USER} configured with SSH access and sudo"
echo ""
echo "Production hardening (add to /etc/ssh/sshd_config):"
echo "  PermitRootLogin no"
echo "  PasswordAuthentication no"
echo "  PubkeyAuthentication yes"
echo "  AllowUsers ${SERVICE_USER}"
echo ""
echo "Then reload: systemctl reload sshd"
SERVERSCRIPT

  chmod +x "${SERVER_SCRIPT}"
  log_ok "Server setup script created: ${SERVER_SCRIPT}"
  log_warn "Edit the PUBLIC_KEY variable in the script with your actual key before running on server"
}

# ─── Step 5: Verify & Summary ─────────────────────────────────────────────────
print_summary() {
  log_step "Lab Summary"

  echo ""
  echo -e "${BOLD}Files Created:${RESET}"
  [[ -f "${KEY_PATH}" ]]     && echo "  ${GREEN}✔${RESET} ${KEY_PATH}"
  [[ -f "${KEY_PATH}.pub" ]] && echo "  ${GREEN}✔${RESET} ${KEY_PATH}.pub"

  local server_script="${HOME}/DevOps-2026/Week-01/scripts/server-user-setup.sh"
  [[ -f "${server_script}" ]] && echo "  ${GREEN}✔${RESET} ${server_script}"

  echo ""
  echo -e "${BOLD}Next Steps:${RESET}"
  echo "  1. Provision an Azure VM (az vm create ...)"
  echo "  2. Copy your public key to the VM's authorized_keys"
  echo "  3. SSH in and run server-user-setup.sh as root"
  echo "  4. Test connection as '${SERVICE_USER}' user"
  echo ""
  echo -e "${BOLD}AI Tip:${RESET} Use Claude to generate the az vm create command:"
  echo "  claude \"Write an Azure CLI command to create an Ubuntu 22.04 VM"
  echo "         in East US with SSH key auth and open port 22\""
  echo ""
  echo -e "${GREEN}${BOLD}Week 01 Day 2 Lab — COMPLETE ✔${RESET}"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  generate_ssh_key
  check_ssh_config
  print_connection_guide
  generate_server_setup_script
  print_summary
}

main "$@"
