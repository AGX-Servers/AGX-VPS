#!/bin/bash
sleep 3s;
clear;
sudo apt-get update && sudo apt-get install -y novnc python3-websockify;
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

sleep 2s;
sudo apt update; sudo apt upgrade -y; sudo apt install git wget qemu-system-x86 ovmf -y ; clear; wget -O win.vhd https://software-download.microsoft.com/download/pr/20348.169.amd64fre.fe_release_svc_refresh.210806-2348_server_serverdatacentereval_en-us.vhd;
qemu-img convert -f vpc -O qcow2 win.vhd win.qcow2;
qemu-img resize win.qcow2 400G;
clear;
sleep 2s;
echo "Server Started Successfully (^_*) ";
qemu-system-x86_64 \
  -m 10G \
  -hda win.vhd \
  -smp 4 \
  -enable-kvm \
  -cpu host \
  -vga std \
  -display vnc=:1 \
  -boot c \
  -net nic \
  -net user &
