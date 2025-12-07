#!/bin/bash

GREEN='\033[1;32m'
MAGENTA='\033[1;35m'
NC='\033[0m'

function type_line() {
    local line_text="$1"
    local sleep_duration="${2:-1}"
    local typing_speed=0.04 
    local dot_delay=0.3    

    echo -ne "${GREEN}" 

    if [[ "$line_text" == *... ]]; then
        local prefix="${line_text%...}" 
        for (( i=0; i<${#prefix}; i++ )); do
            echo -n "${prefix:$i:1}"
            sleep $typing_speed
        done
        for (( i=1; i<=3; i++ )); do
            echo -n "."
            sleep $dot_delay 
        done
        echo 
    else
        for (( i=0; i<${#line_text}; i++ )); do
            echo -n "${line_text:$i:1}"
            sleep $typing_speed
        done
        echo 
    fi

    sleep "$sleep_duration"
}

function print_menu_block() {
    local MENU_WIDTH=42
    local COLS=$(tput cols)
    local PADDING=$(( (COLS - MENU_WIDTH) / 2 ))

    local RAW_MENU=(
        "========================================"
        "       AVAILABLE PROTOCOLS"
        "========================================"
        "[1] > BROWSE THE WEB (W3M)"
        "[2] > CODE (VIM)"
        "[3] > START GRAPHICAL INTERFACE (GUI)"
        "[4] > SHUTDOWN (POWEROFF)"
        "[5] > RESTART (REBOOT)"
        "[6] > CONTINUE TO TERMINAL INTERFACE (TUI)"
        "========================================"
    )

    local COLORS=(
        "${MAGENTA}%s${NC}"
        "${MAGENTA}       ${GREEN}%s${MAGENTA}${NC}"
        "${MAGENTA}%s${NC}"
        "${MAGENTA}[1] ${GREEN}> BROWSE THE WEB ${MAGENTA}(W3M)${NC}"
        "${MAGENTA}[2] ${GREEN}> CODE ${MAGENTA}(VIM)${NC}"
        "${MAGENTA}[3] ${GREEN}> START GRAPHICAL INTERFACE ${MAGENTA}(GUI)${NC}"
        "${MAGENTA}[4] ${GREEN}> SHUTDOWN ${MAGENTA}(POWEROFF)${NC}"
        "${MAGENTA}[5] ${GREEN}> RESTART ${MAGENTA}(REBOOT)${NC}"
        "${MAGENTA}[6] ${GREEN}> CONTINUE TO TERMINAL INTERFACE ${MAGENTA}(TUI)${NC}"
    )

    for i in "${!RAW_MENU[@]}"; do
        printf "%*s" $PADDING ""
        if (( i < 3 )); then
            printf "${COLORS[i]}\n" "${RAW_MENU[i]}"
        else
            echo -e "${COLORS[i]}"
        fi
    done
}

clear

if command -v genact &> /dev/null; then
    timeout 5s genact -m bootlog
    clear
else
    echo -e "${MAGENTA}> GENACT NOT FOUND. SKIPPING SIMULATION...${NC}"
    sleep 1
    clear
fi

type_line "> BOOT INITIALIZED" 1

echo -e "${MAGENTA}"
if command -v neofetch &> /dev/null; then
    neofetch
else
    echo "> Neofetch not found."
fi
sleep 3

type_line "> SYSTEM BOOT..." 1
type_line "> LOADING PROTOCOLS..." 1
type_line "> CONNECTING TO THE WIRED..." 1
type_line "> CONNECTION ESTABLISHED" 1
type_line "> WELCOME, $USER" 1

while true; do
    clear 
    echo -e "${NC}" 
    print_menu_block

    ROWS=$(tput lines)
    TARGET_ROW=$(( ROWS - 6))
    tput cup $TARGET_ROW 0
    echo -ne "${GREEN}> SELECT OPTION >> ${MAGENTA}"
    read choice
    tput cuu 1

    case $choice in
        1)
            echo -e "${GREEN}> INITIALIZING BROWSER...${NC}"
            w3m viztini.github.io
            clear
            ;;
        2)
            echo -e "${GREEN}> OPENING EDITOR...${NC}"
            vim
            clear
            ;;
        3)
            echo -e "${GREEN}> LAUNCHING VISUAL INTERFACE...${NC}"
            sleep 1
            if [ -f "./gui.sh" ]; then
                ./gui.sh
            else
                echo -e "${MAGENTA}> ERROR: gui.sh NOT FOUND. CANNOT LAUNCH GUI.${NC}"
            fi
            ;;
        4)
            echo -e "${GREEN}> INITIATING POWEROFF SEQUENCE...${NC}"
            sudo systemctl poweroff
            exit 0
            ;;
        5)
            echo -e "${GREEN}> INITIATING REBOOT SEQUENCE...${NC}"
            sudo systemctl reboot
            exit 0
            ;;
        6)
            clear
            if command -v neofetch &> /dev/null; then
                neofetch
            else
                echo -e "${MAGENTA}> Neofetch not found.${NC}"
            fi
            exec $SHELL
            ;;
        *)
            echo -e "${MAGENTA}> INVALID INPUT. RETRYING...${NC}"
            sleep 1
            ;;
    esac
done
