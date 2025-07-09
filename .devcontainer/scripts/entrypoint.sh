#!/usr/bin/env bash
set -e

function start_openvswitch_service {
    service openvswitch-switch start > /dev/null 2>&1
    ovs-vswitchd --pidfile --detach > /dev/null 2>&1 || true
    ovs-vsctl set-manager ptcp:6640 > /dev/null 2>&1
}

start_openvswitch_service
mininet_version=$(mn --version 2>&1 >/dev/null)
osken_version=$(osken-manager --version)

# Start dockerd if not already running
echo -e "🐳 \e[34mStarting Docker daemon...\e[0m"
if ! pgrep -x "dockerd" > /dev/null; then
    echo -e "\e[90mnohup dockerd > /dev/null 2>&1 &\e[0m"
    dockerd > /dev/null 2>&1 &
    sleep 5
    echo -e "\e[32mDockerd started!\e[0m"
else
    echo -e "\e[32mDockerd is already running!\e[0m"
    echo -e "\033[1;31m☢️ Stopping and removing all containers\033[0m"
    echo "docker stop \$(docker ps -q)"
    docker stop $(docker ps -q)
    echo "docker system prune -a -f"
    docker system prune -a -f
    echo -e "\033[1;32mDone!\033[0m"
fi

figlet "SCC365 DevContainer"

echo "Installed tools:"
echo -e "\tMininet: ${mininet_version}"
echo -e "\tOS-Ken: ${osken_version#"osken-manager "}"
