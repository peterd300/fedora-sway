# Basic installation with the Everything ISO

# but after reboot no WLAN interface available

# connect laptop via LAN interface 

# add install :



sudo dnf -y upgrade --refresh
sudo dnf update

#install wifi firmware and drivres
sudo dnf install linux-firmware iwlwifi-mvm-firmware NetworkManager-wifi

# enable bluethooth
sudo dnf install power-profiles-daemon bluez 
sudo systemctl enable --now bluetooth

#sudo dnf install fwupd 
#sudo fwupdmgr refresh && sudo fwupdmgr get-updates


#Unload the crashed driver
sudo modprobe -r iwlwifi

# Reload the driver into the kernel
sudo modprobe iwlwifi
lsmod |grep -i iwlwifi

sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager

# Restart NetworkManager right after
sudo systemctl restart NetworkManager

lspci | grep -i network

# show wireless interfaces
sudo nmcli radio
sudo nmcli radio wifi on
rfkill list
nmcli device

nmcli device wifi list
nmcli device wifi connect "<SSID>" --ask
nmcli connection show
ping -c3 fedoraproject.org

