# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

export QT_QPA_PLATFORMTHEME=qt5ct   # For Qt5 apps
export QT_QPA_PLATFORMTHEME=qt6ct   # For Qt6 apps (or run qt6ct depending on the app version)
