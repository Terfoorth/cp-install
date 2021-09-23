#!/usr/bin/env bash
#
# TechDivision client provisioning
#
# This script installs the command line tools and ansible. After this the
# client provisioning via ansible will be done.
#############################################################################
# VARIABLES
#############################################################################
CP_URL="terfoorthr@10.5.20.80:/Volumes/Workspace/Projekt_CP/.ansible"
CP_USER=${USER} 
CP_INSTALL_DIR="${HOME}/.ansible"
#CP_FILES_DIR="${CP_INSTALL_DIR}/files"
CP_PLAYBOOKS="$CP_INSTALL_DIR/playbooks"
#############################################################################

#Check system and install recources-----------------------------------------------

############## LINUX #########################################################
if [[ "$OSTYPE" == "linux-gnu" ]]; then
echo "Your operating system is, Ubuntu" 
sudo true
if [ ! -d "${CP_INSTALL_DIR}" ]; then
    sudo mkdir "${CP_INSTALL_DIR}"
fi
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible
    cd "$CP_PLAYBOOKS" &&
    ansible-playbook ubuntu_admin.yml
fi
########## MAC OS #########################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Your operating system is MAC-OSX"

#check specs and start CP
    echo "checking Hardware and OS Version..."
    MAC_TYPE=$(sysctl -a | grep "machdep.cpu.brand_string")
    echo "${MAC_TYPE}"

#MAC Appel m1---------------------------------------------------------------------------      
if [[ $MAC_TYPE == "machdep.cpu.brand_string: Apple M1" ]]; then
    echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
#install xcode a. ansible´     
           echo "After X-CODE installation, enter your "  
           xcode-select --install ||   
           sudo true       
              cd /opt &&
              sudo mkdir homebrew 
              sudo chown "$USER" homebrew 
              sudo chgrp admin homebrew 
              curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
              export PATH="/opt/homebrew/bin:$PATH"
            brew install ansible
# create install dir
              if [ ! -d "${CP_INSTALL_DIR}" ]; then
                  sudo mkdir "${CP_INSTALL_DIR}"
              fi
# reset correct permissions
                  sudo chmod 775 "${CP_INSTALL_DIR}"
                  sudo chown "${CP_USER}" "${CP_INSTALL_DIR}"
#run playbooks
              cd "$CP_PLAYBOOKS" &&
                if [[ $CP_USER == "it-support" ]]; then
                  ansible-playbook mac_arm_admin.yml
                  echo "provisioning system for Admin-Account finished"
                else
                  ansible-playbook mac_user.yml
                  echo "provisioning system for User-Account finished"
                fi
#cleaning     
                        yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"          
                        echo "removing install files, please enter your,"
                        rm -rf /opt/homebrew/Frameworks/ 
                        rm -rf /opt/homebrew/SECURITY.md
                        rm -rf /opt/homebrew/bin/
                        rm -rf /opt/homebrew/etc/
                        rm -rf /opt/homebrew/include/
                        rm -rf /opt/homebrew/lib/
                        rm -rf /opt/homebrew/opt/
                        rm -rf /opt/homebrew/sbin/
                        rm -rf /opt/homebrew/share/
                        rm -rf /opt/homebrew/var/
                        sudo rm -rf /opt/homebrew
                        sudo rm -rf "/${CP_INSTALL_DIR}"
                        exit 1
                        
#Mac INTEL -----------------------------------------------------------------------------
 else
    echo -e "Client Provisionin Setup $(system_profiler SPSoftwareDataType -detailLevel mini) starting..."
#install xcode, brew a. ansible
        echo "checking xcode..." 
        echo "after X-CODE installation, enter your "   
        xcode-select --install ||         
        sudo true     
            yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install openssl rust
            export CPPFLAGS=-I/usr/local/opt/openssl/include
            export LDFLAGS=-L/usr/local/opt/openssl/lib
        brew install ansible    
# create install dir
              if [ ! -d "${CP_INSTALL_DIR}" ]; then
                  sudo mkdir "${CP_INSTALL_DIR}"
              fi
                  git clone "${CP_URL} ${CP_INSTALL_DIR}"
# reset correct permissions
                  sudo chmod 775 "${CP_INSTALL_DIR}"
                  sudo chown "${CP_USER}" "${CP_INSTALL_DIR}"  
#run playbooks
          cd "$CP_PLAYBOOKS" &&
          if [[ $CP_USER == "it-support" ]]; then
            ansible-playbook mac_intel_admin.yml
            echo "provisioning system for Admin-Account finished"
          else
            ansible-playbook mac_user.yml
            echo "provisioning system for User-Account finished"
          fi
#cleaning

        yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" 
                       echo "removing install files, please enter your,"    
                       sudo rm -rf /usr/local/bin/
                       sudo rm -rf /usr/local/etc/
                       sudo rm -rf /usr/local/include/
                       sudo rm -rf /usr/local/lib/
                       sudo rm -rf /usr/local/opt/
                       sudo rm -rf /usr/local/sbin/
                       sudo rm -rf /usr/local/share/
                       sudo rm -rf /usr/local/var/
                       sudo rm -rf /usr/local/homebrew/
                       sudo rm -rf /usr/local/Cellar/
                       sudo rm -rf /usr/local/Frameworks/
                       sudo rm -rf "/${CP_INSTALL_DIR}"
                       exit 1
        fi
fi 
        
              

              

