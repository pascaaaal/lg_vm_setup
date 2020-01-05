#/bin/bash
echo "Google Earth installer for Liquid Galaxy"

sudo apt-get -qq update
sudo apt-get -qq install net-tools -y

echo "Installing Google Earth"
cd /tmp
wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
sudo dpkg -i google-earth-stable_current_amd64.deb
sudo apt-get -f install
rm google-earth-stable_current_amd64.deb

read -p  "Is this VM the Master? [y/n]: " master
case "$master" in
    [yY][eE][sS]|[yY])
        ip="$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $6 }')"
        sudo sed -i "4i; ViewSync settings\nViewSync/send = true\nViewSync/receive = false\nViewSync/hostname = $ip\nViewSync/port = 21567\nViewSync/yawOffset = 0\nViewSync/pitchOffset = 0.0\nViewSync/rollOffset = 0.0\nViewSync/horizFov = 36.5" /opt/google/earth/pro/drivers.ini
        ;;
    *)
        read -p "Please specifiy the yaw (Left: -36.5, Right: 36.5): " yaw
        sudo sed -i "4i; ViewSync settings\nViewSync/send = false\nViewSync/receive = true\nViewSync/port = 21567\nViewSync/yawOffset = $yaw\nViewSync/pitchOffset = 0.0\nViewSync/rollOffset = 0.0\nViewSync/horizFov = 36.5" /opt/google/earth/pro/drivers.ini
        ;;
esac

echo "Alright you're ready"
read -p "Do you want to start Google Earth? [y/n]: " run
case "$master" in
    [yY][eE][sS]|[yY])
        google-earth-pro ;;
    *)
        exit 0 ;;
esac