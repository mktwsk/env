#!/bin/sh

GITDIR="/home/$USER/git"
ENVDIR="/home/$USER/git/env"

echo "Sprawdzam distro: "
DISTRO=$(lsb_release -i | cut -f 2-)
echo "Oto i ono: "$DISTRO
echo""
echo " Czynię instalacje preróżne"
echo""

if [ "$DISTRO" = "Debian" ]; then
	sudo apt update -y &&
	sudo apt upgrade -y &&
	sudo apt install aptitude -y &&
	sudo aptitude update -y &&
	sudo aptitude install zsh -y &&
	sudo aptitude install vim -y &&
	sudo aptitude install git -y &&
	sudo aptitude install rsync -y &&
	sudo aptitude install neofetch &&
	type -p curl >/dev/null || sudo aptitude install curl -y
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo aptitude update \
	&& sudo aptitude install gh -y
else
	echo "To nie moje distro"
fi



if [ -d "$GITDIR"  ] ; then
	echo "Jest $GITDIR"
else
	echo "Tworzę $GITDIR"
	mkdir ~/git
fi

if [ -d "$ENVDIR" ] ; then
	echo "Jest $ENVDIR"
else
	echo "Tworzę $ENVDIR"
	mkdir ~/git/env
fi

cd ~/git/env



echo "Rsync .vim"
rsync -a --info=progress2 --no-i-r ~/git/env/.vim ~/
echo "Rsync .oh-my-zsh"
rsync -a --info=progress2 --no-i-r ~/git/env/.oh-my-zsh ~/

echo "Kopiuję .vimrc"
cp  -v .vimrc ~/
echo "Kopiuję .zshrc"
cp  -v .zshrc ~/

echo "Ustawiam shell na zsh"
sudo chsh -s /usr/bin/zsh $USER
echo "Helptagi dla Vima"
vim -u NONE -c "helptags fugitive/doc" -c q

neofetch

echo "Uczynił żem!"
