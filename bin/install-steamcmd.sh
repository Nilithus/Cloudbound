#!/bin/bash -e

#installs and configures https://developer.valvesoftware.com/wiki/SteamCMD

sudo dpkg --add-architecture i386
sudo sed -ri 's/^(#|##).*((deb|deb-src).*xenial.*multiverse)/\2/' /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y libvorbisfile3
sudo apt-get install -y apt-utils

sudo useradd -m -s /bin/bash -U steam

# let us sudo as the steam user
echo "ubuntu ALL=(steam) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

echo "**Starting steam Install**"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y lib32stdc++6

# So this is fun steam as an interactive license you need to accept
# After much digging http://manpages.ubuntu.com/manpages/xenial/man7/debconf.7.html
# has a section for seeding the debconf database with the answer to questions packages
# will prompt with.
STEAM_DEB_CONF_FILE=/var/cache/debconf/steam.dat
sudo mv /home/ubuntu/steam.dat /var/cache/debconf/steam.dat
sudo chown root:root /var/cache/debconf/steam.dat
sudo chmod 644 /var/cache/debconf/steam.dat

sudo DEBIAN_FRONTEND=noninteractive DEBCONF_DB_FALLBACK="File{/var/cache/debconf/steam.dat}" apt-get install -y steamcmd

# this sucks shows password to stdout :(
sudo -iE sed -i "s/login/login $STEAM_USERNAME $STEAM_PASSWORD/" /home/ubuntu/starbound-steamcmd-script.txt
sudo mv /home/ubuntu/starbound-steamcmd-script.txt /home/steam/starbound-steamcmd-script.txt
sudo chown steam:steam /home/steam/starbound-steamcmd-script.txt

#install starbound server
sudo -i -u steam /usr/games/steamcmd +runscript /home/steam/starbound-steamcmd-script.txt

# set systemd to start starbound on boot
sudo mv /home/ubuntu/starbound-server.service /etc/systemd/system/starbound-server.service
sudo systemctl daemon-reload
sudo systemctl enable starbound-server

# dont store user password in the built image.
sudo rm /home/steam/starbound-steamcmd-script.txt