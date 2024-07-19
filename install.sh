#!/bin/bash

# Atualizar programas
dnf upgrade

# RPM Fusion
dnf install -y\
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

dnf install -y\
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Snap
dnf install -y snapd

# Google Chrome
dnf config-manager --set-enabled google-chrome
dnf install google-chrome-stable

# Bitwarden
flatpak install -y flathub com.bitwarden.desktop

# VLC
flatpak install -y flathub org.videolan.VLC

# Spotify
flatpak install -y flathub com.spotify.Client

# OBS Studio
flatpak install -y flathub com.obsproject.Studio

# Audacity
flatpak install -y flathub org.audacityteam.Audacity

# Kdenlive
flatpak install -y flathub org.kde.kdenlive

# Discord
flatpak install -y flathub com.discordapp.Discord

# qBittorrent
flatpak install -y flathub org.qbittorrent.qBittorrent

# Thunderbird
flatpak install -y flathub org.mozilla.Thunderbird

# Install Jetbrains Toolbox
wget -P ./downloads https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.4.0.32175.tar.gz
tar -xf ./downloads/jetbrains-toolbox-2.4.0.32175.tar.gz
./jetbrains-toolbox-2.4.0.32175.tar.gz/jetbrains-toolbox

# Python
dnf install -y python3-pip
dnf install -y pipx
pipx ensurepath

# PHP
dnf install -y https://rpms.remirepo.net/fedora/remi-release-40.rpm
dnf module reset php
dnf module install -y php:remi-8.3
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# Javascript
dnf install -y nodejs npm

# Postman
tar -C /tmp/ -xzf <(curl -L https://dl.pstmn.io/download/latest/linux64) && sudo mv /tmp/Postman /opt/

tee -a /usr/share/applications/postman.desktop << END
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
END

# Filezilla
flatpak install -y flathub org.filezillaproject.Filezilla

# Nerd Fonts
git clone https://github.com/ryanoasis/nerd-fonts.git ./downloads/nerd-fonts

./downloads/nerd-fonts/install.sh JetBrainsMono
./downloads/nerd-fonts/install.sh FiraMono


# Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten /usr/local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
git clone https://github.com/DinkDonk/kitty-icon.git ./downloads/kitty-icon
mv ./downloads/kitty-icon/kitty-light.png ~/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
touch ~/.config/kitty/kitty.conf

"""
font_family		  JetBrainsMono Nerd Font
font_size		  12.0
disable_ligatures	  never
modify_font		  cell_height 0.3px

cursor			  #eabfff
cursor_shape		  beam
cursor_beam_thickness	  2

window_border_width	  0.5pt
window_padding_width	  20
confirm_os_window_close   0

selection_background	  #eedff9
selection_foreground	  #191824

editor			  nano
term 			  xterm-kitty
linux_display_server	  x11
enabled_layouts 	  tall

kitty_mod ctrl+shift

map kitty_mod+enter	  new_window
map kitty_mod+n		  new_os_window	
map kitty_mod+backspace	  close_window

map kitty_mod+left 	  neighboring_window left
map kitty_mod+right 	  neighboring_window right
map kitty_mod+up 	  neighboring_window up
map kitty_mod+down 	  neighboring_window down


map --new-mode manage_window kitty_mod+m

map --mode manage_window up 	neighboring_window up
map --mode manage_window left 	neighboring_window left
map --mode manage_window right 	neighboring_window right
map --mode manage_window down 	neighboring_window down

map --mode manage_window shift+up move_window up
map --mode manage_window shift+left move_window left
map --mode manage_window shift+right move_window right
map --mode manage_window shift+down move_window down

map --mode manage_window esc pop_keyboard_mode
""" > ~/.config/kitty/kitty.conf

# Zsh
dnf install zsh
chsh -s $(which zsh)

# Antigen
curl -L git.io/antigen > ~/antigen.zsh

# Plugins e temas
"""
source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply
""" > ~/.zshrc

# Migrar as chaves SSH

# Configurar SSH Keys
eval "$(ssh-agent -s)"
chmod 700 ~/.ssh
chmod -R 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

for file in $(find ~/.ssh/* ! \( -name "*.pub" -o -name "config" -o -name "known_hosts*" \))
do
	ssh-add "~/.ssh/$file"
done
