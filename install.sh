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

# improve download performance
sudo nano /etc/dnf/dnf.conf
````bash
max_parallel_downloads=10
fastestmirror=True
````

# disable enoying beep in terminal

sudo sed -i 's/^#\s*set bell-style none/set bell-style none/' /etc/inputrc


# install cli utils
sudo dnf -y install tree htop btop make bat git wget unzip nano cmake curl gcc net-tools fastfetch trash-cli micro

# install sway tiling wm
sudo dnf -y install sway swaybg foot rofi-wayland waybar wl-clipboard


sudo dnf -y install xdg-desktop-portal-gtk xdg-utils 

sudo dnf -y install lxqt-policykit
# exec-once = /usr/libexec/lxqt-policykit-agent

sudo dnf -y install pavucontrol pasystray


# install some grapical progs
sudo dnf -y install kitty foot firefox copyq

# install file manager
sudo dnf install -y thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin thunar-volman thunar

# install gui editor
sudo dnf install -y geany geany-themes geany-plugins-vimode  geany-plugins-common \
geany-plugins-addons geany-plugins-autoclose geany-plugins-automark geany-plugins-markdown \
geany-plugins-git-changebar geany-plugins-treebrowser


sudo dnf -y install NetworkManager-tui blueman network-manager-applet brightnessctl pipewire-utils wireplumber

sudo dnf -y install swww matugen
