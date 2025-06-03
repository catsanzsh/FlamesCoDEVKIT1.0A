#!/bin/bash
set -e

CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
NC="\033[0m"

echo -e "${CYAN}🔧 Updating system and installing base dependencies…${NC}"
sudo apt update
sudo apt install -y wget gnupg git build-essential pkg-config

echo -e "${CYAN}🌐 Adding devkitPro APT repo…${NC}"
echo "deb [signed-by=/usr/share/keyrings/devkitpro.gpg] https://apt.devkitpro.org/ stable main" | sudo tee /etc/apt/sources.list.d/devkitpro.list

echo -e "${CYAN}🔑 Adding devkitPro GPG key…${NC}"
wget https://apt.devkitpro.org/devkitpro-keyring.gpg -O- | sudo gpg --dearmor -o /usr/share/keyrings/devkitpro.gpg

echo -e "${CYAN}📦 Installing devkitPro pacman + keyring…${NC}"
sudo apt update
sudo apt install -y devkitpro-keyring pacman

echo -e "${CYAN}⬇️ Installing ALL toolchains and libraries…${NC}"
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm gba-dev nds-dev 3ds-dev gamecube-dev wii-dev wiiu-dev switch-dev
sudo pacman -S --noconfirm devkitARM devkitPPC devkitA64 general-tools portlibs libgba libnds libctru libogc libnx examples

echo -e "${CYAN}🌍 Setting up environment variables…${NC}"
SHELL_PROFILE="$HOME/.bashrc"
if [[ $SHELL == *zsh ]]; then
    SHELL_PROFILE="$HOME/.zshrc"
fi

cat <<EOF >> "$SHELL_PROFILE"

# ===== devkitPro Environment =====
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=\$DEVKITPRO/devkitARM
export DEVKITPPC=\$DEVKITPRO/devkitPPC
export DEVKITA64=\$DEVKITPRO/devkitA64
export PATH=\$DEVKITPRO/tools/bin:\$PATH
# ================================
EOF

source "$SHELL_PROFILE"

echo -e "${GREEN}✅ ALL DONE! DevkitPro fully installed.${NC}"
echo -e "${CYAN}🎮 Toolchains are in /opt/devkitpro — time to build retro magic.${NC}"
