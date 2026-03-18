#!/bin/bash

# ألوان
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# لودينق سبينر
spinner() {
    local pid=$!
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${YELLOW}[${spin:$i:1}] Loading...${NC}"
        sleep .1
    done
    printf "\r${GREEN}[✓] Done!           ${NC}\n"
}

# دالة التحقق
check_crd() {
    if dpkg -l | grep -q chrome-remote-desktop; then
        echo -e "${GREEN}[+] CRD already installed${NC}"
        return 0
    else
        echo -e "${RED}[-] CRD not found${NC}"
        return 1
    fi
}

check_chrome() {
    if command -v google-chrome >/dev/null 2>&1; then
        echo "[+] Google Chrome is installed"
        return 0
    else
        echo "[-] Google Chrome not found"
        return 1
    fi
}

echo -e "${YELLOW}=== AGX CRD AUTO SETUP ===${NC}"

read -p "Enter CRD Code: " GX

# تحقق من CRD
check_crd

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}[*] Installing dependencies...${NC}"
    (sudo apt update && sudo apt install wget dbus-x11 xfce4 -y) & spinner

    echo -e "${YELLOW}[*] Downloading CRD...${NC}"
    (wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -P /tmp) & spinner

    echo -e "${YELLOW}[*] Installing CRD...${NC}"
    (sudo apt install -y /tmp/chrome-remote-desktop_current_amd64.deb) & spinner
fi

check_chrome

if [ $? -ne 0 ]; then
    echo "[*] Installing Google Chrome..."

    (
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp &&
        sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb
    ) & spinner

    echo "[✓] Chrome Installed"
fi

# تنظيف
echo -e "${YELLOW}[*] Cleaning old sessions...${NC}"
(rm -rf ~/.config/chrome-remote-desktop) & spinner

# إعداد XFCE
echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > ~/.chrome-remote-desktop-session

# تشغيل CRD
echo -e "${YELLOW}[*] Starting CRD...${NC}"
echo ""
if [ ! -d "$HOME/.config/chrome-remote-desktop" ]; then
    echo "[*] First time setup..."
    eval "$GX"
else
    echo "[+] Already configured, starting directly..."
    /opt/google/chrome-remote-desktop/chrome-remote-desktop --start
fi

# تشغيل الخدمة
echo -e "${YELLOW}[*] Launching server...${NC}"
(/opt/google/chrome-remote-desktop/chrome-remote-desktop --start) & spinner

echo -e "${GREEN}[✓] CRD READY - ENJOY 💀${NC}"