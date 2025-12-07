#!/bin/bash

GREEN='\033[1;32m'
MAGENTA='\033[1;35m'
NC='\033[0m'

function find_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo "none"
    fi
}

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

function show_system_status() {
    echo -e "${MAGENTA}> INITIATING SYSTEM DIAGNOSTICS...${NC}"
    echo -e "${MAGENTA}========================================"
    echo -e "${GREEN}> UPTIME:${NC} $(uptime | awk -F'( |,|:)+' '{print $6,$7}')"
    echo -e "${GREEN}> MEMORY USAGE:${NC}"
    free -h | awk 'NR==2{print "\tTotal: "$2," Used: "$3," Free: "$4}'
    echo -e "${GREEN}> DISK SPACE:${NC}"
    df -h / | awk 'NR==2{print "\tTotal: "$2," Used: "$3," Avail: "$4}'
    echo -e "${GREEN}> RUNNING PROCESSES:${NC} $(ps -e | wc -l)"
    echo -e "${MAGENTA}========================================"
    echo -e "${GREEN}> PRESS ANY KEY TO RETURN TO MENU...${NC}"
    read -n 1
}

function package_menu() {
    local pkg_mgr=$(find_package_manager)
    
    if [ "$pkg_mgr" == "none" ]; then
        echo -e "${MAGENTA}> ERROR: NO SUPPORTED PACKAGE MANAGER FOUND!${NC}"
        sleep 2
        return
    fi
    
    while true; do
        clear 
        echo -e "${MAGENTA}========================================"
        echo -e "       ${GREEN}PACKAGE MANAGER (${pkg_mgr})${MAGENTA}"
        echo -e "========================================"
        echo -e "${MAGENTA}[1] ${GREEN}> FULL SYSTEM UPDATE"
        echo -e "${MAGENTA}[2] ${GREEN}> INSTALL PACKAGE"
        echo -e "${MAGENTA}[0] ${GREEN}> BACK TO MAIN MENU"
        echo -e "${MAGENTA}========================================"
        echo -ne "${GREEN}> PACKAGE OPTION >> ${MAGENTA}"
        read pkg_choice

        case $pkg_choice in
            1)
                echo -e "${GREEN}> STARTING FULL SYSTEM UPDATE. PASSWORD REQUIRED.${NC}"
                case $pkg_mgr in
                    apt) sudo apt update && sudo apt upgrade -y ;;
                    dnf) sudo dnf upgrade -y ;;
                    pacman) sudo pacman -Syu --noconfirm ;;
                esac
                echo -e "${GREEN}> UPDATE COMPLETE. PRESS ANY KEY...${NC}"
                read -n 1
                ;;
            2)
                echo -ne "${GREEN}> PACKAGE NAME TO INSTALL: ${MAGENTA}"
                read package_name
                if [ -z "$package_name" ]; then continue; fi
                
                echo -e "${GREEN}> INSTALLING $package_name. PASSWORD REQUIRED.${NC}"
                case $pkg_mgr in
                    apt) sudo apt install "$package_name" -y ;;
                    dnf) sudo dnf install "$package_name" -y ;;
                    pacman) sudo pacman -S "$package_name" --noconfirm ;;
                esac
                echo -e "${GREEN}> INSTALLATION COMPLETE. PRESS ANY KEY...${NC}"
                read -n 1
                ;;
            0)
                break
                ;;
            *)
                echo -e "${MAGENTA}> INVALID OPTION.${NC}"
                sleep 1
                ;;
        esac
    done
    clear
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
    echo -e "${NC}" 
    echo -e "${MAGENTA}========================================"
    echo -e "       ${GREEN}AVAILABLE PROTOCOLS${MAGENTA}"
    echo -e "========================================"
    echo -e "${MAGENTA}[1] ${GREEN}> BROWSE THE WEB ${MAGENTA}(W3M)"
    echo -e "${MAGENTA}[2] ${GREEN}> CODE ${MAGENTA}(VIM)"
    echo -e "${MAGENTA}[3] ${GREEN}> START GRAPHICAL INTERFACE ${MAGENTA}(GUI)"
    echo -e "${MAGENTA}[4] ${GREEN}> SHUTDOWN ${MAGENTA}(POWEROFF)"
    echo -e "${MAGENTA}[5] ${GREEN}> RESTART ${MAGENTA}(REBOOT)"
    echo -e "${MAGENTA}[6] ${GREEN}> SYSTEM STATUS ${MAGENTA}(INFO)"
    echo -e "${MAGENTA}[7] ${GREEN}> PACKAGE MANAGER ${MAGENTA}(PKG)"
    echo -e "${MAGENTA}========================================"
    
    echo -ne "${GREEN}> SELECT OPTION >> ${MAGENTA}"
    read choice

    case $choice in
        1)
            echo -e "${GREEN}> INITIALIZING BROWSER...${NC}"
            w3m viztini.github.io
            ;;
        2)
            echo -e "${GREEN}> OPENING EDITOR...${NC}"
            vim
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
            show_system_status
            ;;
        7)
            package_menu
            ;;
        *)
            echo -e "${MAGENTA}> INVALID INPUT. RETRYING...${NC}"
            sleep 1
            ;;
    esac
done
