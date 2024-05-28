#!/bin/bash

# ASCII Banner
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}"
cat << "EOF"

 _____ ______   _______  _________  ________  ________  ________  ___       ________  ___  _________        ________ ___     ___    ___         
|\   _ \  _   \|\  ___ \|\___   ___\\   __  \|\   ____\|\   __  \|\  \     |\   __  \|\  \|\___   ___\     |\  _____\\  \   |\  \  /  /|        
\ \  \\\__\ \  \ \   __/\|___ \  \_\ \  \|\  \ \  \___|\ \  \|\  \ \  \    \ \  \|\  \ \  \|___ \  \_|     \ \  \__/\ \  \  \ \  \/  / /        
 \ \  \\|__| \  \ \  \_|/__  \ \  \ \ \   __  \ \_____  \ \   ____\ \  \    \ \  \\\  \ \  \   \ \  \       \ \   __\\ \  \  \ \    / /         
  \ \  \    \ \  \ \  \_|\ \  \ \  \ \ \  \ \  \|____|\  \ \  \___|\ \  \____\ \  \\\  \ \  \   \ \  \       \ \  \_| \ \  \  /     \/          
   \ \__\    \ \__\ \_______\  \ \__\ \ \__\ \__\____\_\  \ \__\    \ \_______\ \_______\ \__\   \ \__\       \ \__\   \ \__\/  /\   \          
    \|__|     \|__|\|_______|   \|__|  \|__|\|__|\_________\|__|     \|_______|\|_______|\|__|    \|__|        \|__|    \|__/__/ /\ __\         
                                                \|_________|                                                                |__|/ \|__|         
                                                                                                                                                
                                                                                                                                                
        ________      ___    ___      ___  _________  ________                 ___  ___  ________  ___  _________  ___  ___  __    ________     
       |\   __  \    |\  \  /  /|    |\  \|\___   ___\\   ____\               |\  \|\  \|\   __  \|\  \|\___   ___\\  \|\  \|\  \ |\   __  \    
       \ \  \|\ /_   \ \  \/  / /    \ \  \|___ \  \_\ \  \___|_  ____________\ \  \\\  \ \  \|\  \ \  \|___ \  \_\ \  \ \  \/  /|\ \  \|\  \   
        \ \   __  \   \ \    / /      \ \  \   \ \  \ \ \_____  \|\____________\ \   __  \ \   _  _\ \  \   \ \  \ \ \  \ \   ___  \ \   __  \  
         \ \  \|\  \   \/  /  /        \ \  \   \ \  \ \|____|\  \|____________|\ \  \ \  \ \  \\  \\ \  \   \ \  \ \ \  \ \  \\ \  \ \  \ \  \ 
          \ \_______\__/  / /           \ \__\   \ \__\  ____\_\  \              \ \__\ \__\ \__\\ _\\ \__\   \ \__\ \ \__\ \__\\ \__\ \__\ \__\
           \|_______|\___/ /             \|__|    \|__| |\_________\              \|__|\|__|\|__|\|__|\|__|    \|__|  \|__|\|__| \|__|\|__|\|__|
                    \|___|/                             \|_________|                                                                            
                                                                                                                                                
                                                                                                                                                
EOF

echo -e "${NC}"
# Check if running with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script needs to be run with sudo privileges."
    read -p "Do you want to escalate? (y/n): " choice
    if [ "$choice" == "y" ]; then
        sudo "$0" "$@"  # Execute this script with sudo
    else
        echo "Script execution aborted."
        exit 1
    fi
fi

echo "Running with sudo privileges!"

echo "Fetching ZipAlign..."

fixing_zipalign() 
	{
    		wget http://ftp.de.debian.org/debian/pool/main/a/android-platform-build/zipalign_8.1.0+r23-2_amd64.deb
    		chmod +x zipalign_8.1.0+r23-2_amd64.deb
    		sudo apt install ./zipalign_8.1.0+r23-2_amd64.deb -y
    		echo "ZipAlign Installed Succesfully..."
	}

echo "Fetching ApkTool"

fixing_apktool() 
	{
    		wget https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar
    		mv apktool_2.9.3.jar apktool
		sudo rm /usr/bin/apktool
		sudo mv apktool /usr/bin
		cd /usr/bin
		sudo chmod +x apktool
	}

echo "Cleaning Up...." 

clean_up()
	{
		rm zipalign_8.1.0+r23-2_amd64.deb
		rm *.jar
	}

echo "Done !"
# Function Calls
fixing_zipalign
fixing_apktool
clean_up
