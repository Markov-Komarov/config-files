#!/bin/sh

SRCDIR="$HOME/src"
# Ensure the target directory exists
if [ ! -d "$SRCDIR" ]; then
# Create the directory if it does not exist
  mkdir -p "$SRCDIR"
  echo "Directory '$SRCDIR' created."
else
  echo "Directory '$SRCDIR' already exists."
fi

# Function to install dependencies for Debian-based distributions
#install_debian() {
    #sudo apt update
    #sudo apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev cmake libxft-dev libimlib2-dev libxinerama-dev libxcb-res0-dev xorg-xev xorg-xbacklight alsa-utils
#}

# Function to install dependencies for Red Hat-based distributions
#install_redhat() {
    #sudo yum groupinstall -y "Development Tools"
    #sudo yum install -y dbus-devel gcc git libconfig-devel libdrm-devel libev-devel libX11-devel libX11-xcb libXext-devel libxcb-devel libGL-devel libEGL-devel libepoxy-devel meson ninja-build pcre2-devel pixman-devel uthash-devel xcb-util-image-devel xcb-util-renderutil-devel xorg-x11-proto-devel xcb-util-devel cmake libxft-devel libimlib2-devel libxinerama-devel libxcb-res0-devel xorg-xev xorg-xbacklight alsa-utils
#}
install_arch() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm --needed base-devel libx11 libxinerama libxft imlib2 git dash shotgun hacksaw picom feh helix fastfetch alacritty mpv pulsemixer xorg-server xorg-xinit zoxide eza starship pcmanfm-gtk3
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
#        debian|ubuntu)
#            echo "Detected Debian-based distribution"
#            install_debian
#            ;;
#        rhel|centos|fedora)
#            echo "Detected Red Hat-based distribution"
#            install_redhat
#            ;;
        arch|cachyos)
            echo "Detected Arch-based distribution"
            install_arch
            ;;
        *)
            echo "Unsupported distribution"
            exit 1
            ;;
    esac
else
    echo "/etc/os-release not found. Unsupported distribution"
    exit 1
fi

clone_mkdwm() {
    # Clone the repository in the home/src directory
    if [ ! -d $SRCDIR/mk-dwm ]; then
        if ! git clone https://github.com/Markov-Komarov/mk-dwm.git $SRCDIR/mk-dwm; then
            echo "Failed to clone the repository"
            return 1
        fi
    else
        echo "Repository already exists, skipping clone"
    fi

    cd $SRCDIR/mk-dwm || { echo "Failed to change directory to mk-dwm"; return 1; }

    # Build the project
    if ! make -s clean; then
        echo "Make cleanup failed"
        return 1
    fi

    # Install the built binary
    if ! sudo make -s clean install; then
        echo "Failed to install the built binary"
        return 1
    fi

    echo "mk-dwm installed successfully"
}

clone_mkblocks() {
    # Clone the repository in the home/src directory
    if [ ! -d $SRCDIR/mk-blocks ]; then
        if ! git clone https://github.com/Markov-Komarov/mk-blocks.git $SRCDIR/mk-blocks; then
            echo "Failed to clone the repository"
            return 1
        fi
    else
        echo "Repository already exists, skipping clone"
    fi

    cd $SRCDIR/mk-blocks || { echo "Failed to change directory to mk-blocks"; return 1; }

    # Build the project
    if ! make -s clean; then
        echo "Make cleanup failed"
        return 1
    fi

    # Install the built binary
    if ! sudo make -s clean install; then
        echo "Failed to install the built binary"
        return 1
    fi

    echo "mk-blocks installed successfully"
}

clone_mkterm() {
    # Clone the repository in the home/src directory
    if [ ! -d $SRCDIR/mk-st ]; then
        if ! git clone https://github.com/Markov-Komarov/mk-st.git $SRCDIR/mk-st; then
            echo "Failed to clone the repository"
            return 1
        fi
    else
        echo "Repository already exists, skipping clone"
    fi

    cd $SRCDIR/mk-st || { echo "Failed to change directory to st"; return 1; }

    # Build the project
    if ! make -s clean; then
        echo "Make cleanup failed"
        return 1
    fi

    # Install the built binary
    if ! sudo make -s clean install; then
        echo "Failed to install the built binary"
        return 1
    fi

    echo "mk-st installed successfully"
}

clone_mkmenu() {
    # Clone the repository in the home/src directory
    if [ ! -d $SRCDIR/mk-dmenu ]; then
        if ! git clone https://github.com/Markov-Komarov/mk-dmenu.git $SRCDIR/mk-dmenu; then
            echo "Failed to clone the repository"
            return 1
        fi
    else
        echo "Repository already exists, skipping clone"
    fi

    cd $SRCDIR/mk-dmenu || { echo "Failed to change directory to dmenu"; return 1; }

    # Build the project
    if ! make -s clean; then
        echo "Make cleanup failed"
        return 1
    fi

    # Install the built binary
    if ! sudo make -s clean install; then
        echo "Failed to install the built binary"
        return 1
    fi

    echo "mk-dmenu installed successfully"
}

clone_shbin_files() {
    # Clone the directory to ~/local/
    if ! cp -r bin $HOME/.local; then
        echo "Cloned bin files to .local/bin failed"
        return 1
    else
        echo "Cloned bin files to .local/bin"
    fi
}

clone_config_folders() {
    # Ensure the target directory exists
    [ ! -d $HOME/.config ] && mkdir -p $HOME/.config
    # Iterate over all directories in config/*
    for dir in config/*/; do
        # Extract the directory name
        dir_name=$(basename "$dir")

        # Clone the directory to ~/.config/
        if [ -d "$dir" ]; then
            cp -r "$dir" $HOME/.config
            echo "Cloned $dir_name to ~/.config/"
        else
            echo "Directory $dir_name does not exist, skipping"
        fi
    done
}

# Call the functions
clone_mkdwm
clone_mkblocks
clone_mkterm
clone_mkmenu
clone_shbin_files
clone_config_folders

echo "All dependencies installed successfully."
