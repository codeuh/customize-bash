#!/bin/bash

# this install-daks-awesome-terminal.sh script is used to install a suit of terminal customizations that i've been experiementing with.
set -e

echo "Updating system and installing base utilities..."
if command -v microdnf >/dev/null 2>&1; then
    PKG_UPDATE="microdnf update -y"
    PKG_INSTALL="microdnf install -y"
    PKG_CLEAN="microdnf clean all"
elif command -v dnf >/dev/null 2>&1; then
    PKG_UPDATE="dnf update -y"
    PKG_INSTALL="dnf install --allowerasing -y"
    PKG_CLEAN="dnf clean all"
else
    echo "Neither microdnf nor dnf found. Exiting."
    exit 1
fi

echo "Using package manager: $(command -v microdnf || command -v dnf)"
#$PKG_UPDATE
#$PKG_INSTALL git tar unzip tzdata make gawk procps findutils
#$PKG_CLEAN

echo "Installing Oh My Posh..."
mkdir -p "$HOME/.posh"
curl -fsSL https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -o "$HOME/.posh/oh-my-posh"
chmod +x "$HOME/.posh/oh-my-posh"
mkdir -p "$HOME/.posh-themes"
curl -fsSL https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -o "$HOME/.posh/themes.zip"
unzip "$HOME/.posh/themes.zip" -d "$HOME/.posh-themes"
rm "$HOME/.posh/themes.zip"

# Modified Oh My Posh configuration to use the selected theme
cat << EOF >> "$HOME/.bashrc"
# Oh My Posh configuration
export PATH=\$PATH:\$HOME/.posh:
eval "\$(oh-my-posh init bash)"

# Better command colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
EOF

echo "Setting timezone to America/Chicago..."
export TZ=America/Chicago
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

echo "Installing ble.sh for Bash autosuggestions and syntax highlighting..."
git clone --depth 1 https://github.com/akinomyoga/ble.sh.git "$HOME/.ble.sh"
make -C "$HOME/.ble.sh"
cat << 'EOF' >> "$HOME/.bashrc"
# ble.sh: enhances Bash with autosuggestions and syntax highlighting
source $HOME/.ble.sh/out/ble.sh
bleopt history_share=1
export HISTFILE="$HOME/.local/share/blesh/ble_history"
EOF

echo "Installing bat (cat replacement)..."
curl -fsSL https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz -o bat.tar.gz
tar -xzf bat.tar.gz --no-same-permissions --no-same-owner
mv bat-v0.25.0-x86_64-unknown-linux-gnu/bat /usr/local/bin/bat
chmod +x /usr/local/bin/bat
rm -rf bat.tar.gz bat-v0.25.0-x86_64-unknown-linux-gnu
cat << 'EOF' >> "$HOME/.bashrc"
# alias cat to bat (a cat replacement with wings)
alias cat="bat"
EOF

echo "Installing eza (modern ls replacement)..."
cd /tmp
curl -L https://github.com/eza-community/eza/releases/download/v0.20.19/eza_x86_64-unknown-linux-gnu.zip -o eza.zip
unzip eza.zip
mv eza /usr/local/bin/
cd /
rm -rf /tmp/*
cat << 'EOF' >> "$HOME/.bashrc"
# alias ls to eza, with additional aliases
alias ls="eza"
alias ll="eza -l"
alias la="eza -la"
EOF

echo "Installing zoxide (modern cd replacement)..."
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
cat << 'EOF' >> "$HOME/.bashrc"

# Add .local/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

eval "$(zoxide init bash)"
alias cd="z"
EOF

echo "Installing fzf (fuzzy finder)..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
"$HOME/.fzf/install" --all

echo "Setting fzf environment variables..."
cat << 'EOF' >> "$HOME/.bashrc"
# Setting fzf environment variables...
export FZF_DEFAULT_OPTS="--layout=reverse --preview 'bat --color=always {}'"
export FZF_CTRL_T_COMMAND="find . -type f -not -path './.git/*'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:wrap"
EOF

echo "Daks Awesome Terminal Feature installation complete."
