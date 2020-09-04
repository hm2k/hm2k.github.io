#Channel Advert v1.2 by HM2K

### Allows you to advertise across many channels, usually used in large channels or shell channels.

set adv(ver) "v1.2"

#Time delay between advert messages. (in minutes)
set adv(time) 5

#Channels to advertise in:
set adv(chans) "#serialz #newserialz"

#advert text
set adv(text) {
	"- \002Your Advert Here!\002 - An advert can be a great way for you to get people interested in your company/channel/website, we accept all types, if you would like to advertise please \002/MSG HM2K for details\002"
	"\002My Company\002: Details about your company here!"
}

### NO FURTHER EDITING IS REQUIRED ###

if {![info exists {advert_timer}]} {
  set advert_timer 1
  timer ${adv(time)} adv:print
 }
proc adv:print {} {
	global adv
  set adv_msg [lindex $adv(text) [rand [llength $adv(text)]]]
  foreach adv_chan $adv(chans) {
  	if {[info exists {adv_chan}]} { putserv "PRIVMSG $adv_chan :$adv_msg" }
  }
  timer ${adv(time)} adv:print
}

putlog "\002Advert Script\002 $adv(ver) is loaded"