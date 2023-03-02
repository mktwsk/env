#!/bin/sh

echo "Sprawdzam distro: "
DISTRO=$(lsb_release -i | cut -f 2-)
echo $DISTRO

if [ "$DISTRO" = "Debian" ]; then
	sudo apt update &&
	sudo apt upgrade &&
	sudo apt install aptitude &&
	sudo aptitude update &&
	sudo aptitude install zsh &&
	sudo aptitude install vim &&
	sudo aptitude install git &&
	sudo aptitude install rsync
else
	echo "To nie moje distro"
fi

echo "Rsync .vim"
rsync -a --info=progress2 --no-i-r ~/git/env/.vim ~/
echo "Rsync .oh-my-zsh"
rsync -a --info=progress2 --no-i-r ~/git/env/.oh-my-zsh ~/


cp  .vimrc ~/
cp  .zshrc ~/

echo "\n Helptagi dla Vima"
vim -u NONE -c "helptags fugitive/doc" -c q


echo "Uczynił żem!"
