#!/bin/bash


path=$(pwd)
if [[ ! -d ~/".config/autostart" ]]; then
	mkdir -p ~/".config/autostart";
fi

if [[ -d ~/".config/lxsession/LXDE-pi/" ]]; then
	if [[ -f ~/".config/lxsession/LXDE-pi/autostart" ]]; then
		rm ~/".config/lxsession/LXDE-pi/autostart";
	fi
fi

if [[ ! -d "/etc/xdg/lxsession/LXDE-pi"  ]]; then
	sudo mkdir -p "/etc/xdg/lxsession/LXDE-pi"
	sudo echo -ne "" >"/etc/xdg/lxsession/LXDE-pi/autostart"
	sudo echo -e "@pcmanfm -d" >>"/etc/xdg/lxsession/LXDE-pi/autostart"
fi

echo -n "" >~/".config/autostart/rpi_player.desktop"
echo -e "[Desktop Entry]\nType=Application\nExec=""$path""/autostart.sh" >>~/".config/autostart/rpi_player.desktop"

chmod +x ~/".config/autostart" -R
chmod +x ~/".config/autostart/*" -R
chmod +x -R $path/*
