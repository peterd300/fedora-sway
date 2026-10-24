# Basic installation with the Everything ISO

# but after reboot no WLAN interface available

# connect laptop via LAN interface 

# add install :

sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf copr enable alebastr/sway-extras # for swww

sudo dnf -y upgrade --refresh

sudo dnf install iwlwifi-mvm-firmware
sudo dnf install fwupd power-profiles-daemon bluez NetworkManager-wifi
sudo systemctl enable --now bluetooth

sudo fwupdmgr refresh && sudo fwupdmgr get-updates
 
#load wifi modufles 
sudo modprobe -r iwlwifi
# restart NetworkManager
sudo systemctl restart NetworkManager

# show wireless interfaces
nmcli radio
sudo nmcli radio wifi on
rfkill list
nmcli device

nmcli device wifi list
nmcli device wifi connect "<SSID>" --ask
nmcli connection show
ping -c3 fedoraproject.org

