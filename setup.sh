#!/bin/bash
# ===============================================
#   Android Kernel Build Setup Script ⚙️🌳
#   Author: techdiwas
# ===============================================

set -eo pipefail

# --- Function Definitions ---

update_package_lists() {
  echo "🔄 Updating package lists..."
  sudo apt-get update
}

install_dependencies() {
  echo "📦 Installing required packages and software..."

  local packages=(
    # --- Core Build Essentials ---
    build-essential
    bc
    bison
    flex
    make
    curl
    zip
    unzip
    git-core
    gnupg
    wget
    rsync

    # --- Libraries & Dev Tools ---
    libncurses5
    libncurses5-dev
    libncursesw5
    libncursesw5-dev
    libc6-dev-i386
    lib32z1-dev
    lib32ncurses5-dev
    lib32readline-dev
    zlib1g-dev
    libssl-dev
    libelf-dev
    libtinfo5

    # --- Graphics / XML / Utils ---
    libgl1-mesa-dev
    libx11-dev
    x11proto-core-dev
    xsltproc
    libxml2-utils
    fontconfig

    # --- Java (needed for AOSP) ---
    openjdk-8-jdk

    # --- Python & Build Helpers ---
    python3
    python3-pip
    ccache
    fakeroot
    kmod

    # --- Android Tools ---
    adb
    fastboot
    u-boot-tools

    # --- Autotools / Automake Suite ---
    autoconf
    automake
    autotools-dev
    libtool
    pkg-config
    m4
  )

  sudo apt-get install -y "${packages[@]}"
}

# --- Main Execution ---

main() {
  echo "🚀 Starting the build environment setup..."

  update_package_lists
  install_dependencies

  echo "🎉 Build environment setup is complete! You’re good to compile kernels now. ✅"
}

main
