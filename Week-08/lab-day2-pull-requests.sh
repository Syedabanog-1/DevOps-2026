#!/usr/bin/env bash
# =============================================================================
# Week 08 - Day 2 Lab: PR Workflow & Automated Checks
# DevOps 2026 Track | Phase 2: Git + Modern Workflow
# =============================================================================
# Description: This lab simulates a CI pipeline running against a local branch.
#              It checks for linting errors and runs mock tests before allowing
#              a merge to the 'main' branch.
# =============================================================================

set -euo pipefail

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week08-lab"

log_step() { echo -e "\n${CYAN}${BOLD}[STEP]${RESET} $1"; }
log_ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "══════════════════════════════════════════════════════"
  echo "   DevOps 2026 | Week 08 | Day 2 Lab: CI Pipelines"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Step 1: Initialize Repository ─────────────────────────────────────────────
init_repo() {
  log_step "Initializing Repository & Main Branch"
  
  rm -rf "${LAB_DIR}"
  mkdir -p "${LAB_DIR}"
  cd "${LAB_DIR}"
  
  git init > /dev/null
  git config user.name "DevOps 2026 Student"
  git config user.email "student@devops2026.local"
  
  # Create the main file
  cat > calc.py << 'EOF'
def add(a, b):
    return a + b
EOF

  git add calc.py
  git commit -m "init: baseline calculator logic" > /dev/null
  git branch -M main
  log_ok "Baseline code committed to 'main'."
}

# ─── Step 2: Feature Branch with Bugs ──────────────────────────────────────────
feature_work() {
  log_step "Creating Feature Branch (feature/multiply)"
  cd "${LAB_DIR}"
  
  git checkout -b feature/multiply > /dev/null
  
  # Add multiplication but include a syntax issue and a failing test
  cat >> calc.py << 'EOF'

def multiply(a, b):
    # Syntax error simulated (missing return statement)
    result = a * b
EOF

  git add calc.py
  git commit -m "feat: added multiplication logic" > /dev/null
  log_ok "Committed buggy feature to feature branch."
}

# ─── Step 3: Simulate CI Pipeline (Automated PR Checks) ───────────────────────
simulate_ci_pipeline() {
  log_step "Simulating PR Creation & Automated CI Pipeline"
  cd "${LAB_DIR}"
  
  echo -e "  ${BOLD}Running 'lint' check...${RESET}"
  # We simulate a linter failing because of the missing return
  if grep -q "result = a \* b" calc.py && ! grep -q "return result" calc.py; then
      echo -e "  ${RED}❌ Linting Failed: Variable 'result' is assigned but never used.${RESET}"
      echo -e "  ${RED}❌ Tests Failed: multiply(2, 3) returned None instead of 6.${RESET}"
      echo -e "\n  ${BOLD}PR Merge Blocked! You must fix the code.${RESET}"
  fi
  
  log_step "Developer fixes the code..."
  cat > calc.py << 'EOF'
def add(a, b):
    return a + b

def multiply(a, b):
    return a * b
EOF

  git add calc.py
  git commit -m "fix: corrected multiply return statement" > /dev/null
  log_ok "Fix committed."
  
  echo -e "\n  ${BOLD}Re-running CI Pipeline...${RESET}"
  echo -e "  ${GREEN}✔ Linting Passed.${RESET}"
  echo -e "  ${GREEN}✔ Tests Passed: multiply(2, 3) returned 6.${RESET}"
  
  echo -e "\n  ${BOLD}PR Approved! Merging to main...${RESET}"
  git checkout main > /dev/null
  git merge --no-ff feature/multiply -m "Merge pull request #1 from feature/multiply" > /dev/null
  
  log_ok "Feature successfully validated and merged to main."
  git log --oneline --graph | sed 's/^/    /'
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  init_repo
  feature_work
  simulate_ci_pipeline
  
  echo -e "\n${GREEN}${BOLD}Week 08 Day 2 Lab — COMPLETE ✔${RESET}"
}

main "$@"
