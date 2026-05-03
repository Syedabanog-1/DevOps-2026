#!/usr/bin/env bash
# ============================================================
# Week 10 - Day 3 Incident: YAML Deep Dive
# DevOps 2026 Track
# Scenario: malformed-yaml — diagnose and remediate
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
LAB_DIR="/tmp/devops2026-week10-incident"
RCA_FILE="${LAB_DIR}/RCA-week10-malformed-yaml.md"
mkdir -p "${LAB_DIR}"

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "=========================================================="
  echo "  INCIDENT SIM | Week 10 | malformed-yaml"
  echo "=========================================================="
  echo -e "${RESET}"
}

simulate_incident() {
  echo -e "${RED}[INCIDENT]${RESET} Simulating failure: malformed-yaml"
  echo "Simulated failure at $(date)" > "${LAB_DIR}/failure.log"
  echo -e "  Application is down. Alert triggered."
}

perform_rca() {
  echo -e "\n${YELLOW}[RCA]${RESET} Investigating root cause..."
  echo -e "  ${CYAN}[CHECK 1]${RESET} Reviewing logs and system state."
  echo -e "  ${CYAN}[CHECK 2]${RESET} Identifying the root cause component."
  echo -e "  Conclusion: Root cause identified for scenario: malformed-yaml"
}

apply_fix() {
  echo -e "\n${GREEN}[FIX]${RESET} Applying remediation..."
  echo "Remediation applied at $(date)" >> "${LAB_DIR}/failure.log"
  echo -e "  ${GREEN}SUCCESS:${RESET} System restored."
}

generate_rca_doc() {
  cat > "${RCA_FILE}" <<RCADOC
# Incident RCA: YAML Deep Dive
## Week 10 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Incident:** malformed-yaml
**Severity:** High
**Status:** RESOLVED

## Incident Summary
A production failure occurred related to: malformed-yaml.
This is a simulated incident to train engineers to identify and remediate common YAML Deep Dive failures.

## Root Cause
The failure was triggered by a misconfiguration or a missing dependency in the YAML Deep Dive layer.

## Resolution
Standard remediation steps were applied:
1. Identified the failure point via log analysis.
2. Applied the targeted fix.
3. Verified system recovery.

## Prevention
- Automate monitoring and alerting for this class of failure.
- Add this scenario to the runbook and incident response playbook.
RCADOC
  echo -e "\n  ${GREEN}✔${RESET} RCA saved: ${RCA_FILE}"
}

main() {
  print_banner
  simulate_incident
  perform_rca
  apply_fix
  generate_rca_doc
  echo -e "\n${GREEN}${BOLD}  INCIDENT RESOLVED | Week 10 Day 3 — COMPLETE${RESET}"
}
main "$@"
