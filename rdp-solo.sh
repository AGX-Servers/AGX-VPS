#!/bin/bash
############################################################################
# Author:  Anonymous GX
# Virsion: 1.0
# Date:    2026-03-21
# Description: RDP Solo Script for Decian Linux setup Proot & Debian
############################################################################


mkdir -p ~/debian-trixie;
cd ~/debian-trixie;

# Download the Debian image

wget https://github.com/termux/proot-distro/releases/download/v4.26.0/debian-trixie-x86_64-pd-v4.26.0.tar.xz;

# Extract the image

tar -xf debian-trixie-x86_64-pd-v4.26.0.tar.xz;

# Install proot static binary

wget https://github.com/AGX-Servers/AGX-VPS/raw/refs/heads/main/proot;

chmod +x proot

# Lunch Debian Linux FS Environment

./proot -S /debian-trixie-x86_64-pd-v4.26.0 /bin/bash