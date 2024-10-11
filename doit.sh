#!/bin/bash

set -euo pipefail

GITDIR="$HOME/git"
ENVDIR="$GITDIR/env"

echo "Sprawdzam distro:"
if command -v lsb_release >/dev/null 2>&1; then
    DISTRO=$(lsb_release -i | cut -f 2-)
else
    echo "Nie można znaleźć polecenia lsb_release."
    exit 1
fi
echo "Oto i ono: $DISTRO"
echo ""
echo "Czynię instalacje preróżne"
echo ""

if [ "$DISTRO" = "Debian" ]; then
    if ! command -v sudo >/dev/null 2>&1; then
        echo "Polecenie sudo nie jest dostępne. Proszę zainstalować sudo."
        exit 1
    fi
    sudo apt update -y
    sudo apt install -y aptitude curl git rsync neofetch zsh vim

    # Install GitHub CLI
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
        sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
else
    echo "To nie moje distro"
fi

# Tworzenie katalogu GITDIR, jeśli nie istnieje
if [ -d "$GITDIR" ]; then
    echo "Jest $GITDIR"
else
    echo "Tworzę $GITDIR"
    mkdir -p "$GITDIR"
fi

# Sprawdzenie i klonowanie ENVDIR
if [ -d "$ENVDIR" ]; then
    echo "Jest $ENVDIR"
else
    echo "Klonowanie $ENVDIR"

    # Sprawdzenie autentykacji GH
    if gh auth status >/dev/null 2>&1; then
        echo "Zalogowany do GH"
    else
        echo "Trzeba się zalogować do GH"
        gh auth login
    fi
    gh auth setup-git
    cd "$GITDIR"
    git clone git@github.com:mktwsk/env.git
fi

cd "$ENVDIR"
git submodule update --init --recursive
git submodule update --recursive --remote

echo "Synchronizacja .vim"
rsync -a --info=progress2 --no-i-r "$ENVDIR/.vim" "$HOME/"

echo "Synchronizacja .oh-my-zsh"
rsync -a --info=progress2 --no-i-r "$ENVDIR/.oh-my-zsh" "$HOME/"

echo "Kopiuję .vimrc"
cp -v "$ENVDIR/.vimrc" "$HOME/"

echo "Kopiuję .zshrc"
cp -v "$ENVDIR/.zshrc" "$HOME/"

echo "Ustawiam shell na zsh"
if command -v chsh >/dev/null 2>&1; then
    sudo chsh -s "$(command -v zsh)" "$USER"
else
    echo "Polecenie chsh nie jest dostępne. Nie można zmienić shell'a."
fi

echo "Generuję helptagi dla Vima"
vim -u NONE -c "helptags ALL" -c q

echo -e '\n\n'

neofetch

echo -e '\n\n'
echo "Uczynił żem!"
