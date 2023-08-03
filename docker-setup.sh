#!/bin/bash

#check if run as sudo.  Do not run as sudo.
if [[ $EUID -ne 0 ]]; then
    #Check for updates
    echo "==================================================="
    echo "Checking for updates"
    echo "==================================================="
    echo ""
    sudo apt-get update
    #Install Docker requirements
    echo "==================================================="
    echo "Installing Docker requirements."
    echo "==================================================="
    echo ""
    sudo apt-get install ca-certificates curl gnupg lsb-release -y
    #Add Docker GPG key
    echo "==================================================="
    echo "Adding Docker GPG key"
    echo "==================================================="
    echo ""
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    #Run command to fix potentially broken GPG key permissions and prevent errors
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    #Set up Docker repository
    echo "==================================================="
    echo "Setting up Docker Repository"
    echo "==================================================="
    echo ""
    echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    #Check for updates now that Docker's repo is set up
    echo "==================================================="
    echo "Checking for Docker Updates"
    echo "==================================================="
    echo ""
    sudo apt-get update
    #Install Docker Engine
    echo "==================================================="
    echo "Installing Docker Engine"
    echo "==================================================="
    echo ""
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    echo "==================================================="
    echo "Installing Docker Compose"
    echo "==================================================="
    echo ""   
    sudo apt-get install docker-compose-plugin -y
    echo "==================================================="
    echo "Setting up Docker autostart"
    echo "==================================================="
    echo ""
    echo 'if service docker status 2>&1 | grep -q "is not running"; then
      wsl.exe  -u root -e /usr/sbin/service docker start
      fi' | tee -a ~/.profile ~/.zprofile >/dev/null
    echo "==================================================="
    echo "Setting up Docker Group for non-root user"
    echo "==================================================="
    echo ""
    sudo groupadd docker
    sudo usermod -aG docker $USER
    echo "Done.  To finsh setup, run the following command from powershell as administrator, then relaunch WSL."
    echo "Get-Service LxssManager | Restart-Service"
    echo "After logging back in, run the following command to test Docker"
    echo "docker run hello-world"
else
    echo "Do not run script as root (sudo)."
fi
