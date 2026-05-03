#!/usr/bin/env bash
# =============================================================================
# Week 07 - Day 3 INCIDENT: Wrong Branch Commit
# DevOps 2026 Track | Phase 2: Git + Modern Workflow
# =============================================================================
# SCENARIO: A developer accidentally committed feature work directly to the
#           'main' branch instead of creating a feature branch first.
#           Your job: Move those commits to a new branch, reset 'main' back
#           to its clean state, and document the fix.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week07-incident"
RCA_FILE="${LAB_DIR}/RCA-week07-wrong-branch.md"

log_incident() { echo -e "\n${RED}${BOLD}[INCIDENT]${RESET} $1"; }
log_rca()      { echo -e "\n${YELLOW}${BOLD}[RCA]${RESET} $1"; }
log_fix()      { echo -e "\n${GREEN}${BOLD}[FIX]${RESET} $1"; }
log_info()     { echo -e "  ${CYAN}▶${RESET} $1"; }

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "══════════════════════════════════════════════════════"
  echo "  🚨 INCIDENT SIM | Week 07 Day 3 | Wrong Branch"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Setup Broken State ────────────────────────────────────────────────────────
simulate_incident() {
  log_incident "SCENARIO: 'Oops! I committed my feature directly to main!'"
  
  rm -rf "${LAB_DIR}"
  mkdir -p "${LAB_DIR}"
  cd "${LAB_DIR}"
  
  git init > /dev/null
  git config user.name "DevOps 2026 Student"
  git config user.email "student@devops2026.local"
  git branch -M main
  
  # Stable main state
  echo "Base Code" > file.txt
  git add file.txt
  git commit -m "init: stable production code" > /dev/null
  
  CLEAN_HASH=$(git log -1 --format="%h")
  log_info "Main branch was stable at commit ${CLEAN_HASH}."
  
  # The mistake: Committing directly to main
  echo -e "\n  ${RED}Developer starts coding without branching...${RESET}"
  
  echo "Feature Part 1" >> file.txt
  git add file.txt
  git commit -m "feat(wip): started working on the new API" > /dev/null
  
  echo "Feature Part 2" >> file.txt
  git add file.txt
  git commit -m "feat(wip): finished API, waiting for QA" > /dev/null
  
  echo -e "\n  ${BOLD}Current Git Log on 'main':${RESET}"
  git log --oneline | sed 's/^/    /'
  
  echo -e "\n  ${RED}PROBLEM: 'main' is now polluted with untested WIP commits!${RESET}"
}

# ─── RCA & FIX: Root Cause Analysis and Remediation ────────────────────────────
perform_rca_and_fix() {
  log_rca "INVESTIGATING & FIXING"
  cd "${LAB_DIR}"
  
  echo -e "  ${BOLD}Step 1: Create the feature branch from the current state.${RESET}"
  echo "  Command: git branch feature/new-api"
  
  git branch feature/new-api
  log_info "Created 'feature/new-api' (it now points to the latest WIP commit)."
  
  echo -e "\n  ${BOLD}Step 2: Reset 'main' back to the stable commit.${RESET}"
  # We know the stable commit was HEAD~2
  echo "  Command: git reset --hard HEAD~2"
  
  git reset --hard HEAD~2 > /dev/null
  log_info "'main' branch successfully reset to stable state."
  
  echo -e "\n  ${BOLD}Step 3: Switch to the feature branch to continue work.${RESET}"
  echo "  Command: git checkout feature/new-api"
  git checkout feature/new-api > /dev/null
  
  echo -e "\n  ${BOLD}Verification - Git Log on 'feature/new-api':${RESET}"
  git log --oneline | sed 's/^/    /'
  
  echo -e "\n  ${BOLD}Verification - Git Log on 'main':${RESET}"
  git checkout main > /dev/null
  git log --oneline | sed 's/^/    /'
}

# ─── Generate RCA Document ────────────────────────────────────────────────────
generate_rca_doc() {
  log_fix "Generating formal RCA document"
  cd "${LAB_DIR}"

  cat > "${RCA_FILE}" << RCADOC
# Incident RCA: Commits Made to Wrong Branch
## Week 07 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Severity:** Low (Caught locally before push)
**Status:** ✅ RESOLVED

---

## Incident Summary
A developer accidentally authored two "Work In Progress" (WIP) commits directly on the \`main\` branch instead of creating a feature branch first.

## Remediation Steps
Since the commits were only local and not pushed to a remote repository, it was safe to rewrite history.

1. **Protect the work:** Created a new branch pointing to the current state.
   \`git branch feature/new-api\`
2. **Clean the main branch:** Reset the \`main\` branch back two commits to its last stable state.
   \`git reset --hard HEAD~2\`
3. **Continue work:** Checked out the new feature branch.
   \`git checkout feature/new-api\`

## Prevention
- Configure local Git hooks or use branch protection rules in Azure Repos/GitHub to completely block direct pushes to the \`main\` branch.
- Adopt a habit of running \`git status\` before starting any new coding session.
RCADOC

  echo -e "\n  ${GREEN}✔${RESET} RCA document saved: ${RCA_FILE}"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  simulate_incident
  perform_rca_and_fix
  generate_rca_doc

  echo -e "\n${GREEN}${BOLD}  ✅ INCIDENT RESOLVED | Week 07 Day 3 — COMPLETE${RESET}"
}

main "$@"
