#!/usr/bin/env bash

# Install fish shell and some modern linux terminal tools

sudo dnf -y copr enable atim/starship

sudo dnf -y install  fish bat eza fd ripgrep fzf starship fd zoxide


mkdir -p ~/.config/fish/functions

cd ~/fedora-sway/scripts/fish
# cp prompt function to config dir

cp ./fish_prompt.fish ~/.config/fish/functions/.
cp ./ssh.fish ~/.config/fish/functions/.
cp ./config.fish ~/.config/fish/.
cp ./fish_plugins ~/.config/fish/.
cd ..


