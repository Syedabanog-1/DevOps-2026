#!/usr/bin/env bash
# =============================================================================
# Week 04 - Day 3 INCIDENT: High CPU Runaway Process
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# SCENARIO: An alert triggers for 100% CPU usage on a critical VM.
#           Your job: identify the runaway process causing the spike,
#           terminate it gracefully if possible, or force kill it,
#           and document the RCA.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week04-incident"
RUNAWAY_SCRIPT="${LAB_DIR}/crypto-miner-mock.sh"
RCA_FILE="${LAB_DIR}/RCA-week04-high-cpu.md"

log_incident() { echo -e "\n${RED}${BOLD}[INCIDENT]${RESET} $1"; }
log_rca()      { echo -e "\n${YELLOW}${BOLD}[RCA]${RESET} $1"; }
log_fix()      { echo -e "\n${GREEN}${BOLD}[FIX]${RESET} $1"; }
log_info()     { echo -e "  ${CYAN}▶${RESET} $1"; }

print_banner() {
  echo -e "${RED}${BOLD}"
  echo "══════════════════════════════════════════════════════"
  echo "  🚨 INCIDENT SIM | Week 04 Day 3 | High CPU Runaway"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Setup Broken State ────────────────────────────────────────────────────────
simulate_incident() {
  log_incident "SCENARIO: Datadog alert fires — Server CPU is at 100%!"
  
  mkdir -p "${LAB_DIR}"
  
  # Create a script that creates an infinite CPU loop
  cat > "${RUNAWAY_SCRIPT}" << 'EOF'
#!/bin/bash
# Mock runaway process (simulating a crypto miner or infinite loop bug)
while true; do
  # Perform meaningless math to burn CPU
  ans=$(( 1000000 * 1000000 ))
done
EOF
  chmod +x "${RUNAWAY_SCRIPT}"
  
  log_info "Spawning the runaway process..."
  
  # Run in background
  "${RUNAWAY_SCRIPT}" &
  MALICIOUS_PID=$!
  
  # Give it a second to consume CPU
  sleep 2
  
  log_info "Runaway process spawned (PID intentionally hidden from you in scenario)."
  echo -e "  ${RED}System load is spiking... UI is unresponsive...${RESET}"
}

# ─── RCA: Root Cause Analysis ─────────────────────────────────────────────────
perform_rca() {
  log_rca "INVESTIGATING: Root Cause Analysis"
  
  echo -e "  ${CYAN}[CHECK 1]${RESET} Find the process consuming the most CPU:"
  echo "  Command: ps -eo pid,pcpu,pmem,comm,cmd --sort=-pcpu | head -n 5"
  
  # Run the command to show the top CPU consumers
  echo "  ----------------------------------------------------"
  ps -eo pid,pcpu,pmem,comm,cmd --sort=-pcpu | head -n 5 | sed 's/^/  /'
  echo "  ----------------------------------------------------"
  
  echo -e "\n  ${CYAN}[CHECK 2]${RESET} Isolate the specific rogue script:"
  echo "  Command: pgrep -a -f crypto-miner-mock"
  pgrep -a -f "crypto-miner-mock" | sed 's/^/  /'
  
  # Extract the PID programmatically for the fix step
  TARGET_PID=$(pgrep -f "crypto-miner-mock" | head -n 1)
  
  echo -e "\n  ${BOLD}Conclusion:${RESET} The script 'crypto-miner-mock.sh' (PID: ${TARGET_PID})"
  echo "  is stuck in an infinite loop consuming 100% of a CPU core."
}

# ─── FIX: Apply Remediation ───────────────────────────────────────────────────
apply_fix() {
  log_fix "REMEDIATION: Terminating the runaway process"
  
  TARGET_PID=$(pgrep -f "crypto-miner-mock" | head -n 1)
  
  echo -e "  ${BOLD}Step 1: Attempt Graceful Shutdown (SIGTERM)${RESET}"
  echo "  Command: kill -15 ${TARGET_PID}"
  kill -15 "${TARGET_PID}" 2>/dev/null || true
  
  sleep 1
  
  if pgrep -f "crypto-miner-mock" > /dev/null; then
      echo -e "  ${YELLOW}Process ignored SIGTERM (it's stuck in a hard loop).${RESET}"
      
      echo -e "  ${BOLD}Step 2: Force Kill (SIGKILL)${RESET}"
      echo "  Command: kill -9 ${TARGET_PID}"
      kill -9 "${TARGET_PID}" 2>/dev/null || true
      sleep 1
      log_info "SIGKILL sent."
  else
      log_info "Process terminated gracefully."
  fi
  
  echo -e "\n  ${BOLD}Verifying system recovery:${RESET}"
  if pgrep -f "crypto-miner-mock" > /dev/null; then
      echo -e "  ${RED}FATAL: Process is still alive!${RESET}"
  else
      echo -e "  ${GREEN}SUCCESS: Process destroyed. CPU load returning to normal.${RESET}"
  fi
}

# ─── Generate RCA Document ────────────────────────────────────────────────────
generate_rca_doc() {
  log_fix "Generating formal RCA document"

  cat > "${RCA_FILE}" << RCADOC
# Incident RCA: 100% CPU Runaway Process
## Week 04 Day 3 | DevOps 2026 Track

**Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Severity:** Critical (System Unresponsive)
**Status:** ✅ RESOLVED

---

## Incident Summary
Monitoring alerts fired indicating a VM was pinned at 100% CPU utilization.
The root cause was a rogue script (\`crypto-miner-mock.sh\`) stuck in an infinite mathematical loop.

## Troubleshooting Steps
1. Connected via SSH to the unresponsive server.
2. Ran \`ps -eo pid,pcpu,pmem,comm,cmd --sort=-pcpu | head -n 5\` to identify the top CPU consumer.
3. Identified the process \`crypto-miner-mock.sh\` consuming 99%+ CPU.

## Resolution
- Sent \`SIGTERM\` (\`kill -15 <PID>\`): The process failed to terminate gracefully as it was locked in a tight CPU loop without yielding.
- Sent \`SIGKILL\` (\`kill -9 <PID>\`): The kernel successfully destroyed the process immediately.
- System load immediately dropped to normal levels.

## Prevention
- Implement CPU limits (cgroups/Docker limits) for untrusted or experimental scripts.
- Ensure monitoring systems trigger alerts at 85% CPU for 5 minutes, rather than waiting for 100% lockups.
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

  echo -e "\n${GREEN}${BOLD}  ✅ INCIDENT RESOLVED | Week 04 Day 3 — COMPLETE${RESET}"
}

main "$@"
