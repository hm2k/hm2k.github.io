#!/bin/sh
clear
echo "eggconf by HM2K (c) 2004"
echo "Please run this script from your eggdrop directory"
echo "This script will automatically configure your eggdrop"

confirm=0
while [ "$confirm" != "y" -a "$confirm" != "n"  ]
do
	echo "Do you want to continue? (y/n)"
	read confirm
done
while [ "$confirm" == "n" ]
do
	exit 0
done
#User data input
if [ -e eggdrop.conf ]; then
	mv eggdrop.conf eggdrop.conf.orig
fi
echo "Bot Nick?"
read botnick
while [ "$botnick" == "" ]
do
	echo "Botnick (cannot be blank)"
	read botnick
done
echo "Bot's listen port (the port where you will telnet)"
read  port
while [ "$port" == "" ]
do
	echo "Listen port(cannot be blank)"
	read port
done
#set ipv4
echo "Please enter your IP here."
read ip4
#set ipv6
echo "If you are using IPv6, enter it here, otherwise leave this blank."
read ip6
echo "Your main Channels? (with the # ex: #channel)"
countch=0
eval read  channel$countch
ok=`eval echo 'channel'$countch`
while [ "$ok" == "" ]
do
	echo "channel (cannot be blank)"
	eval read channel$countch
	ok=`eval echo '$channel'$countch`
done
confirm=0
while [ "$confirm" != "y" -a "$confirm" != "n"  ]
do
	echo "Other channels? (y/n)"
	read confirm
done
while [ "$confirm" == "y" ]
do
	echo "type an other channel"
	countch=`expr $countch + 1`
	eval read channel$countch
	ok=`eval echo '$channel'$countch`
	while [ "$ok" == "" ]
	do
	echo "Channel (cannot be blank)"
	eval read channel$countch
	ok=`eval echo '$channel'$countch`
	done
	confirm=0
	while [ "$confirm" != "y" -a "$confirm" != "n" ]
	do
	echo "Other channel? (y/n)"
	read confirm
done
done
#servers
echo "IRC servers (irc.efnet.net or irc.efnet.net:port)"
count=0
eval read server$count
ok=`eval echo '$server'$count`
while [ "$ok" == "" ]
do
	echo "Server (cannot be blank)"
	eval read server$count
	ok=`eval echo '$server'$count`
done
confirm=0
while [ "$confirm" != "y" -a "$confirm" != "n" ]
do
echo "Other server? (y/n)"
read confirm
done
while [ "$confirm" == "y" ]
do
echo "type other server"
count=`expr $count + 1`
eval read server$count
ok=`eval echo '$server'$count`
while [ "$ok" == "" ]
do
	echo "Server (cannot be blank)"
	eval read server$count
	ok=`eval echo '$server'$count`
done
confirm=0
while [ "$confirm" != "y" -a "$confirm" != "n" ]
do
echo "Other server? (y/n)"
read confirm
done
done


#basic modules
echo "loadmodule channels" >> eggdrop.conf
echo "set mod-path \"modules/\"" >> eggdrop.conf
echo "loadmodule dns" >> eggdrop.conf
echo "loadmodule server" >> eggdrop.conf
echo "loadmodule ctcp" >> eggdrop.conf
echo "loadmodule irc" >> eggdrop.conf
echo "loadmodule notes" >> eggdrop.conf
echo "loadmodule console" >> eggdrop.conf
echo "loadmodule blowfish" >> eggdrop.conf
echo "loadmodule uptime" >> eggdrop.conf
#set username
echo "set username \"$botnick\"" >> eggdrop.conf
#set admin
echo "set admin \"$botnick <email: $botnick@eggheads.org>\"" >> eggdrop.conf
#set network
echo "set network \"$net\"" >> eggdrop.conf
#set time zone
echo "set timezone \"$zone\""
#set user, notes and chan files
echo "set userfile \"$botnick.user\"" >> eggdrop.conf
echo "set chanfile \"$botnick.chan\"" >> eggdrop.conf
set "notefile \"$botnick.notes\"" >> eggdrop.conf
#set listen port
echo "listen $port all" >> eggdrop.conf
#set nick
echo "set nick \"$botnick\"" >> eggdrop.conf
echo "set altnick \"$botnick?\"" >> eggdrop.conf
#set ipv4
echo "set my-ip \"$ipv4\""  >> eggdrop.conf
#set ipv6
echo "set my-ip6 \"$ip6\""  >> eggdrop.conf
#set servers
echo "set servers {" >> eggdrop.conf
for (( i=0 ; i <= $count ; i++ ))
do
eval echo '$server'$i >> eggdrop.conf
done
echo "}" >> eggdrop.conf
#set Channel
for (( i=0 ; i <= $countch ; i++ ))
do
channel=`eval echo '$channel'$i`
echo "channel add $channel {" >> eggdrop.conf
echo "chanmode \"+nt\"" >> eggdrop.conf
echo "}" >> eggdrop.conf
done
#set log file
echo "logfile mcso * \"logs/$botnick.log\"" >> eggdrop.conf
echo "set log-time 1" >> eggdrop.conf
echo "set switch-logfiles-at 300" >> eggdrop.conf
#file stuff
echo "set help-path \"help/\"" >> eggdrop.conf
echo "set text-path \"text/\"" >> eggdrop.conf
echo "set temp-path \"/tmp\"" >> eggdrop.conf
echo "set motd \"text/motd\"" >> eggdrop.conf
echo "set telnet-banner \"text/banner\"" >> eggdrop.conf
echo "set userfile-perm 0600" >> eggdrop.conf
#bot stuff
echo "set remote-boots 2" >> eggdrop.conf
echo "set share-unlinks 1" >> eggdrop.conf
echo "set ident-timeout 5" >> eggdrop.conf
echo "set answer-ctcp 3" >> eggdrop.conf
echo "set server-cycle-wait 60" >> eggdrop.conf
echo "set server-timeout 60" >> eggdrop.conf
echo "set serverror-quit 1" >> eggdrop.conf
echo "set bounce-bans 1" >> eggdrop.conf
#tcl stuff
echo "source scripts/alltools.tcl" >> eggdrop.conf
echo "source scripts/action.fix.tcl" >> eggdrop.conf
echo "source scripts/userinfo.tcl" >> eggdrop.conf
echo "loadhelp userinfo.help" >> eggdrop.conf
#other stuff
echo "set max-notes 50" >> eggdrop.conf
echo "set note-life 60" >> eggdrop.conf
echo "set notify-onjoin 1" >> eggdrop.conf
echo "set console-autosave 1" >> eggdrop.conf
./eggdrop -m eggdrop.conf
