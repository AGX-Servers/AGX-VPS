#!/bin/bash

CONFIG="$HOME/.agx_config"

# =========================
# 🎨 Banner
# =========================
banner() {
clear
echo -e "\e[1;36m"
echo "======================================"
echo "      🔥 AGX ACADEMY - SSH TOOL"
echo "======================================"
echo "   GitHub  : https://github.com/AGX-Academy"
echo "   Telegram : https://t.me/Developer_GX"
echo "   WhatsApp : https://wa.me/+994402309201"
echo "======================================"
echo -e "\e[0m"
}

# =========================
# ⏳ Spinner
# =========================
spinner() {
    local pid=$!
    local delay=0.1
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while kill -0 $pid 2>/dev/null; do
        for i in $(seq 0 9); do
            echo -ne "\r${spin:$i:1} $1"
            sleep $delay
        done
    done
    echo -ne "\r"
}

# =========================
# 🚀 First Run Setup
# =========================
if [ ! -f "$CONFIG" ]; then
    banner
    echo "🔧 First time setup..."
    read -p "Enter NGROK TOKEN: " TOKEN
    echo "TOKEN=$TOKEN" > $CONFIG
    chmod 600 $CONFIG
    echo "✅ Saved! Restart tool..."
    exit
fi

source $CONFIG

banner
echo "🚀 Starting AGX Engine..."

sleep 1

# =========================
# 📦 Install deps
# =========================
(
sudo apt update -y > /dev/null 2>&1
sudo apt install -y openssh-server curl jq > /dev/null 2>&1
) & spinner "Installing dependencies..."

# =========================
# 🔐 SSH Setup
# =========================
(
echo "root:root" | sudo chpasswd
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo service ssh restart > /dev/null 2>&1
) & spinner "Configuring SSH..."

# =========================
# 📡 Install ngrok
# =========================
if ! command -v ngrok &> /dev/null; then
(
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update -y > /dev/null 2>&1
sudo apt install ngrok -y > /dev/null 2>&1
) & spinner "Installing ngrok..."
fi

ngrok config add-authtoken $TOKEN > /dev/null 2>&1

# =========================
# 🌐 Start tunnel
# =========================
nohup ngrok tcp 22 > /dev/null 2>&1 &
sleep 5

curl -s http://127.0.0.1:4040/api/tunnels > tunnels.json

HOST=$(jq -r '.tunnels[0].public_url' tunnels.json | sed 's/tcp:\/\///')
IP=$(echo $HOST | cut -d: -f1)
PORT=$(echo $HOST | cut -d: -f2)

# =========================
# 🎯 Output
# =========================
banner

echo "🔥 SSH READY"
echo "--------------------------------------"
echo "🌐 Host     : $IP"
echo "🔌 Port     : $PORT"
echo "👤 User     : root"
echo "🔑 Pass     : root"
echo "--------------------------------------"
echo "💻 Connect:"
echo "ssh root@$IP -p $PORT"
echo "======================================"