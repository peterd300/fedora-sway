#!/usr/bin/bash

sudo dnf install -y wget unzip fontconfig 


set -Eeu 
set -o pipefail

font="IosevkaTerm"
fontdir="$HOME/.local/share/fonts/$font"
# fontdir="$/usr/share/fonts/$font"

logdir="$HOME/log"
log_file="$logdir/${font}.log"

tempdir="$HOME/temp"
zipfile="$tempdir/${font}.zip"

extractdir="$tempdir/$font"
url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.zip"

exec > >(tee -a "$log_file") 2>&1

mkdir -p "$logdir"
mkdir -p "$tempdir"
mkdir -p "$fontdir"

echo "Downloading $font font to: $zipfile"

wget \
    -q \
    -O "$zipfile" \
    "$url"

rm -rf "$extractdir"
mkdir -p "$extractdir"

echo "Extracting fonts..."
unzip -q "$zipfile" -d "$extractdir"

echo "Installing fonts..."
find "$extractdir" -type f \( -iname "*.ttf" -o -iname "*.otf" \) \
    -exec install -m 644 {} "$fontdir/" \;

echo "Refreshing font cache..."
fc-cache -f

echo "Installed fonts:"
fc-list | grep -i $font || true

echo "Installation complete."
echo "Downloaded ZIP: $zipfile"
echo "Log file: $log_file"



