#!/bin/zsh

# === tmux ==============================
ln -s -f $PWD/.tmux.conf ~/.tmux.conf

# === bash_prompt =======================
echo "source $PWD/.bash_prompt" >> ~/.bash_prompt;

# === bashrc ============================
echo "source $PWD/.bashrc" >> ~/.bashrc;

# === gitconfig =========================
echo "[include] \n\t path = $PWD/.gitconfig" >> ~/.gitconfig;

# === bash_profile (for Mac Terminal) ===
# https://joshstaiger.org/archives/2005/07/bash_profile_vs.html
# echo "source $PWD/.bash_profile" >> ~/.bash_profile;
