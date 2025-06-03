#!/bin/bash
set -e  # stop on first error but keep window open afterwards
###############################################################################
# DevKitPro + Community SDK Megapack                                             
# Adds Atari 2600/7800/Jaguar and PlayStation 1—4 toolchains, plus PS5 stub.     
# Expanded to install all devkitPro packages.
###############################################################################

# ---------- Styling ----------
CYAN="\033[1;36m"; GREEN="\033[1;32m"; RED="\033[1;31m"; NC="\033[0m"

# Function to pause on script exit (success *or* error)
pause() {
  echo -e "${CYAN}Press [ENTER] to close this window…${NC}"
  read -r
}
trap pause EXIT INT TERM ERR   # ensures the pause even if the script aborts

# ---------- devkitPro ----------
echo -e "${CYAN}Installing devkitPro pacman…${NC}"
sudo apt-get update
sudo apt-get install -y wget gnupg git build-essential pkg-config

echo "deb https://apt.devkitpro.org/ stable main" | sudo tee /etc/apt/sources.list.d/devkitpro.list
wget https://apt.devkitpro.org/devkitpro-keyring.gpg -O- | sudo gpg --dearmor -o /usr/share/keyrings/devkitpro.gpg
sudo apt-get update && sudo apt-get install -y devkitpro-keyring pacman 

# ---------- PATHs ----------
echo -e "${CYAN}Setting up devkitPro environment variables…${NC}"
{
  echo ''
  echo '# DevkitPro Paths'
  echo 'export DEVKITPRO=/opt/devkitpro'
  echo 'export DEVKITDOTPRO=/opt/devkitpro'
  echo 'export PATH=$DEVKITPRO/tools/bin:$PATH'
  echo 'export PATH=$DEVKITPRO/devkitARM/bin:$PATH'
  echo 'export PATH=$DEVKITPRO/devkitPPC/bin:$PATH'
  echo 'export PATH=$DEVKITPRO/devkitA64/bin:$PATH'
} >> ~/.bashrc

export DEVKITPRO=/opt/devkitpro
export DEVKITDOTPRO=/opt/devkitpro
export PATH=$DEVKITPRO/tools/bin:$PATH
export PATH=$DEVKITPRO/devkitARM/bin:$PATH
export PATH=$DEVKITPRO/devkitPPC/bin:$PATH
export PATH=$DEVKITPRO/devkitA64/bin:$PATH

# ---------- Nintendo toolchains ----------
echo -e "${CYAN}Installing ALL devkitPro toolchains and libraries…${NC}"
sudo pacman -Syu --noconfirm devkitpro

# ---------- Verification Only ----------
echo -e "${CYAN}Verifying devkitPro core compilers only…${NC}"
source ~/.bashrc

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

verify_compiler() {
  local compiler_name="$1"
  local version_flag="${2:---version}"
  local friendly_name="$3"

  if command_exists "$compiler_name"; then
    echo -e "${GREEN}${friendly_name} ($compiler_name) found:${NC}"
    "$compiler_name" "$version_flag" | head -n 1
  else
    echo -e "${RED}${friendly_name} ($compiler_name) missing or not in PATH!${NC}"
  fi
}

verify_compiler "arm-none-eabi-gcc" "--version" "devkitARM (GBA/NDS/3DS)"
verify_compiler "aarch64-none-elf-gcc" "--version" "devkitA64 (Switch)"
verify_compiler "powerpc-eabi-gcc" "--version" "devkitPPC (Wii/GameCube)"

echo -e "${GREEN}Minimal devkitPro setup check complete.${NC}"
echo -e "${CYAN}To use Atari or PlayStation SDKs, run the full installer script.${NC}"
