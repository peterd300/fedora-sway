!#/bin/bash

# change standaard tty font to a bigger font
sudo dnf install terminus-fonts-console
sudo sed -i 's/FONT="eurlatgr"/FONT="ter-v20b"/' /etc/vconsole.conf
