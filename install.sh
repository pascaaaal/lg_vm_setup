#/bin/bash
#If the script doesn't work, please make a new issue on https://github.com/pascaaaal/lg_vm_setup/issues

run_spinner() {
    $1 &
    PID=$!
    i=1
    sp="/-\|"
    echo -n ' '
    while [ -d /proc/$PID ]
    do
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.1
    donen
    echo "\n"
}

echo -e "\e[1mGoogle Earth installer for Liquid Galaxy\e[0m"

echo -e "\e[32mInstalling requirements...\e[0m"
run_spinner "sudo apt-get -qq install net-tools -y"

echo -e "\e[32mInstalling Google Earth...\e[0m"
cd /tmp
echo -e "\e[32mDownloading latest deb package...\e[0m"
wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb -q --show-progress

echo -e "\e[32mInstalling package... (This might take a minute) "
echo -e "Run dpkg "
run_spinner "sudo dpkg -s -i google-earth-stable_current_amd64.deb 2> /dev/null"
echo -e "Run apt-get "
run_spinner "sudo apt-get -qq -f install -y"

echo -e "Removing old file\n\e[0m"
rm google-earth-stable_current_amd64.deb

read -p  "Is this VM the Master? [y/n]: " master
case "$master" in
    [yY][eE][sS]|[yY])
        echo -e "\e[32mConfigure Google Earth...\e[0m"
        ip="$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $6 }')"
        sudo sed -i "4i; ViewSync settings\nViewSync/send = true\nViewSync/receive = false\nViewSync/hostname = $ip\nViewSync/port = 21567\nViewSync/yawOffset = 0\nViewSync/pitchOffset = 0.0\nViewSync/rollOffset = 0.0\nViewSync/horizFov = 36.5" /opt/google/earth/pro/drivers.ini
        ;;
    *)
        echo -e "\e[32mConfigure Google Earth...\e[0m"
        read -p "Please specifiy the yaw (Left: -36.5, Right: 36.5): " yaw
        sudo sed -i "4i; ViewSync settings\nViewSync/send = false\nViewSync/receive = true\nViewSync/port = 21567\nViewSync/yawOffset = $yaw\nViewSync/pitchOffset = 0.0\nViewSync/rollOffset = 0.0\nViewSync/horizFov = 36.5" /opt/google/earth/pro/drivers.ini
        ;;
esac

echo -e "\e[32mAlright you're ready\n\e[0m"
read -p "Do you want to start Google Earth? [y/n]: " run
case "$run" in
    [yY][eE][sS]|[yY])
        google-earth-pro ;;
    *)
        exit 0 ;;
esac