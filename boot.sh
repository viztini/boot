#!/bin/bash

# --- Color Definitions ---
GREEN='\033[1;32m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

# Clear screen to start
clear

# --- Phase 1: Genact Boot Sequence (5 Seconds) ---
if command -v genact &> /dev/null; then
    timeout 5s genact -m bootlog
    clear
else
    echo -e "${MAGENTA}> GENACT NOT FOUND. SKIPPING SIMULATION...${NC}"
    sleep 1
    clear
fi

# --- Phase 2: Initialization & Neofetch ---
echo -e "${GREEN}> BOOT INITIALIZED${NC}"
sleep 1

# Neofetch in Magenta
echo -e "${MAGENTA}"
if command -v neofetch &> /dev/null; then
    neofetch
else
    echo "> Neofetch not found."
fi

# Wait 3 seconds
sleep 3

# --- Phase 3: The Wired Sequence ---
echo -e "${GREEN}"
echo "> SYSTEM BOOT..."
sleep 1
echo "> LOADING PROTOCOLS..."
sleep 1
echo "> CONNECTING TO THE WIRED..."
sleep 1
echo "> CONNECTION ESTABLISHED"
sleep 1
echo "> WELCOME, $USER"
sleep 1

# --- Phase 4: The Interface Menu ---
while true; do
    echo -e "${NC}" 
    echo -e "${MAGENTA}========================================"
    echo -e "       ${GREEN}AVAILABLE PROTOCOLS${MAGENTA}"
    echo -e "========================================"
    echo -e "${MAGENTA}[1] ${GREEN}> USE TERMINAL ${MAGENTA}(EXIT)"
    echo -e "${MAGENTA}[2] ${GREEN}> BROWSE THE WEB ${MAGENTA}(W3M)"
    echo -e "${MAGENTA}[3] ${GREEN}> CODE ${MAGENTA}(VIM)"
    echo -e "${MAGENTA}[4] ${GREEN}> START GRAPHICAL INTERFACE ${MAGENTA}(GUI)"
    echo -e "${MAGENTA}[5] ${GREEN}> SHUTDOWN ${MAGENTA}(POWEROFF)"
    echo -e "${MAGENTA}[6] ${GREEN}> RESTART ${MAGENTA}(REBOOT)"
    echo -e "${MAGENTA}========================================"
    
    # Prompt
    echo -ne "${GREEN}> SELECT OPTION >> ${MAGENTA}"
    read choice

    case $choice in
        1)
            echo -e "${GREEN}> DISCONNECTING...${NC}"
            sleep 1
            clear
            break
            ;;
        2)
            echo -e "${GREEN}> INITIALIZING BROWSER...${NC}"
            w3m viztini.github.io
            ;;
        3)
            echo -e "${GREEN}> OPENING EDITOR...${NC}"
            vim
            ;;
        4)
            echo -e "${GREEN}> LAUNCHING VISUAL INTERFACE...${NC}"
            sleep 1
            if [ -f "./gui.sh" ]; then
                ./gui.sh # Assumes gui.sh is still available
            else
                echo -e "${MAGENTA}> ERROR: gui.sh NOT FOUND. CANNOT LAUNCH GUI.${NC}"
            fi
            ;;
        5)
            # Poweroff command
            echo -e "${GREEN}> INITIATING POWEROFF SEQUENCE...${NC}"
            sudo systemctl poweroff
            exit 0 # Should poweroff, but exit just in case
            ;;
        6)
            # Reboot command
            echo -e "${GREEN}> INITIATING REBOOT SEQUENCE...${NC}"
            sudo systemctl reboot
            exit 0 # Should reboot, but exit just in case
            ;;
        *)
            echo -e "${MAGENTA}> INVALID INPUT. RETRYING...${NC}"
            sleep 1
            ;;
    esac
done
