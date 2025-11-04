#!/usr/bin/env bash
# Update Brave browser on a Void system.

install_latest_brave_deb() {
    # Get machine architecture.
    local arch
    arch=$(uname -m)
    if [ "$arch" == "x86_64" ]; then
        arch="amd64"
    elif [ "$arch" == "aarch64" ]; then
        arch="arm64"
    fi

    # Download latest Brave debian package.
    echo "Downloading latest stable version of Brave..."
    wget "https://github.com/brave/brave-browser/releases/download/v${1}/brave-browser_${1}_${arch}.deb"

    # Download SHA-256 checksum file and compare package against it.
    wget "https://github.com/brave/brave-browser/releases/download/v${1}/brave-browser_${1}_${arch}.deb.sha256"

    local chksum
    sha256sum -c "brave-browser_${1}_${arch}.deb.sha256" > /dev/null
    chksum=$?
    rm -f "brave-browser_${1}_${arch}.deb.sha256"

    if (( chksum == 0)); then
        echo "SHA-256 checksum OK for downloaded Brave deb package."
    else
        echo "SHA-256 checksum failed for downloaded Brave deb package."
        echo "Aborting..."
        exit 1
    fi

    # Convert Debian package to XBPS installable package and install it.
    echo "Installing Brave for a Void system..."
    xdeb -Sedf "brave-browser_${1}_${arch}.deb"
    doas xbps-install -Syu -R ./binpkgs brave-browser
    rm -f "brave-browser_${1}_${arch}.deb"
    rm -f shlibs
    rm -rf workdir
    rm -rf datadir
    rm -rf destdir
    rm -rf binpkgs
}

# Check latest version of Brave against currently installed version.
check_for_brave_updates() {
    local vers_file
    vers_file='.brave_version'
    if ! [[ -f "${vers_file}" ]]; then
        echo "0" > "${vers_file}" # Create 0 version as placeholder.
    fi

    local release_file
    release_file='.brave_latest'

    # Get latest version from appropriate channel and platform.
    local channel_platform
    local arch
    arch=$(uname -m)
    if [[ "$arch" == "x86_64" ]]; then
        channel_platform="release-linux-x64"
    elif [[ "$arch" == "aarch64" ]]; then
        channel_platform="release-linux-arm64"
    fi
    
    local vers
    curl -s "https://versions.brave.com/latest/internal/${channel_platform}.version" > "$release_file"
    read -r vers < "${release_file}"
    vers=$(printf "%s" "$vers")

    echo "Latest Brave version is ${vers}."

    local installed
    read -r installed < "${vers_file}"
    installed=$(printf "%s" "$installed")
    echo "Installed Brave version is ${installed}."

    if [[ "$installed" != "$vers" ]]; then
        echo
        install_latest_brave_deb "$vers"
        echo "$vers" > "${vers_file}"
    fi
    
    echo "Done."
    exit 0
}

check_for_brave_updates