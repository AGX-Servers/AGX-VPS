#!/bin/bash
sleep 3s
clear;
sleep 2s
sudo apt update; sudo apt upgrade -y; sudo apt install git wget qemu-system-x86 ovmf -y ; clear; wget -O win.vhd https://software-download.microsoft.com/download/pr/20348.169.amd64fre.fe_release_svc_refresh.210806-2348_server_serverdatacentereval_en-us.vhd;
clear;
qemu-system-x86_64 \
  -m 10G \
  -hda win.vhd \
  -smp 4 \
  -enable-kvm \
  -cpu host \
  -vga std \
  -display vnc=:1 \
  -boot c \
  -net nic -net user
