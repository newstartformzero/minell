#!/bin/bash

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
    expect "*$*"  # Prompt yang menandakan login berhasil (misalnya root prompt)
    send "$COMMAND\r"
    expect "*$*"  # Tunggu sampai perintah selesai
    send "exit\r"
    expect eof
EOF
}

COUNT=1
# Membaca daftar VPS Asia dan menjalankan script
while IFS=',' read -r IP; do
    ASIA_SCRIPT_COMMAND="screen -dmS apdot bash -c 'bash <(wget -qO- https://bit.ly/ap-dot)'"
    run_script "$IP" "$ASIA_SCRIPT_COMMAND" &  # Jalankan perintah untuk VPS Asia
    COUNT=$((COUNT + 1))
done < "ips.txt"

# Tunggu semua proses selesai
wait

clear
echo "Selesai menjalankan script di semua VPS."