#!/usr/bin/env bash
set -Eeu 
set -o pipefail

logdir="$HOME/log"
log_file="$logdir/smb-client.log"


exec > >(tee -a "$log_file") 2>&1


[ -d "$logdir" ] && mkdir -p $logdir


sudo dnf install -y gnome-keyring smbclient cifs-utils gvfs-smb


NEW_LINES=$(cat << 'EOF'
auth    optional    pam_gnome_keyring.so
session optional    pam_gnome_keyring.so auto_start
EOF
)

# Append the lines safely using sudo and tee
echo "$NEW_LINES" | sudo tee -a /etc/pam.d/login > /dev/null

echo "PAM configuration updated successfully."
