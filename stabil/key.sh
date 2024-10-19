while IFS= read -r ip; do
    ssh-keygen -f "/home/codespace/.ssh/known_hosts" -R "$ip"
done < ips.txt
