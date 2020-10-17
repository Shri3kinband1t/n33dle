#!/bin/bash

Red='\033[0;31m'
NC='\033[0m'
Green='\033[0;32m'
Blue='\033[0;34m'
Black='\033[0;30m'
cdate= date -I
function roottest() {
  ROOT_UID=0
  if [ "$UID" -eq "$ROOT_UID" ]
  then
    echo -e "${Green}RootCheck Good${NC}"
  else
    echo -e "${Red}ROOTFAIL${NC}"
    exit 0
  fi }
roottest
function InternetTest() {
  if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo -e "${Green}Internet Test Success${NC}"
    internet="y"
  else
    echo -e "${Red}Internet Connection Unavailable${NC}"
    internet= "n"
  fi
}



function maint() {
  echo -e "$Black"
  InternetTest
  if [ $internet="y" ]
  then
    apt-get update -qq
    apt-get upgrade -qq
  fi
  aircrack-ng
  if [ $? -eq 0 ]
  then
    echo "Aircrack Found"
  else
    echo -e "${Red}Aircrack-ng Not Installed${NC}"
    if [ $internet="y" ]; then
      echo -e "${Red}Trying to install Aircrack-ng${NC}"
      apt-get install aircrack-ng -y
      if [ $? -eq 0 ]
      then
        echo -e "${Green}Aircrack-ng Install Success!${NC}"
      fi
    fi
  fi
 echo -e "${Green}Maintenance Finished ${NC}"
}

function init() {
echo -e "$Red"
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
echo -e "$Black"
read -t 45 -N 4 initcode

if [ $initcode = "1122" ]
then
  echo -e "$NC"
else
  init
fi }

init

function mainmenu(){
echo -e "$Red"
cat << "EOF"

UUUU - Jam All Wifi and Monitor       LLLL - BT

DDDD - Just Monitor                   RRRR - BT

DUDU - Fake AP                        LRLR - BT

UDUD - InteractiveHcker               RLRL - BT

DDUU - who knows                      LLRR - BT

DLRU - Maintenance                    RULD - Shutdown Now

EOF

echo -e "$Black"
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
      end = "y"
    fi
    runtime+=1
    clear
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
mainmenu

}

mainmenu
