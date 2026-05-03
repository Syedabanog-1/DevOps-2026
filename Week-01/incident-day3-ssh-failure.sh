#!/usr/bin/env bash
# =============================================================================
# Week 01 - Day 3 INCIDENT: SSH Connection Failure
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# SCENARIO: A production server is unreachable via SSH.
#           Engineers are getting "Permission denied" and "Connection refused".
#           Your job: diagnose and document the root cause.
#
# INCIDENT SIMULATION (local): This script intentionally misconfigures SSH
# settings and then walks through the RCA + fix process.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

KEY_PATH="${HOME}/DevOps-2026/Week-01/.ssh/id_ed25519_devops"
INCIDENT_DIR="${HOME}/DevOps-2026/Week-01/incident"
RCA_FILE="${INCIDENT_DIR}/RCA-week01-ssh-failure.md"

log_incident() { echo -e "\n${RED}${BOLD}[INCIDENT]${RESET} $1"; }
log_rca()      { echo -e "\n${YELLOW}${BOLD}[RCA]${RESET} $1"; }
log_fix()      { echo -e "\n${GREEN}${BOLD}[FIX]${RESET} $1"; }
log_info()     { echo -e "  ${CYAN}▶${RESET} $1"; }

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "══════════════════════════════════════════════════════"
  echo "  🚨 INCIDENT SIM | Week 01 Day 3 | SSH Failure"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── INCIDENT: Simulate the broken state ──────────────────────────────────────
simulate_incident() {
  log_incident "SCENARIO: SSH to prod-server-01 is failing!"
  echo ""
  echo -e "  Team report from Slack: ${BOLD}\"Can't SSH into prod-server-01."
  echo -e "  Getting 'Permission denied (publickey)'. Deploy is blocked!\"${RESET}"
  echo ""

  log_incident "Step 1: Recreate the symptoms (breaking things intentionally)"

  # Simulate wrong key permissions (too permissive)
  mkdir -p "${INCIDENT_DIR}"
  cp "${KEY_PATH}" "${INCIDENT_DIR}/broken_key"
  chmod 777 "${INCIDENT_DIR}/broken_key"  # WRONG: should be 600
  log_info "Broken key created with permissions 777 (insecure, SSH will reject)"

  # Simulate wrong public key path
  FAKE_PUBKEY="${INCIDENT_DIR}/nonexistent_key.pub"
  log_info "Simulating: using wrong key path → ${FAKE_PUBKEY}"

  echo ""
  echo -e "  ${BOLD}Simulated SSH Command (would fail in real scenario):${RESET}"
  echo "  ssh -i ${INCIDENT_DIR}/broken_key user@192.168.1.100"
  echo ""
  echo -e "  ${RED}Expected errors you would see:${RESET}"
  echo "  1. @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  echo "     @         WARNING: UNPROTECTED PRIVATE KEY FILE!          @"
  echo "     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  echo "     Permissions 0777 for 'broken_key' are too open."
  echo "     This private key will be IGNORED."
  echo ""
  echo "  2. Permission denied (publickey)."
  echo "     → Server rejected because key was ignored entirely"
}

# ─── RCA: Root Cause Analysis ─────────────────────────────────────────────────
perform_rca() {
  log_rca "INVESTIGATING: Root Cause Analysis"

  echo ""
  echo -e "${BOLD}Systematic Troubleshooting Steps:${RESET}"
  echo ""

  echo -e "  ${CYAN}[CHECK 1]${RESET} Can we reach the server at all?"
  echo "  Command: ping -c 3 <server-ip>"
  echo "  Command: nc -zv <server-ip> 22"
  echo "  → If ping fails: network/firewall issue"
  echo "  → If port 22 unreachable: SSH daemon not running OR wrong port"
  echo ""

  echo -e "  ${CYAN}[CHECK 2]${RESET} Verbose SSH to see exact failure point:"
  echo "  Command: ssh -vvv -i ${KEY_PATH} user@<server-ip>"
  echo "  → Look for: 'Offering public key', 'Server accepts key'"
  echo "  → If 'key not accepted': check authorized_keys on server"
  echo ""

  echo -e "  ${CYAN}[CHECK 3]${RESET} Check key file permissions (MOST COMMON ISSUE):"
  echo "  Command: ls -la ~/.ssh/"
  echo "  Expected: -rw------- (600) for private key"
  echo "  Expected: -rw-r--r-- (644) for public key"
  echo "  Expected: drwx------ (700) for .ssh directory"
  echo ""

  echo -e "  ${CYAN}[CHECK 4]${RESET} Verify correct key being used:"
  echo "  Command: ssh-add -l  ← lists keys in ssh-agent"
  echo "  Command: cat ~/.ssh/authorized_keys ← on server"
  echo ""

  echo -e "  ${CYAN}[CHECK 5]${RESET} Check server SSH logs (on the server):"
  echo "  Command: sudo journalctl -u sshd -n 50"
  echo "  Command: sudo tail -f /var/log/auth.log"
  echo ""

  echo -e "  ${CYAN}[CHECK 6]${RESET} Check SSH config on server:"
  echo "  Command: sudo sshd -T | grep -E 'permitroot|passauth|pubkey'"
  echo "  → Confirm: PasswordAuthentication no → keys REQUIRED"
  echo "  → Confirm: PubkeyAuthentication yes"

  # ── Common Root Causes (ranked) ───
  echo ""
  echo -e "${BOLD}Common Root Causes (Ranked by Frequency):${RESET}"
  printf "  %-3s %-35s %s\n" "1." "Wrong key permissions (777/755)" "→ SSH silently ignores key"
  printf "  %-3s %-35s %s\n" "2." "Wrong key file specified (-i)"  "→ Server key mismatch"
  printf "  %-3s %-35s %s\n" "3." "Public key not in authorized_keys" "→ Server rejects auth"
  printf "  %-3s %-35s %s\n" "4." "Wrong username"                  "→ 'ubuntu' not 'root'"
  printf "  %-3s %-35s %s\n" "5." "Firewall blocking port 22"        "→ Connection timeout"
  printf "  %-3s %-35s %s\n" "6." "SSH daemon not running"           "→ Connection refused"
  printf "  %-3s %-35s %s\n" "7." "Wrong port (non-22 config)"       "→ Connection refused"
}

