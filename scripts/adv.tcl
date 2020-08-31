#Advert v1.0 Modifyed by HM2K, Original author unknown.

#Default is 5 (5 Mins per Advert MSG)
set advtime 5
#Channel to advertise in:
set advchan1 "#wares"
#set advchan2 "#"
#set advchan3 "#"
#set advchan4 "#"
#set advchan5 "#"

#Add adverts like so: "\002 HERE \002"
set advtext {
"- \002Your Advert Here!\002 - An advert can be a great way for you to get customers interested in your company, we accept all types of businesses, if you would like to advertise please \002/MSG HM2K for details\002"
"\002BlissWebSolutions\002: We are dedicated to bringing you the best services possible, including web design, IRC shells, web hosting, domain registration, email services, and a whole range of others. Why not check us out on \002http://www.BlissUK.net/\002 or join us in live chat at \002#BlissWebSolutions\002"
 }

#You don't need to edit anything else below here...
set advver "v1.0"
set notnick "$botnick" 
set notnick [string tolower ${nick}]
if {![info exists {advert}]} {
  global notnick advchan1 advchan2 advchan3 advchan4 advchan5 advtime advtext
  putlog "\002Advert\002 $advver is loaded"
  set advert 1
  timer ${advtime} advprint
 }
proc advprint {} {
  global notnick advchan1 advchan2 advchan3 advchan4 advchan5 advtime advtext
  set advmsg [lindex $advtext [rand [llength $advtext]]]
  if {[info exists {advchan1}]} { putserv "PRIVMSG $advchan1 : $advmsg" }
  if {[info exists {advchan2}]} { putserv "PRIVMSG $advchan2 : $advmsg" }
  if {[info exists {advchan3}]} { putserv "PRIVMSG $advchan3 : $advmsg" }
  if {[info exists {advchan4}]} { putserv "PRIVMSG $advchan4 : $advmsg" }
  if {[info exists {advchan5}]} { putserv "PRIVMSG $advchan5 : $advmsg" }
  timer ${advtime} advprint
 }
