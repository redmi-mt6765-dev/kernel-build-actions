#!/bin/bash
# ===============================================
#   Android Kernel Build Script ⚙️🐧
#   Author: techdiwas
# ===============================================

# Exit on error and handle pipeline failures
set -eo pipefail

# --- Configuration ---
# Grouping all configuration variables at the top makes them easy to manage.

# Kernel Source Configuration
readonly KERNEL_SOURCE_URL="https://github.com/redmi-mt6765-dev/android_kernel_dandelion.git"
readonly KERNEL_BRANCH="dandelion-q-oss"
readonly KERNEL_DIR="android-kernel"

# Device Build Configuration
readonly DEFCONFIG="dandelion_defconfig"
readonly ARCH="arm64"
readonly KERNEL_OUT_DIR="out"
readonly FINAL_IMAGE_PATH="${KERNEL_OUT_DIR}/arch/${ARCH}/boot/Image.gz-dtb"

# Toolchain Configuration
readonly TOOLCHAIN_DIR="$HOME/toolchains"
readonly CLANG_DIR="${TOOLCHAIN_DIR}/clang-r353983c"
readonly GCC_ARM32_DIR="${TOOLCHAIN_DIR}/arm-linux-androideabi-4.9"
readonly GCC_AARCH64_DIR="${TOOLCHAIN_DIR}/aarch64-linux-android-4.9"

readonly CLANG_URL="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android10-release/clang-r353983c.tar.gz"
readonly GCC_ARM32_URL="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/+archive/refs/heads/android10-release.tar.gz"
readonly GCC_AARCH64_URL="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/heads/android10-release.tar.gz"

# --- Function Definitions ---

# Clones the kernel source code from the specified repository.
clone_kernel_source() {
  echo "📦 Cloning kernel source from ${KERNEL_SOURCE_URL}..."
  git clone --depth=1 --branch "$KERNEL_BRANCH" "$KERNEL_SOURCE_URL" "$KERNEL_DIR"
  cd "$KERNEL_DIR"
  echo "✅ Kernel source cloned successfully."
}

# Downloads and extracts a toolchain from a URL to a specified directory.
# Arguments:
#   $1: Toolchain name (for logging purposes)
#   $2: URL of the toolchain tarball
#   $3: Target directory for extraction
download_and_extract() {
  local name="$1"
  local url="$2"
  local target_dir="$3"

  echo "⬇️  Fetching ${name}..."
  mkdir -p "$target_dir"
  wget -qO- "$url" | tar -xz -C "$target_dir"
  echo "✅ ${name} downloaded and extracted."
}

# Sets up all required toolchains.
setup_toolchains() {
  echo "🛠️  Setting up toolchains..."
  download_and_extract "Clang" "$CLANG_URL" "$CLANG_DIR"
  download_and_extract "GCC (arm32)" "$GCC_ARM32_URL" "$GCC_ARM32_DIR"
  download_and_extract "GCC (aarch64)" "$GCC_AARCH64_URL" "$GCC_AARCH64_DIR"

  # Add toolchains to the PATH for the current session.
  export PATH="${CLANG_DIR}/bin:${GCC_ARM32_DIR}/bin:${GCC_AARCH64_DIR}/bin:${PATH}"
  echo "✅ Toolchain paths configured."
}

# Compiles the kernel.
build_kernel() {
  echo "🚀 Building kernel..."
  
  # Get the number of available CPU cores to speed up the build.
  local cores
  cores=$(nproc --all)

  # Create the output directory.
  mkdir -p "$KERNEL_OUT_DIR"

  # Configure the kernel build.
  make O="$KERNEL_OUT_DIR" ARCH="$ARCH" SUBARCH="$ARCH" "$DEFCONFIG"

  # Start the compilation process.
  make -j"$cores" O="$KERNEL_OUT_DIR" \
      ARCH="$ARCH" \
      SUBARCH="$ARCH" \
      CC=clang \
      CLANG_TRIPLE=aarch64-linux-gnu- \
      CROSS_COMPILE=aarch64-linux-android- \
      CROSS_COMPILE_ARM32=arm-linux-androideabi-
}

# Verifies the result of the build.
check_build_status() {
  echo "🔎 Verifying build output..."
  if [ -f "$FINAL_IMAGE_PATH" ]; then
    echo "🎯 Kernel build successful!"
    echo "Image file is located at: $(pwd)/${FINAL_IMAGE_PATH}"
  else
    echo "💥 Kernel build failed!"
    exit 1
  fi
}

# --- Main Execution ---

main() {
  clone_kernel_source
  setup_toolchains
  build_kernel
  check_build_status
}

# Run the main function.
main
