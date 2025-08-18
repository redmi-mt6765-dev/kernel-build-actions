#!/bin/bash
# ===============================================
#   Android Kernel Build Setup Script ⚙️🌳
#   Author: techdiwas
# ===============================================

# Exit immediately if a command exits with a non-zero status.
# The `pipefail` option ensures that a pipeline returns a non-zero status
# if any command in the pipeline fails.
set -eo pipefail

# --- Function Definitions ---

# Updates the system's package lists.
update_package_lists() {
  echo "Updating package lists..."
  sudo apt-get update
}

# Installs all the necessary packages for the build.
install_dependencies() {
  echo "Installing required packages and software..."
  
  # A list of all packages to be installed.
  # Storing them in an array makes the list easier to manage.
  local packages=(
    build-essential
    bison
    curl
    flex
    fontconfig
    git-core
    gnupg
    libc6-dev-i386
    lib32z1-dev
    libgl1-mesa-dev
    libx11-dev
    libxml2-utils
    make
    openjdk-8-jdk
    python3
    unzip
    x11proto-core-dev
    xsltproc
    zip
    zlib1g-dev
  )
  
  # Install all packages in a single command.
  sudo apt-get install -y "${packages[@]}"
}

# --- Main Execution ---

main() {
  echo "Starting the build environment setup..."
  
  update_package_lists
  install_dependencies
  
  echo "Build environment setup is complete! ✅"
}

# Run the main function of the script.
main
