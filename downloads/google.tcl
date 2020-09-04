#google.tcl v0.3 - Returns the value of the "I feel lucky" function on google for websites and images via triggers
#based on scripts by aNa|0Gue

set google(ver) "0.3"

#Simulate a browser, ie: Mozilla
set google(agent) "MSIE 6.0"

#google search trigger
set google(g_cmd) "!google"

#google uk search trigger
set google(guk_cmd) "!googleuk"

#google image search trigger
set google(gi_cmd) "!image"

#google prefix
set google(prefix) "* Google:"

package require http

bind pub - $google(g_cmd) pub:google
bind pub - $google(guk_cmd) pub:googleuk
bind pub - $google(gi_cmd) pub:image

proc pub:google { nick uhost handle channel arg } {

}

proc google:go { url arg } {
	global google
	regsub -all " " $arg "+" query
	set lookup "$url$query"
  set token [http::config -useragent $google(agent)]
	set token [http::geturl $lookup]
	puts stderr ""
	upvar #0 $token state
	set max 0
	foreach {name value} $state(meta) {
		if {[regexp -nocase ^location$ $name]} {
			set newurl [string trim $value]
			regsub -all "btnI=&" $url "" url
			return "$newurl More: $url$query"
		}
	}
}

proc pub:google { nick uhost handle channel arg } {
	global google
	if {[llength $arg]==0} { putserv "NOTICE $nick :Usage: $google(g_cmd) <string>" }
	set url "http://www.google.com/search?btnI=&q="
	set output [google:go $url $arg]
	putserv "PRIVMSG $channel :$nick, $google(prefix) $output"
}

proc pub:googleuk { nick uhost handle channel arg } {
	global google
	if {[llength $arg]==0} { putserv "NOTICE $nick :Usage: $google(guk_cmd) <string>" }
	set url "http://www.google.co.uk/search?btnI=&q="
	set output [google:go $url $arg]
	putserv "PRIVMSG $channel :$nick, $google(prefix) $output"
}

proc pub:image { nick uhost handle channel arg } {
	global google
	if {[llength $arg]==0} { putserv "NOTICE $nick :Usage: $google(gi_cmd) <string>" }
	set url "http://images.google.com/images?btnI=&q="
	set output [google:go $url $arg]
	putserv "PRIVMSG $channel :$nick, $google(prefix) $output"
}

putlog "google.tcl $google(ver) loaded"