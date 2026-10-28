#/usr/bin/env bash

# info : https://github.com/ful1e5/Bibata_Cursor/releases#release-v2.0.7
# https://github.com/ful1e5/Bibata_Cursor


latest_version=v2.0.7

mkdir -p ~/.local/share/icons

wget https://github.com/ful1e5/Bibata_Cursor/releases/download/$latest_version/Bibata-Modern-Classic.tar.xz
wget https://github.com/ful1e5/Bibata_Cursor/releases/download/$latest_version/Bibata-Modern-Ice-Right.tar.xz

# extract file with sleep , otherwise errors
tar -xvf Bibata-Modern-Classic.tar.xz
sleep 2                # extract `Bibata.tar.gz`
tar -xvf Bibata-Modern-Ice-Right.tar.xz
sleep 2


# move files to local share
mv Bibata-Modern-Classic/ ~/.local/share/icons/
mv Bibata-Modern-Ice-Right/ ~/.local/share/icons/   # Install to local users

# activate cursor for X11 
echo "Xcursor.theme: Bibata-Modern-Classic" >> ~/.Xresources

rm -rf ./Bibata-Modern-*
rm -rf ./Bibata-Modern-*.tar.xz
