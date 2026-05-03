#!/usr/bin/env bash
# ============================================================
# Week 32 - Day 3 Incident: Alerting and On-Call
# DevOps 2026 Track
# Scenario: alert-storm — diagnose and remediate
# ============================================================
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
LAB_DIR="/tmp/devops2026-week32-incident"
RCA_FILE="${LAB_DIR}/RCA-week32-alert-storm.md"
mkdir -p "${LAB_DIR}"

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "=========================================================="
  echo "  INCIDENT SIM | Week 32 | alert-storm"
  echo "=========================================================="
  echo -e "${RESET}"
}

simulate_incident() {
  echo -e "${RED}[INCIDENT]${RESET} Simulating failure: alert-storm"
  echo "Simulated failure at $(date)" > "${LAB_DIR}/failure.log"
  echo -e "  Application is down. Alert triggered."
}

perform_rca() {
  echo -e "\n${YELLOW}[RCA]${RESET} Investigating root cause..."
  echo -e "  ${CYAN}[CHECK 1]${RESET} Reviewing logs and system state."
  echo -e "  ${CYAN}[CHECK 2]${RESET} Identifying the root cause component."
  echo -e "  Conclusion: Root cause identified for scenario: alert-storm"
}

apply_fix() {
  echo -e "\n${GREEN}[FIX]${RESET} Applying remediation..."
  echo "Remediation applied at $(date)" >> "${LAB_DIR}/failure.log"
  echo -e "  ${GREEN}SUCCESS:${RESET} System restored."
}

generate_rca_doc() {
  cat > "${RCA_FILE}" <<RCADOC
# Incident RCA: Alerting and On-Call
## Week 32 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Incident:** alert-storm
**Severity:** High
**Status:** RESOLVED

## Incident Summary
A production failure occurred related to: alert-storm.
This is a simulated incident to train engineers to identify and remediate common Alerting and On-Call failures.

## Root Cause
The failure was triggered by a misconfiguration or a missing dependency in the Alerting and On-Call layer.

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
  echo -e "\n${GREEN}${BOLD}  INCIDENT RESOLVED | Week 32 Day 3 — COMPLETE${RESET}"
}
main "$@"
