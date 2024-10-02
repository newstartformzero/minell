#!/bin/bash

wget -O ips.txt https://raw.githubusercontent.com/DotAja/AUTO-RUNMINER/refs/heads/main/ganti/allip.sh

# Pengaturan variabel
USER="cloudsigma"
OLD_PASSWORD="Cloud2024"
NEW_PASSWORD="12345678"

# Baca IP dari file.txt
while IFS= read -r HOST; do
    echo "Mengubah kata sandi untuk VPS: $HOST"
    
    # Skrip expect untuk mengganti kata sandi
    expect -c "
        clear
        set timeout 10
        spawn ssh $USER@$HOST
        expect {
            \"yes/no\" { send \"yes\r\"; exp_continue }
            \"password:\" { send \"$OLD_PASSWORD\r\" }
        }
        expect \"Your password has expired. You must change your password now and login again!\"
        expect \"(current) UNIX password:\" { send \"$OLD_PASSWORD\r\" }
        expect \"Enter new UNIX password:\" { send \"$NEW_PASSWORD\r\" }
        expect \"Retype new UNIX password:\" { send \"$NEW_PASSWORD\r\" }
        expect eof
    "
    clear
    echo "Kata sandi untuk VPS $HOST telah berhasil diubah."
    sleep 3
done < "ips.txt"
