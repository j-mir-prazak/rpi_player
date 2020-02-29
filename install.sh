#!/bin/bash


path=$(pwd)
home=

if [[ ! -d ~/".config/autostart" ]]; then
	mkdir -p ~/".config/autostart";
fi

if [[ -d ~/".config/lxsession/LXDE-pi/" ]]; then
	if [[ -f ~/".config/lxsession/LXDE-pi/autostart" ]]; then
		rm ~/".config/lxsession/LXDE-pi/autostart";
	fi
fi

function sudoing {
if [[ ! -d "/etc/xdg/lxsession/LXDE-pi"  ]]; then
	sudo mkdir -p "/etc/xdg/lxsession/LXDE-pi"
fi

if [[ -d "/etc/xdg/lxsession/LXDE-pi" ]]; then
	sudo echo -ne "" >"/etc/xdg/lxsession/LXDE-pi/autostart"
	sudo echo -e "@pcmanfm -d" >>"/etc/xdg/lxsession/LXDE-pi/autostart"
fi

if [[ -d "/etc/xdg/lxsession/LXDE"  ]]; then
	sudo rm "/etc/xdg/lxsession/LXDE" -rf
fi

if [[ -f "/etc/xdg/autostart/piwiz.desktop" ]]; then
	sudo rm /etc/xdg/autostart/piwiz.desktop
fi

}

sudo_fun=$(declare -f sudoing)
sudo bash -c "$sudo_fun; sudoing"


echo -n "" >~/".config/autostart/rpi_player.desktop"
echo -e "[Desktop Entry]\nType=Application\nExec=""$path""/autostart.sh" >>~/".config/autostart/rpi_player.desktop"

chmod +x ~/".config/autostart" -R
chmod +x ~/".config/autostart/"* -R
chmod +x -R $path/*
