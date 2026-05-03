#!/usr/bin/env bash
# =============================================================================
# Week 07 - Day 2 Lab: Branching & Feature Toggles
# DevOps 2026 Track | Phase 2: Git + Modern Workflow
# =============================================================================
# Description: Simulates trunk-based development by creating a feature branch,
#              adding a feature toggle (flag), and merging back to main.
# =============================================================================

set -euo pipefail

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week07-lab"

log_step() { echo -e "\n${CYAN}${BOLD}[STEP]${RESET} $1"; }
log_ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "══════════════════════════════════════════════════════"
  echo "   DevOps 2026 | Week 07 | Day 2 Lab: Branching"
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
  cat > app.py << 'EOF'
def main():
    print("Welcome to the Application")

if __name__ == "__main__":
    main()
EOF

  # Create config file
  cat > config.json << 'EOF'
{
  "features": {
    "new_dashboard": false
  }
}
EOF

  git add app.py config.json
  git commit -m "init: baseline application" > /dev/null
  # Rename default branch to main if it's not already
  git branch -M main
  log_ok "Baseline code committed to 'main'."
}

# ─── Step 2: Feature Branch & Toggles ──────────────────────────────────────────
feature_work() {
  log_step "Creating Feature Branch (feature/new-dashboard)"
  cd "${LAB_DIR}"
  
  git checkout -b feature/new-dashboard > /dev/null
  log_ok "Switched to new branch: feature/new-dashboard"
  
  # Modify app.py to include the feature toggle
  cat > app.py << 'EOF'
import json

def load_config():
    with open('config.json', 'r') as f:
        return json.load(f)

def render_new_dashboard():
    print(">>> Rendering the AWESOME new dashboard! <<<")

def main():
    config = load_config()
    print("Welcome to the Application")
    
    # Feature Toggle Implementation
    if config.get("features", {}).get("new_dashboard") == True:
        render_new_dashboard()

if __name__ == "__main__":
    main()
EOF

  git add app.py
  git commit -m "feat: added new dashboard behind feature toggle" > /dev/null
  log_ok "Committed feature toggle logic."
  
  echo -e "\n  ${BOLD}Testing app with feature flag OFF (Default):${RESET}"
  python3 app.py | sed 's/^/    /'
}

# ─── Step 3: Merge & Release ───────────────────────────────────────────────────
merge_and_release() {
  log_step "Merging to Main & Enabling Feature"
  cd "${LAB_DIR}"
  
  git checkout main > /dev/null
  log_ok "Switched back to 'main' branch."
  
  echo "  Merging feature branch into main..."
  git merge --no-ff feature/new-dashboard -m "Merge pull request #1 from feature/new-dashboard" > /dev/null
  log_ok "Merge successful."
  
  echo -e "\n  ${BOLD}Simulating Deployment to Production...${RESET}"
  echo "  Enabling feature flag in config.json!"
  
  # Flip the toggle
  sed -i 's/"new_dashboard": false/"new_dashboard": true/' config.json
  git add config.json
  git commit -m "chore: enable new_dashboard feature flag in production" > /dev/null
  
  echo -e "\n  ${BOLD}Testing app with feature flag ON:${RESET}"
  python3 app.py | sed 's/^/    /'
  
  echo -e "\n  ${BOLD}Git Log History:${RESET}"
  git log --graph --oneline | sed 's/^/    /'
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  init_repo
  feature_work
  merge_and_release
  
  echo -e "\n${GREEN}${BOLD}Week 07 Day 2 Lab — COMPLETE ✔${RESET}"
}

main "$@"
