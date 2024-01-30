#!/bin/bash

setup_reflector(){
    sudo systemctl enable reflector.service reflector.timer
    sudo systemctl start reflector.service reflector.timer
}

install_deps(){
sudo pacman -S --needed --noconfirm \
    curl \
    stow \
    zsh-autosuggestions \
    zsh\
    alacritty \
    bluez bluez-utils \
    dunst \
    kitty \
    neovim \
    nitrogen \
    unclutter \
    picom \
    tlp \
    rofi \
    playerctl \
    alsa-utils alsa-plugins alsa-firmware sof-firmware alsa-ucm-conf alsa-lib \
    pipewire-alsa pipewire-pulse easyeffects qpwgraph \
    reflector # for auto updation of mirrorlist
}

setup_grub(){
    CLONE_DIRECTORY=$HOME/.config/grub2

    git clone https://github.com/vinceliuice/grub2-themes.git $CLONE_DIRECTORY
    CLONE_STATUS=$?

    pushd $CLONE_DIRECTORY
    sudo $CLONE_DIRECTORY/install.sh -b -t vimix -i color -s 1080p

    if [ $CLONE_STATUS ]; then
        rm -rf $CLONE_DIRECTORY 
    fi

    popd
}

setup_pacman_hooks(){
    FILE_LIST=("pacman/hooks/aurList.hook" "pacman/hooks/pkglist.hook" "pacman/hooks/orphans.hook")
    hooks_dir=/etc/pacman.d/hooks/

    if [ -d "$hooks_dir" ]; then
        :
    else
        sudo mkdir "$hooks_dir"
    fi

    for file in "${FILE_LIST[@]}"; do
        filename=$(basename $file)
        sudo ln -sr $file /etc/pacman.d/hooks/$filename
    done
}

activate_bluetooth(){
    modprobe btusb
    systemctl enable --now bluetooth
    systemctl --user enable pipewire-pulse
}

# OhMyZsh
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Rofi setup
install_rofi(){
    rofiFolder=rofiGitFolder
    installDir=$HOME/.config/rofi

    git clone https://github.com/adi1090x/rofi.git $rofiFolder
    pushd $rofiFolder
    ./setup.sh
    popd
    rm -rf $rofiFolder
}

install_official_packages(){
    sudo pacman -S --needed --noconfirm - < pacman/pkgList.txt
}


main(){
    #setup_reflector # Look into etckeeper for reflector and other files in etc 
    
    install_deps
    install_official_packages

    install_rofi
    setup_pacman_hooks
    activate_bluetooth
    setup_grub
}

./setup_username.bash
main
