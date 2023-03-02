#!/bin/sh

echo "Sprawdzam distro: "
DISTRO=$(lsb_release -i | cut -f 2-)
echo $DISTRO

if [ "$DISTRO" = "Debian" ]; then
	sudo apt update -y &&
	sudo apt upgrade -y &&
	sudo apt install aptitude -y &&
	sudo aptitude update -y &&
	sudo aptitude install zsh -y &&
	sudo aptitude install vim -y &&
	sudo aptitude install git -y &&
	sudo aptitude install rsync -y &&
	type -p curl >/dev/null || sudo aptitude install curl -y
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo aptitude update \
	&& sudo aptitude install gh -y
else
	echo "To nie moje distro"
fi

GITDIR="/home/$USER/git"
ENVDIR="/home/$USER/git/env"


if [ -d "$GITDIR"  ] ; then
	echo "Jest $GITDIR"
else
	mkdir ~/git
fi

if [ -d "$ENVDIR" ] ; then
	echo "Jest $ENVDIR"
else
	mkdir ~/git/env
fi

cd ~/git/env



echo "Rsync .vim"
rsync -a --info=progress2 --no-i-r ~/git/env/.vim ~/
echo "Rsync .oh-my-zsh"
rsync -a --info=progress2 --no-i-r ~/git/env/.oh-my-zsh ~/


cp  .vimrc ~/
cp  .zshrc ~/

echo "\n Helptagi dla Vima"
vim -u NONE -c "helptags fugitive/doc" -c q


echo "Uczynił żem!"
