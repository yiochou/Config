#!/bin/bash

# === tmux ==============================
ln -s -f $PWD/.tmux.conf ~/.tmux.conf

# === bash_prompt =======================
echo "source $PWD/.bash_prompt" >> ~/.bash_prompt;

# === bashrc ============================
echo "source $PWD/.bashrc" >> ~/.bashrc;

# === gitconfig =========================
echo "[include] \n\t path = $PWD/.gitconfig" >> ~/.gitconfig;

# === ghostty ===========================
mkdir -p ~/.config/ghostty
ln -s -f $PWD/ghostty/config ~/.config/ghostty/config

# === help system (Yio Command Center) ==
mkdir -p ~/.local/bin ~/.local/share/help
ln -s -f $PWD/h ~/.local/bin/h
chmod +x ~/.local/bin/h
for f in $PWD/help/*; do
    ln -s -f "$f" ~/.local/share/help/$(basename "$f")
done

# === tmux plugins ======================
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "TPM installed. Run 'Ctrl+A Shift+I' inside tmux to install plugins."
fi
