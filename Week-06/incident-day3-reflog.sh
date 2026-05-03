#!/usr/bin/env bash
# =============================================================================
# Week 06 - Day 3 INCIDENT: Lost Commits & Reflog Recovery
# DevOps 2026 Track | Phase 2: Git + Modern Workflow
# =============================================================================
# SCENARIO: A junior engineer accidentally ran `git reset --hard` and deleted
#           the last 3 commits containing crucial payment gateway code!
#           Your job: Use `git reflog` to find the lost commits and restore
#           the repository to its correct state.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week06-incident"
RCA_FILE="${LAB_DIR}/RCA-week06-git-recovery.md"

log_incident() { echo -e "\n${RED}${BOLD}[INCIDENT]${RESET} $1"; }
log_rca()      { echo -e "\n${YELLOW}${BOLD}[RCA]${RESET} $1"; }
log_fix()      { echo -e "\n${GREEN}${BOLD}[FIX]${RESET} $1"; }
log_info()     { echo -e "  ${CYAN}▶${RESET} $1"; }

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "══════════════════════════════════════════════════════"
  echo "  🚨 INCIDENT SIM | Week 06 Day 3 | Lost Git History"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Setup Broken State ────────────────────────────────────────────────────────
simulate_incident() {
  log_incident "SCENARIO: 'Help! I accidentally deleted a week of work!'"
  
  rm -rf "${LAB_DIR}"
  mkdir -p "${LAB_DIR}"
  cd "${LAB_DIR}"
  
  git init > /dev/null
  git config user.name "DevOps 2026 Student"
  git config user.email "student@devops2026.local"
  
  # Base commit
  echo "print('App Core')" > core.py
  git add core.py
  git commit -m "init: core application setup" > /dev/null
  
  # The "crucial work" commits
  echo "def process_payment(): pass" > payments.py
  git add payments.py
  git commit -m "feat: added Stripe payment integration" > /dev/null
  
  echo "def validate_card(): pass" >> payments.py
  git add payments.py
  git commit -m "feat: added credit card validation logic" > /dev/null
  
  echo "def send_receipt(): pass" >> payments.py
  git add payments.py
  git commit -m "feat: automated email receipts" > /dev/null
  
  # Save the hash of the target state for later verification
  TARGET_HASH=$(git log -1 --format="%h")
  
  log_info "The repository previously looked like this:"
  git log --oneline | sed 's/^/    /'
  
  echo -e "\n  ${RED}Junior engineer runs: git reset --hard HEAD~3${RESET}"
  git reset --hard HEAD~3 > /dev/null
  
  echo -e "\n  ${BOLD}Current Broken Git Log:${RESET}"
  git log --oneline | sed 's/^/    /'
  
  echo -e "\n  ${BOLD}Files currently on disk:${RESET}"
  ls -la | sed 's/^/    /'
}

# ─── RCA: Root Cause Analysis ─────────────────────────────────────────────────
perform_rca() {
  log_rca "INVESTIGATING: Root Cause Analysis"
  cd "${LAB_DIR}"
  
  echo -e "  ${CYAN}[CHECK 1]${RESET} Check the git reflog to find 'ghost' commits:"
  echo "  Command: git reflog"
  echo "  ----------------------------------------------------"
  git reflog | head -n 5 | sed 's/^/  /'
  echo "  ----------------------------------------------------"
  
  echo -e "\n  ${BOLD}Analysis:${RESET} 'git log' only shows reachable commits."
  echo "  'git reflog' shows every move the HEAD pointer has made."
  echo "  We can clearly see the 'automated email receipts' commit"
  echo "  existed before the hard reset."
}

# ─── FIX: Apply Remediation ───────────────────────────────────────────────────
apply_fix() {
  log_fix "REMEDIATION: Restoring the lost timeline"
  cd "${LAB_DIR}"
  
  # Extract the hash of the "automated email receipts" commit from the reflog
  LOST_HASH=$(git reflog | grep "automated email receipts" | awk '{print $1}')
  
  echo -e "  ${BOLD}Restoring repository state to the lost commit (${LOST_HASH}):${RESET}"
  echo "  Command: git reset --hard ${LOST_HASH}"
  
  git reset --hard "${LOST_HASH}" > /dev/null
  log_info "Repository successfully restored."
  
  echo -e "\n  ${BOLD}Verifying restored files:${RESET}"
  ls -la | sed 's/^/    /'
  
  echo -e "\n  ${BOLD}Verifying restored Git Log:${RESET}"
  git log --oneline | sed 's/^/    /'
}

# ─── Generate RCA Document ────────────────────────────────────────────────────
generate_rca_doc() {
  log_fix "Generating formal RCA document"
  cd "${LAB_DIR}"

  cat > "${RCA_FILE}" << RCADOC
# Incident RCA: Git History Deletion (Hard Reset)
## Week 06 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Severity:** High (Data Loss Risk)
**Status:** ✅ RESOLVED

---

## Incident Summary
An engineer accidentally executed \`git reset --hard HEAD~3\`, which deleted the last 3 commits from the local timeline. These commits contained critical unpushed payment gateway code.

## Root Cause
\`git reset --hard\` destroys uncommitted changes in the working directory AND moves the HEAD pointer backward, making subsequent commits "unreachable" via standard \`git log\`.

## Resolution
Git rarely deletes data immediately. Even "deleted" commits are stored securely for at least 30 days.
1. We utilized \`git reflog\` to view the historical movement of the HEAD pointer.
2. We identified the short hash of the commit directly prior to the reset (\`automated email receipts\`).
3. We restored the timeline by running \`git reset --hard <hash>\` targeting that specific reflog entry.

All code and commit history was successfully recovered.

## Prevention
- Restrict direct pushes and history rewrites (\`git push --force\`) on main branches.
- Educate engineers to use \`git revert\` instead of \`git reset\` for undoing work, or strictly use branches for experimental resets.
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

  echo -e "\n${GREEN}${BOLD}  ✅ INCIDENT RESOLVED | Week 06 Day 3 — COMPLETE${RESET}"
}

main "$@"
