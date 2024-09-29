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

# Script yang ingin dijalankan di setiap VPS
ASIA_SCRIPT_COMMAND="pkill screen 
wget -q -O run https://raw.githubusercontent.com/DotAja/AUTO-RUNMINER/refs/heads/main/asia.sh
sh run"
EUROPE_SCRIPT_COMMAND="pkill screen
wget -q -O run https://raw.githubusercontent.com/DotAja/AUTO-RUNMINER/refs/heads/main/eropa.sh
sh run"

# Fungsi untuk menjalankan script di satu VPS
run_script() {
    local IP=$1
    local USER="cloudsigma"         # Menetapkan USER
    local PASSWORD="12345678"   # Menetapkan PASSWORD
    local COMMAND=$2            # Perintah yang akan dijalankan

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

# Membaca daftar VPS Asia dan menjalankan script
while IFS=',' read -r IP; do
    run_script "$IP" "$ASIA_SCRIPT_COMMAND" &  # Jalankan perintah untuk VPS Asia
done < $ASIA_VPS_LIST

# Membaca daftar VPS Eropa dan menjalankan script
while IFS=',' read -r IP; do
    run_script "$IP" "$EUROPE_SCRIPT_COMMAND" &  # Jalankan perintah untuk VPS Eropa
done < $EUROPE_VPS_LIST

# Tunggu semua proses selesai
wait

clear
echo "Selesai menjalankan script di semua VPS."
