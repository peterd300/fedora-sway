
!/bin/bash
#  Install script for Wayland anD Sway  Tiling Windows Manager
#  
sudo dnf update --refresh

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
sudo dnf -y install sway swaybg rofi-wayland waybar wl-clipboard wofi

sudo dnf -y install xdg-desktop-portal-gtk xdg-utils 

sudo dnf -y install lxqt-policykit
# exec-once = /usr/libexec/lxqt-policykit-agent

sudo dnf -y install pavucontrol pasystray


# install some grapical progs
sudo dnf -y install kitty foot firefox copyq xev swayimg imv

# install file manager
sudo dnf install -y thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin thunar-volman thunar

# install gui editor
sudo dnf install -y geany geany-themes geany-plugins-vimode  geany-plugins-common \
geany-plugins-addons geany-plugins-autoclose geany-plugins-automark geany-plugins-markdown \
geany-plugins-git-changebar geany-plugins-treebrowser


sudo dnf -y install NetworkManager-tui blueman network-manager-applet brightnessctl pipewire-utils wireplumber

sudo dnf -y install swww mako 
