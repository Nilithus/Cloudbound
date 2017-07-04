#!/bin/bash -e

#installs and configures https://developer.valvesoftware.com/wiki/SteamCMD

sudo dpkg --add-architecture i386
sudo sudo sed -ri 's/^(#|##).*((deb|deb-src).*xenial.*multiverse)/\2/' /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y libvorbisfile3
sudo apt-get install -y apt-utils

sudo useradd -m steam
sudo apt-get install -y lib32stdc++6

# So this is fun steam as an interactive license you need to accept
# After much digging http://manpages.ubuntu.com/manpages/xenial/man7/debconf.7.html
# has a section for seeding the debconf database with the answer to questions packages
# will prompt with.
STEAM_DEB_CONF="
Name: steam/license
Template: steam/license
Value:
Owners: steam
Flags: seen

Name: steam/purge
Template: steam/purge
Owners: steam

Name: steam/question
Template: steam/question
Value: I AGREE
Owners: steam
Flags: seen
"
STEAM_DEB_CONF_FILE=/var/cache/debconf/steam.dat
sudo touch $STEAM_DEB_CONF_FILE
sudo chown root:root $STEAM_DEB_CONF_FILE
sudo chmod 644 $STEAM_DEB_CONF_FILE
sudo cat $STEAM_DEB_CONF > $STEAM_DEB_CONF_FILE

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_DB_FALLBACK=$STEAM_DEB_CONF_FILE

sudo apt-get install -y steamcmd

su - steam

