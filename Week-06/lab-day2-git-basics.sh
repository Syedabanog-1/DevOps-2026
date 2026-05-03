#!/usr/bin/env bash
# =============================================================================
# Week 06 - Day 2 Lab: Git Fundamentals
# DevOps 2026 Track | Phase 2: Git + Modern Workflow
# =============================================================================
# Description: This lab simulates creating a repository, making multiple
#              commits, simulating a bad deployment, and using git revert.
# =============================================================================

set -euo pipefail

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week06-lab"

log_step() { echo -e "\n${CYAN}${BOLD}[STEP]${RESET} $1"; }
log_ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "══════════════════════════════════════════════════════"
  echo "   DevOps 2026 | Week 06 | Day 2 Lab: Git Basics"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Step 1: Initialize Repository ─────────────────────────────────────────────
init_repo() {
  log_step "Initializing local Git repository"
  
  rm -rf "${LAB_DIR}"
  mkdir -p "${LAB_DIR}"
  cd "${LAB_DIR}"
  
  git init > /dev/null
  git config user.name "DevOps 2026 Student"
  git config user.email "student@devops2026.local"
  
  log_ok "Repository created at ${LAB_DIR}"
}

# ─── Step 2: Create Commit History ─────────────────────────────────────────────
create_commits() {
  log_step "Building application commit history"
  cd "${LAB_DIR}"
  
  # Commit 1
  echo "print('Application version 1.0')" > app.py
  git add app.py
  git commit -m "feat: initial release v1.0" > /dev/null
  log_ok "Created Commit 1: v1.0"
  
  # Commit 2
  echo "print('Application version 1.1')" > app.py
  echo "# Config settings" > config.yml
  git add app.py config.yml
  git commit -m "feat: upgrade to v1.1 and add config" > /dev/null
  log_ok "Created Commit 2: v1.1"
  
  # Commit 3 (The Bug)
  echo "print('Application version 1.2 - CRITICAL BUG INJECTED')" > app.py
  git add app.py
  git commit -m "feat: new algorithm v1.2" > /dev/null
  log_ok "Created Commit 3: v1.2 (Contains a simulated critical bug)"
}

# ─── Step 3: Revert the Bug ────────────────────────────────────────────────────
revert_bug() {
  log_step "Simulating Production Incident & Rollback"
  cd "${LAB_DIR}"
  
  echo -e "  ${RED}ALERT: Production is down due to commit v1.2!${RESET}"
  echo -e "  ${BOLD}Current Git Log:${RESET}"
  git log --oneline -n 3 | sed 's/^/    /'
  
  # Find the hash of the latest commit (the buggy one)
  BUGGY_HASH=$(git log -1 --format="%h")
  
  echo -e "\n  ${BOLD}Executing Safe Rollback using git revert...${RESET}"
  echo "  Command: git revert --no-edit ${BUGGY_HASH}"
  
  # Revert the commit without opening the editor
  git revert --no-edit "${BUGGY_HASH}" > /dev/null
  
  log_ok "Successfully reverted commit ${BUGGY_HASH}"
  
  echo -e "\n  ${BOLD}New Git Log (Notice the revert commit was added):${RESET}"
  git log --oneline -n 4 | sed 's/^/    /'
  
  echo -e "\n  ${BOLD}Current Application State (Back to v1.1):${RESET}"
  cat app.py | sed 's/^/    /'
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  init_repo
  create_commits
  revert_bug
  
  echo -e "\n${GREEN}${BOLD}Week 06 Day 2 Lab — COMPLETE ✔${RESET}"
}

main "$@"
