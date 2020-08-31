#!/usr/local/bin/bash
#requires: cd /usr/ports/net-mgmt/ipv6calc && make && make install

#colours
BOLD="\033[1m"
NORMAL="\033[0;0m"
END="\033[30;47;0m"
BLACK="\033[0;30m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RED="\033[0;31m"
PURPLE="\033[0;35m"
BROWN="\033[0;33m"
GREY="\033[0;37m"
DARK_GREY="\033[1;30m"
LIGHT_BLUE="\033[1;34m"
LIGHT_GREEN="\033[1;32m"
LIGHT_CYAN="\033[1;36m"
LIGHT_RED="\033[1;31m"
LIGHT_PURPLE="\033[1;35m"
YELLOW="\033[1;33m"
WHITE="\033[1;37m"

#code
echo -e "${WHITE}IP:${NORMAL}	 		${WHITE}Hostname:${NORMAL}"
if [ "$(uname)" = "Linux" ]; then
 for ip in $(/sbin/ifconfig | grep inet | grep -v 127.0.0.1 | cut -d: -f2 | cut -d" " -f1 | cut -d"inet" -f1); do
  if ! host $ip 2>/dev/null >/dev/null; then
   echo -e "${GREY}$ip${NORMAL}	-	${YELLOW}no reverse setup${NORMAL}"
  else
   echo -e "${GREY}$ip${NORMAL}	-	${PURPLE}$(host $ip | cut -d" " -f5-)${NORMAL}"
  fi
 done
elif [ "$(uname)" = "FreeBSD" ]; then
 for ip in $(/sbin/ifconfig | grep inet | grep -v 127.0.0.1 | grep -v inet6 | cut -d" " -f2 | cut -d"inet" -f1); do
  echo -e "${GREY}$ip${NORMAL}	-	${PURPLE}$(host $ip | cut -d" " -f5-)${NORMAL}"
 done
fi

##--ipv6
#for n in `ifconfig vr0|grep inet6|grep -v scopeid|awk {'print $2'}`;do tmp6=`ipv6calc --in ipv6addr --out revnibbles.int $n`;host -t ptr $tmp6 2>/dev/null|echo -e "${GREY}$n${NORMAL} ${PURPLE}`awk {'print $5'}`${NORMAL}";unset tmp6;done;