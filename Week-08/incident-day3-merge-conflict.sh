#!/usr/bin/env bash
# =============================================================================
# Week 08 - Day 3 INCIDENT: Merge Conflict Resolution
# DevOps 2026 Track | Phase 2: Git + Modern Workflow
# =============================================================================
# SCENARIO: Two developers edited the same line of configuration. When the
#           second developer tries to merge their PR, Git blocks it due to
#           a merge conflict. You must resolve the conflict cleanly.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week08-incident"
RCA_FILE="${LAB_DIR}/RCA-week08-merge-conflict.md"

log_incident() { echo -e "\n${RED}${BOLD}[INCIDENT]${RESET} $1"; }
log_rca()      { echo -e "\n${YELLOW}${BOLD}[RCA]${RESET} $1"; }
log_fix()      { echo -e "\n${GREEN}${BOLD}[FIX]${RESET} $1"; }
log_info()     { echo -e "  ${CYAN}▶${RESET} $1"; }

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "══════════════════════════════════════════════════════"
  echo "  🚨 INCIDENT SIM | Week 08 Day 3 | Merge Conflict"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Setup Broken State ────────────────────────────────────────────────────────
simulate_incident() {
  log_incident "SCENARIO: 'Git says I have conflicts and I cannot merge my PR!'"
  
  rm -rf "${LAB_DIR}"
  mkdir -p "${LAB_DIR}"
  cd "${LAB_DIR}"
  
  git init > /dev/null
  git config user.name "DevOps 2026 Student"
  git config user.email "student@devops2026.local"
  git branch -M main
  
  # Base commit
  echo 'SERVER_PORT=8080' > config.env
  git add config.env
  git commit -m "init: baseline config" > /dev/null
  
  # Dev A creates a branch and changes port to 9090
  git checkout -b dev-A-feature > /dev/null
  echo 'SERVER_PORT=9090' > config.env
  git add config.env
  git commit -m "fix: change port to 9090 for security" > /dev/null
  
  # Dev B creates a branch from main and changes port to 3000
  git checkout main > /dev/null
  git checkout -b dev-B-feature > /dev/null
  echo 'SERVER_PORT=3000' > config.env
  git add config.env
  git commit -m "fix: change port to 3000 for frontend dev" > /dev/null
  
  # Dev A merges their PR successfully first
  git checkout main > /dev/null
  git merge dev-A-feature -m "Merge branch dev-A-feature" > /dev/null
  log_info "Developer A's PR was merged to main."
  
  # Dev B attempts to merge their PR
  log_info "Developer B attempts to merge their branch..."
  echo -e "  ${BOLD}Running: git merge dev-B-feature${RESET}"
  
  if git merge dev-B-feature > /dev/null 2>&1; then
      echo "Merge succeeded (This should not happen!)"
  else
      echo -e "  ${RED}Auto-merging config.env${RESET}"
      echo -e "  ${RED}CONFLICT (content): Merge conflict in config.env${RESET}"
      echo -e "  ${RED}Automatic merge failed; fix conflicts and then commit the result.${RESET}"
  fi
}

# ─── RCA & FIX: Root Cause Analysis and Remediation ────────────────────────────
perform_rca_and_fix() {
  log_rca "INVESTIGATING & FIXING"
  cd "${LAB_DIR}"
  
  echo -e "  ${CYAN}[CHECK]${RESET} Examining the conflicted file:"
  echo "  ----------------------------------------------------"
  cat config.env | sed 's/^/  /'
  echo "  ----------------------------------------------------"
  
  echo -e "\n  ${BOLD}Analysis:${RESET} Both developers modified line 1."
  echo "  HEAD (main) has 9090. dev-B-feature has 3000."
  
  log_fix "REMEDIATION: Resolving the conflict"
  
  echo "  We decide the correct port is 9090 (Developer A's choice)."
  echo "  Editing the file to remove Git markers and keep the correct line..."
  
  # Fix the file
  echo "SERVER_PORT=9090" > config.env
  
  echo -e "\n  ${BOLD}File resolved. Staging and committing the merge:${RESET}"
  echo "  Command: git add config.env"
  echo "  Command: git commit -m 'Merge branch dev-B-feature (resolved conflict)'"
  
  git add config.env
  git commit -m "Merge branch dev-B-feature (resolved conflict)" > /dev/null
  
  log_info "Conflict resolved and merge finalized."
  
  echo -e "\n  ${BOLD}Git Log verification:${RESET}"
  git log --oneline --graph | head -n 5 | sed 's/^/    /'
}

# ─── Generate RCA Document ────────────────────────────────────────────────────
generate_rca_doc() {
  log_fix "Generating formal RCA document"
  cd "${LAB_DIR}"

  cat > "${RCA_FILE}" << RCADOC
# Incident RCA: Git Merge Conflict Resolution
## Week 08 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Severity:** Routine Pipeline Blocker
**Status:** ✅ RESOLVED

---

## Incident Summary
A Pull Request was blocked from merging into \`main\` due to a Git merge conflict in \`config.env\`. 
Two developers had simultaneously modified the \`SERVER_PORT\` variable on their respective feature branches.

## Remediation Steps
1. Attempted to merge \`dev-B-feature\` into \`main\`, resulting in a \`CONFLICT (content)\` warning.
2. Opened the \`config.env\` file and observed Git's conflict markers:
   \`\`\`
   <<<<<<< HEAD
   SERVER_PORT=9090
   =======
   SERVER_PORT=3000
   >>>>>>> dev-B-feature
   \`\`\`
3. Coordinated with the development team and determined that \`9090\` was the correct port for the SIT environment.
4. Manually deleted the conflict markers and the incorrect line (\`3000\`).
5. Saved the file, ran \`git add config.env\`, and finalized the merge with \`git commit\`.

## Prevention
- Frequent, small PRs reduce the surface area for merge conflicts.
- Developers should run \`git pull origin main --rebase\` frequently on their local branches to catch conflicts early before opening a PR.
RCADOC

  echo -e "\n  ${GREEN}✔${RESET} RCA document saved: ${RCA_FILE}"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  simulate_incident
  perform_rca_and_fix
  generate_rca_doc

  echo -e "\n${GREEN}${BOLD}  ✅ INCIDENT RESOLVED | Week 08 Day 3 — COMPLETE${RESET}"
}

main "$@"