# ─── FIX: Apply the remediation ───────────────────────────────────────────────
apply_fix() {
  log_fix "REMEDIATION: Fixing the broken state"

  echo ""
  echo -e "${BOLD}Fix 1: Correct key permissions${RESET}"
  chmod 600 "${INCIDENT_DIR}/broken_key"
  ls -la "${INCIDENT_DIR}/broken_key"
  log_info "Fixed: permissions set to 600"

  echo ""
  echo -e "${BOLD}Fix 2: Ensure .ssh directory has correct permissions${RESET}"
  chmod 700 "${HOME}/DevOps-2026/Week-01/.ssh"
  log_info "Fixed: .ssh directory set to 700"

  echo ""
  echo -e "${BOLD}Fix 3: Verify key integrity${RESET}"
  if ssh-keygen -l -f "${KEY_PATH}.pub" &>/dev/null; then
    log_info "Key integrity: VALID"
    ssh-keygen -l -f "${KEY_PATH}.pub"
  fi

  echo ""
  echo -e "${BOLD}Fix 4: Server-side commands (reference — run on the actual server):${RESET}"
  echo "  # Fix authorized_keys permissions"
  echo "  chmod 600 ~/.ssh/authorized_keys"
  echo "  chmod 700 ~/.ssh"
  echo ""
  echo "  # Verify public key is in authorized_keys"
  echo "  cat ~/.ssh/authorized_keys"
  echo ""
  echo "  # Restart SSH daemon if needed"
  echo "  sudo systemctl restart sshd"
  echo "  sudo systemctl status sshd"
}

# ─── Generate RCA Document ────────────────────────────────────────────────────
generate_rca_doc() {
  log_fix "Generating formal RCA document"

  cat > "${RCA_FILE}" << RCADOC
# Incident RCA: SSH Connection Failure
## Week 01 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Severity:** High (deploy pipeline blocked)
**Duration:** ~15 minutes (simulated)
**Status:** ✅ RESOLVED

---

## Incident Summary
SSH connection to production server was failing with:
\`Permission denied (publickey)\`

The root cause was **incorrect file permissions on the private SSH key** (set to 777
instead of required 600), causing the SSH client to silently ignore the key and
fail authentication.

---

## Timeline
| Time     | Event |
|----------|-------|
| T+0:00   | Alert: Deploy pipeline fails with SSH error |
| T+2:00   | Engineer attempts \`ssh -vvv\` → sees key warning |
| T+5:00   | Identified: key permissions were 777 |
| T+7:00   | Applied fix: \`chmod 600 ~/.ssh/id_ed25519_devops\` |
| T+8:00   | SSH connection restored |
| T+15:00  | RCA documented |

---

## Root Cause
Private SSH key had permissions **0777** (world-readable/writable).

SSH enforces strict key protection — it **silently rejects** keys that are
readable by others. This is a security feature, not a bug.

---

## Resolution
\`\`\`bash
# Fix private key permissions
chmod 600 ~/.ssh/id_ed25519_devops

# Fix .ssh directory permissions
chmod 700 ~/.ssh

# Fix authorized_keys on server (if needed)
chmod 600 ~/.ssh/authorized_keys
\`\`\`

---

## Prevention / Action Items
- [ ] Add permission check to onboarding runbook
- [ ] Create pre-flight SSH check script (runs before deploys)
- [ ] Add to CI/CD pipeline: validate SSH key permissions in agent setup
- [ ] Document in team wiki: "SSH Troubleshooting Guide"

---

## AI Usage
- Used **Claude Code CLI** to analyze verbose SSH output and identify
  the permission mismatch as the primary suspect
- AI prompt used: *"My SSH connection gives 'Permission denied publickey'.
  Here is the output of ssh -vvv. What are the most likely causes and fixes?"*

---

## Lessons Learned
1. Always run \`ssh -vvv\` for verbose debugging — it reveals exactly what's failing
2. SSH key permissions are a frequent, easy-to-miss issue
3. Check the *client side* (key permissions) AND the *server side* (authorized_keys, sshd config)
4. AI tools dramatically speed up log analysis and RCA
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

  echo ""
  echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD}  ✅ INCIDENT RESOLVED | Week 01 Day 3 — COMPLETE${RESET}"
  echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════${RESET}"
}

main "$@"
