
!/bin/bash
#  Install script for Wayland anD Sway  Tiling Windows Manager
#  
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
# sudo dnf -y copr enable alebastr/sway-extras # for swww

sudo dnf -y upgrade --refresh

# improve download performance
#sudo nano /etc/dnf/dnf.conf
#````bash
#max_parallel_downloads=10
#fastestmirror=True
#````

# disable enoying beep in terminal

sudo sed -i 's/^#\s*set bell-style none/set bell-style none/' /etc/inputrc
sleep 3

# install cli utils
sudo dnf -y install tree htop btop make bat git wget unzip nano cmake curl gcc net-tools fastfetch trash-cli micro vim

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

# icons themes
sudo dnf install -y papirus-icon-theme


sudo dnf -y install NetworkManager-tui blueman network-manager-applet brightnessctl pipewire-utils wireplumber

sudo dnf -y install mako 

# Install pipx and ImageMagick 
sudo dnf -y install pipx ImageMagick
sleep 3
# Install pywal16:bash
pipx install pywal16
pipx ensurepath
sleep 3

# install several fonts
$HOME/fedora-sway/scripts/install-font-iosevka.sh
$HOME/fedora-sway/scripts/install-font-iosevkaterm.sh
$HOME/fedora-sway/scripts/install-font-jetbrainsnerd-mono.sh
$HOME/fedora-sway/scripts/install-ttyfont.sh

# install SAMBA Client
$HOME/fedora-sway/scripts/install-smbclient.sh

# install fish shell
$HOME/fedora-sway/scripts/fish/install.sh

# copy wallpapers
cp -Rv $HOME/fedora-sway/Wallpapers $HOME/.







