#!/bin/bash

red="\e[31m"
end="\e[0m"
green="\e[32m"

function chk_req()
{
	if ! dpkg -s cmake >/dev/null 2>&1; then
        	echo -e "cmake >> $red Not installed $end"
		sudo apt-get install cmake
	else
        	echo -e "cmake >> $green Installed $end"
	fi

	if ! dpkg -s build-essential >/dev/null 2>&1; then
		echo -e "build-essentials >> $red Not installed $end"
		sudo apt-get install build-essential
	else
		echo -e "build-essentials >> $green Installed $end"
	fi

	if ! dpkg -s zlib1g-dev >/dev/null 2>&1; then
		echo -e "zlib1g-dev >> $red Not installed $end"
		sudo apt-get install zlib1g-dev
	else
		echo -e "zlib1g-dev >> $green Installed $end"
        fi
	
	if ! dpkg -s m4 >/dev/nul 2>&1; then
		echo -e "m4 >> $red Not installed $end"
                sudo apt-get install m4
        else
                echo -e "m4 >> $green Installed $end"
        fi

	if ! dpkg -s libboost-all-dev >/dev/nul 2>&1; then
                echo -e "libboost >> $red Not installed $end"
                sudo apt-get install libboost-all-dev
        else
                echo -e "libboost >> $green Installed $end"
        fi
	
	sleep 2
	echo -e "All The Requirements have Been Installed. Continuing Installation... "
}

function chk_fp(){
	if [ `whoami` != 'root' ]; then
	       echo -e "\n$red""This Scripts Requires Root Permission.\nRun Script With sudo. $end"
       		sleep 2
 		exit 0
	fi

	if [ ! -f 'CMakeLists.txt' ]	; then
		echo -e "$red""\nCMakeLists.txt file not found...\n $end"
		echo -e "Please contact me for instalation guide."
		sleep 2
		exit 0
	else
		echo -e "$green""\nCMakeLists.txt file found.\nContinuing Installation...\n $end"
	sleep 2
	fi
	
	echo -e "\nChecking Requirements...."
	chk_req
}

function veriy_install()
{
	path_prefix="/usr/local/lib/"
	count=0
	while IFS= read -r line
	do
		if [ -f "$path_prefix$line" ]; then
			echo -e "$line >> $green Installed$end"
			((count++))
		else
			echo -e "$line >> $red Not Found$end"
		fi
	done < req.txt
	echo -e "\n$count/60 installed"
}

function main()
{
	chk_fp
	echo -e "\nGenerating Makefile...\n"
	cmake CMakeLists.txt
	sleep 2
	if [ ! -f Makefile ]; then
		echo -e "$red""Configuring & Generating Makefile Failed!!!$end"
		sleep 2
		exit 0
	else
		echo -e "$green""Makefile generated successfully$end"
		echo -e "\n\n******Beginning Building dyninst******\n"
		sudo make && sudo make install
	fi
	echo -e "$green""\nDyninst build succesfull$end\n\n"
	read -p "verify dyninst build status[y/n]" verify
	if [ $verify == 'y' ] || [ $verify == 'Y' ]; then
		if [ -d '/usr/local/lib/cmake/Dyninst' ]; then
				if [ -f 'req.txt' ]; then
					veriy_install
					sleep 2
				else
					echo -e "\n$red""req.txt file not found!!!!$end"
					echo -e "\n$red""build verification failed.$end"
					exit 0
				fi
				echo -e "$green""\nDyninst Build Verified successfully$end"
		else
				echo -e "$red""\nDyinst build couldnt be verified please reinstall$end"
		fi
	else
		echo -e "\nTask Completed"
	fi

}

main
