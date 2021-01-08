#!/bin/bash
# n33dle is a framework for calling basic attacks.

#### Global Variables ####
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BLACK='\033[0;30m'
TODAY=`date -I`

#### Function Definition start ####

# Ensure the script is running as root.
function roottest() {
  ROOT_UID=0
  if [ "$UID" -eq "$ROOT_UID" ]
  then
    echo -e "${GREEN}RootCheck Good${NC}"
  else
    echo -e "${RED}ROOTFAIL${NC}"
    exit 0
  fi }

function InternetTest() {
  if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo -e "${GREEN}Internet Test Success${NC}"
    internet="y"
  else
    echo -e "${RED}Internet Connection Unavailable${NC}"
    internet= "n"
  fi
}

function maint() {
  echo -e "$BLACK"
  InternetTest
  if [ $internet="y" ]
  then
    apt-get update -qq
    apt-get upgrade -qq
    mkdir /home/pi/scriptuse
    cd /home/pi/scriptuse
    rm -r n33dle
    git clone https://github.com/shri3kinband1t/n33dle # check to see if git exists first as a binary
    mv n33dle/n33dle.sh /bin/x #dangerous - check to see if 'x' exists first
    chmod 777 /bin/x

  fi
  aircrack-ng # safer to do a 'which aircrack-ng and look at the return code from that instead
  if [ $? -eq 0 ]
  then
    echo "Aircrack Found"
  else
    echo -e "${RED}Aircrack-ng Not Installed${NC}"
    if [ $internet="y" ]; then
      echo -e "${RED}Trying to install Aircrack-ng${NC}"
      apt-get install aircrack-ng -y
      if [ $? -eq 0 ]
      then
        echo -e "${GREEN}Aircrack-ng Install Success!${NC}"
      fi
    fi
  fi
 echo -e "${GREEN}Maintenance Finished ${NC}"
}

function init() {
	echo -e "$RED"
	cat << "EOF"

                 :::!~!!!!!:.
             .xUHWH!! !!?M88WHX:.
           .X*#M@$!!  !X!M$$$$$$WWx:.
          :!!!!!!?H! :!$!$$$$$$$$$$8X:
         !!~  ~:~!! :~!$!#$$$$$$$$$$8X:
        :!~::!H!<   ~.U$X!?R$$$$$$$$MM!
        ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!
         !:~~~ .:!M"T#$$$$WX??#HAHAMM!
          ~?WuxiW*`   `"#$$$$8!!!!??!!!
        :X- M$$$$        `"T#$T~!8$WUXU~
       :%`  ~#$$$m:        ~!~ ?$$$$$$
     :!`.-   ~T$$$$8xx.  .xWW- ~""##*"
   -~~:<` !    ~?T#$$@@W@*?$$      /`
!!! .!~~ !!     .:XUW$W!~ `"~:    :
.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`
!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~
 :X@!.-~   ?@WTWo("*$$$W$TH$! `
X$?!-~    : ?$$$B$Wu("**$RM!
~ !     :   ~$$$$$B$$en:`` [UUDD]
?x.~    :     ~"##*$$$$M~  to init
EOF
	echo -e "$BLACK"
	read -t 45 -N 4 initcode

	if [ $initcode = "1122" ]
	then
  		echo -e "$NC"
	else
  		init
	fi 
}

function mainmenu(){
	echo -e "$RED"
	cat << "EOF"

_   _  _____  _____     _ _
| \ | ||____ ||____ |   | | |
|  \| |    / /    / / __| | | ___
| . ` |    \ \    \ \/ _` | |/ _ \
| |\  |.___/ /.___/ / (_| | |  __/
\_| \_/\____/ \____/ \__,_|_|\___|
<< Use Unresponsibly! >>
Github.com/shri3kinband1t/n33dle
UUUU - Jam All Wifi and Monitor
  DDDD - Just Monitor
DUDU - Fake AP
  DDUU - who knows
DLRU - Maintenance
  RULD - Shutdown Now
EOF

	echo -e "$BLACK"
	read -N 4 menupick
	echo -e "$NC"

	if [ $menupick = "1111" ]
		then
  			echo "starting"
  			systemctl start mon.service
  			systemctl start deauther.service
  			end="n"
  			declare -i runtime
  			runtime=0
  			while [ $end = "n" ]
  				do
    			echo "[DUDU] to end"
    			echo "Runtime = $runtime minutes"
    			read -t 60 -n 4 endcode
    			if [ $endcode = "2121" ]
    				then
      			systemctl stop deauther.service
      			systemctl stop mon.service
      			end="y"
    			else
      			runtime+=1
      			clear
    			fi
  			done
	fi

	if [ $menupick = "2341" ]
		then
  		maint
	fi

	if [ $menupick = "4132" ]
		then
  			shutdown now
	fi

# mainmenu # this sort of recursion might cause you problems in the future.

}
#### End function definitions ####

#### running code loops ####

# make sure script runs as root
roottest

# Call the init function
init

# Safer way to keep the menu as the main system
while (1) 
do
	mainmenu
done
