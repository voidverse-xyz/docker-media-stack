#!/usr/bin/env bash

echo "[+] Updating system.... [+]"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "[+] Installing Docker...[+]"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

printf "\n\n"
read -p "[+] Install tmux? (y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo apt-get install tmux git -y
fi


printf "\n\n"
read -p "[+] Install OpenVPN (y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo apt install openvpn -y
fi
printf "\n\n"

printf "\n\n"
read -p "[+] Run docker media server? (y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo docker compose up -d
fi
printf "\n\n"
