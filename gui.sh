#!/bin/bash

# --- Color Definitions ---
GREEN='\033[1;32m'
MAGENTA='\033[1;35m'
NC='\033[0m'

echo -e "${GREEN}> INITIATING GRAPHICAL TARGET SEQUENCE...${NC}"
sleep 1
echo -e "${MAGENTA}> ELEVATING PRIVILEGES REQUIRED.${NC}"

# Switch to graphical target
# Note: This usually kills the current TTY session as it switches modes.
sudo systemctl isolate graphical.target

# Start GDM (GNOME Display Manager)
sudo systemctl start gdm.service

# If the script is still running (unlikely if isolate worked), exit.
exit 0
