#!/usr/bin/env bash
# =============================================================================
# Week 04 - Day 2 Lab: Processes, Monitoring & Signals
# DevOps 2026 Track | Phase 1: Linux + Networking Foundations
# =============================================================================
# Description: This lab simulates spawning multiple background processes,
#              identifying them using 'ps', and safely terminating them.
# =============================================================================

set -euo pipefail

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

LAB_DIR="/tmp/devops2026-week04-lab"

log_step() { echo -e "\n${CYAN}${BOLD}[STEP]${RESET} $1"; }
log_ok()   { echo -e "  ${GREEN}✔${RESET} $1"; }

print_banner() {
  echo -e "${BOLD}${CYAN}"
  echo "══════════════════════════════════════════════════════"
  echo "   DevOps 2026 | Week 04 | Day 2 Lab: Processes"
  echo "══════════════════════════════════════════════════════"
  echo -e "${RESET}"
}

# ─── Step 1: Simulate Workloads ───────────────────────────────────────────────
spawn_workloads() {
  log_step "Spawning mock background workloads"
  
  mkdir -p "${LAB_DIR}"
  
  # Script that acts like a healthy daemon (sleeps in a loop)
  cat > "${LAB_DIR}/healthy-daemon.sh" << 'EOF'
#!/bin/bash
echo "Daemon started with PID $$"
while true; do sleep 5; done
EOF
  chmod +x "${LAB_DIR}/healthy-daemon.sh"

  # Start 3 instances in the background
  "${LAB_DIR}/healthy-daemon.sh" &
  PID1=$!
  "${LAB_DIR}/healthy-daemon.sh" &
  PID2=$!
  "${LAB_DIR}/healthy-daemon.sh" &
  PID3=$!
  
  log_ok "Spawned 3 daemon processes: PIDs ${PID1}, ${PID2}, ${PID3}"
}

# ─── Step 2: Identify Processes ────────────────────────────────────────────────
identify_processes() {
  log_step "Identifying processes using 'ps'"
  
  echo -e "  ${BOLD}Running: ps aux | grep healthy-daemon${RESET}"
  echo "  ----------------------------------------------------"
  ps aux | grep "healthy-daemon" | grep -v "grep" | sed 's/^/  /' || true
  echo "  ----------------------------------------------------"
  log_ok "Successfully identified running daemons."
}

# ─── Step 3: Send Signals (Graceful Termination) ──────────────────────────────
terminate_processes() {
  log_step "Sending SIGTERM (15) to processes"
  
  echo -e "  ${BOLD}Extracting PIDs using pgrep...${RESET}"
  # Using pgrep is cleaner than ps aux | grep
  PIDS=$(pgrep -f "healthy-daemon.sh" || true)
  
  if [[ -n "${PIDS}" ]]; then
    for PID in ${PIDS}; do
       echo "  Sending SIGTERM to PID ${PID}..."
       kill -15 "${PID}"
    done
    sleep 1
    log_ok "Processes successfully terminated via SIGTERM."
  else
    echo "  No processes found."
  fi
  
  echo -e "\n  ${BOLD}Verifying termination:${RESET}"
  if pgrep -f "healthy-daemon.sh" > /dev/null; then
     echo -e "  ${RED}Some processes are still running!${RESET}"
  else
     log_ok "All healthy-daemon processes are gone."
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_banner
  spawn_workloads
  identify_processes
  terminate_processes
  
  echo -e "\n${GREEN}${BOLD}Week 04 Day 2 Lab — COMPLETE ✔${RESET}"
}

main "$@"
