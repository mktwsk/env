#!/bin/sh

echo "Sprawdzam distro: "
DISTRO=$(lsb_release -i | cut -f 2-)
echo $DISTRO

rsync -a --info=progress2 --no-i-r ~/git/env/.* ~/


cp  .vimrc ~/
cp  .zshrc ~/

echo "\n Helptagi dla Vima"
vim -u NONE -c "helptags fugitive/doc" -c q


DISTRO=$(lsb_release -i | cut -f 2-)
echo $DISTRO


echo "Uczynił żem!"
