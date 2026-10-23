#!/usr/bin/env fish

# Configure my shell's prompt




# env vars
set -x VISUAL "geany --wait"
set -x EDITOR "micro --wait"



# Helpful expansions
abbr -a -g gp git push
abbr -a -g gc git commit -asm
abbr -a -g gst git status


#dirs
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .c 'cd ~/.config'

abbr df 'df -h'
abbr free 'free -g'
abbr ff 'fastfetch'
abbr ff1 'fastfetch -c config1' 


abbr h 'cd ~/'
abbr c 'clear'

# editors
abbr e 'micro'
abbr v 'nvim'

# listings
abbr ll 'ls -al'
abbr la 'ls -A'
abbr ls. 'ls -A | egrep "^\."'

#grep
abbr grep 'grep --color=auto'
abbr egrep 'egrep --color=auto'
abbr fgrep 'fgrep --color=auto'

# files
abbr cp 'cp -i'
abbr mv 'mv -i'
abbr rm 'rm -i'





abbr reboot 'sudo reboot'
abbr q 'exit'




# Helpful aliases
command -q exa; and alias la="exa -abghl --git --color=automatic"
command -q exa; and alias ll="exa -bghl --git --color=automatic"

# Fisher!
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Make it easy to switch to commonly-used directories
# zoxide init fish | source
starship init fish | source
fzf --fish | source
zoxide init fish | source

