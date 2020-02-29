#!/bin/bash


path=$(pwd)
if [[ ! -d ~/".config/autostart" ]]; then
	mkdir -p ~/".config/autostart";
fi

echo -n "" >~/".config/autostart/rpi_player.desktop"
echo -e "[Desktop Entry]\nType=Application\nExec=""$path""/autostart.sh" >>~/".config/autostart/rpi_player.desktop"
chmod +x ~/".config/autostart/rpi_player.desktop"
chmod +x -R $path/*
