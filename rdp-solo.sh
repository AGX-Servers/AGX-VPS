#!/bin/bash
############################################################################
# Author:  Anonymous GX
# Virsion: 1.0
# Date:    2026-03-21
# Description: RDP Solo Script for Decian Linux setup Proot & Debian
############################################################################

echo "Starting RDP Solo Script for Debian Linux setup Proot & Debian...";

mkdir -p ~/.debian-trixie > /dev/null 2>&1;
cd ~/.debian-trixie > /dev/null 2>&1;
mkdir -p ~/bin > /dev/null 2>&1;
export PATH="$HOME/bin:$PATH" > /dev/null 2>&1;
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc > /dev/null 2>&1;
source ~/.bashrc > /dev/null 2>&1;

# Download the Debian image

wget https://github.com/termux/proot-distro/releases/download/v4.26.0/debian-trixie-x86_64-pd-v4.26.0.tar.xz > /dev/null 2>&1;


# Extract the image

tar -xvf debian-trixie-x86_64-pd-v4.26.0.tar.xz > /dev/null 2>&1;

# Install proot static binary

wget https://github.com/AGX-Servers/AGX-VPS/raw/refs/heads/main/proot > /dev/null 2>&1;

chmod +x proot;

echo "~/.debian-trixie/proot -S ~/.debian-trixie/debian-trixie-x86_64 /bin/bash"  > ~/bin/agx-root-start;
chmod +x ~/bin/agx-root-start;

# Lunch Debian Linux FS Environment

echo "Launching Debian Linux FS Environment...";

agx-root-start;

echo "Debian Linux FS Environment launched."