#/bin/bash
echo "Google Earth installer for Liquid Galaxy"

sudo apt-get update
sudo apt-get install net-tools -y

echo "Installing Google Earth"
cd /tmp
wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
sudo dpkg -i google-earth-stable_current_amd64.deb
sudo apt-get -f install
rm google-earth-stable_current_amd64.deb

echo "Is this VM the Master? [y/n]: "
read master
if (("$master" == "y")); then
    ip="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
    sudo echo "4i; ViewSync settings\nViewSync/send = true\nViewSync/receive = false\nViewSync/hostname = $ip\nViewSync/port = 21567\nViewSync/yawOffset = 0\nViewSync/pitchOffset = 0.0\nViewSync/rollOffset = 0.0\nViewSync/horizFov = 36.5" > /opt/google/earth/pro/drivers.ini
else
    echo "Please specifiy the yaw (Left: -36.5, Right: 36.5): "
    read yaw
    sudo echo "4i; ViewSync settings\nViewSync/send = false\nViewSync/receive = true\nViewSync/port = 21567\nViewSync/yawOffset = $yaw\nViewSync/pitchOffset = 0.0\nViewSync/rollOffset = 0.0\nViewSync/horizFov = 36.5" > /opt/google/earth/pro/drivers.ini
fi

echo "Alright you're ready"
echo "Do you want to start Google Earth? [y/n]"
read run
if (("$run" == "y")); then
    google-earth
fi
exit