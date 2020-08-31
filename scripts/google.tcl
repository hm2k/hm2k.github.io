#google.tcl v0.22 - Returns the value of the "I feel lucky" function on google for websites and images via triggers
#based on scripts by aNa|0Gue
set googlever "0.22"

#Simulate a browser, ie: Mozilla
set agent "MSIE 6.0"

package require http

bind pub - !google pub:google
bind pub - !image pub:image

proc pub:google { nick uhost handle channel arg } {
 global agent
	if {[llength $arg]==0} {
		putserv "PRIVMSG $channel :$nick, Google Usage: !google <string>"
	} else {
		set query "http://www.google.com/search?btnI=&q="
		for { set index 0 } { $index<[llength $arg] } { incr index } {
			set query "$query[lindex $arg $index]"
			if {$index<[llength $arg]-1} then {
				set query "$query+"
			}
		}
		#putserv "PRIVMSG $channel :$query"
                set token [http::config -useragent $agent]
		set token [http::geturl $query]
		puts stderr ""
		upvar #0 $token state
		set max 0
		foreach {name value} $state(meta) {
			if {[regexp -nocase ^location$ $name]} {
				set newurl [string trim $value]
				putserv "PRIVMSG $channel :$nick, Google Search: $newurl"
			}
		}
	}
}

proc pub:image { nick uhost handle channel arg } {
 global agent
	if {[llength $arg]==0} {
		putserv "PRIVMSG $channel :$nick, Google Image Usage: !image <string>"
	} else {
		set query "http://images.google.com/images?btnI=&q="
		for { set index 0 } { $index<[llength $arg] } { incr index } {
			set query "$query[lindex $arg $index]"
			if {$index<[llength $arg]-1} then {
				set query "$query+"
			}
		}
		append query &imgsafe=off
		#putserv "PRIVMSG $channel :$query"
                set token [http::config -useragent $agent]
		set token [http::geturl $query]
		puts stderr ""
		upvar #0 $token state
		set max 0
		foreach {name value} $state(meta) {
			if {[regexp -nocase ^location$ $name]} {
				set starturl "http://"
				set newurl [string trim $value]
				set newurl [string range $newurl [expr [string first = $newurl]+1] [expr [string first & $newurl]-1]]
				append starturl $newurl
				putserv "PRIVMSG $channel :$nick, Google Image: $starturl"
			}
		}
	}
}

putlog "google.tcl $googlever loaded"
