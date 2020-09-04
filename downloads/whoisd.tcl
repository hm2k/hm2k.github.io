#whoisd.tcl v1.0.2 by HM2K - domain whois and tld country lookup !whois and !tld

### Description:
## I have tried a lot of existing domain whois scripts, none of them did what I wanted.
## So I decided to write my own, based on a similar script I wrote for mIRC.
## 
### Usage:
## The whois command (!whoisd) offers the ability to check if domain is available or taken.
## The tld command (!tld) offers the ability to see which country owns an entered tld.
## The tld command is similar to the !country commands, however the tld uses live servers so is never outdated.
## The commands can also be triggered inside DCC, where all full domain whois records are displayed.
##
### Credits:
## thanks to #eggtcl @ EFnet for some pointers
##

set whoisdver "1.0.2"

#the dcc command - eg: whoisd <domain>
set whoisd(cmd_dcc) "whoisd"

#the pub command - eg: !whoisd <domain>
set whoisd(cmd_pub) "!whoisd"

#the dcc tld command - eg: tld <tld>
set whoisd(cmd_tlddcc) "tld"

#the pub tld command - eg: !tld <tld>
set whoisd(cmd_tldpub) "!tld"

#flag required to use the script
set whoisd(flag) "-|-"

#The main whois server - should not change
set whoisd(server) "whois.iana.org"

#The default whois server port - should not change
set whoisd(port) "43"

#server timeout - servers are quick, keep low
set whoisd(timeout) "5"

#reply mode
#0 - Private message to the channel
#1 - Notice to the channel
#2 - Private message to the nick
#3 - Notice to the nick
set whoisd(rplmode) "0"

#prefix on output
set whoisd(prefix) "whois:"
#set whoisd(prefix) "\002$::whoisd(prefix)\002"

if {![string match 1.6.* $version]} { putlog "\002WARNING:\002 This script is intended to run on eggdrop 1.6.x or later." }
if {[info tclversion] < 8.2} { putlog "\002WARNING:\002 This script is intended to run on Tcl Version 8.2 or later." }

bind dcc $whoisd(flag) $whoisd(cmd_dcc) whoisd:dcc
bind pub $whoisd(flag) $whoisd(cmd_pub) whoisd:pub
bind dcc $whoisd(flag) $whoisd(cmd_tlddcc) whoisd:tlddcc
bind pub $whoisd(flag) $whoisd(cmd_tldpub) whoisd:tldpub

proc whoisd:dcc {hand idx text} {
	if {[string compare [set word [lrange [split $text] 0 0]] ""] == 0} { putdcc $idx "$::whoisd(prefix) Usage: .$::whoisd(cmd_dcc) <domain>" ; return }
	if {![regexp {^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$} $word]} { putdcc $idx "$::whoisd(prefix) Error: Invalid Domain." ; return }
	whoisd:connect 0 $idx {} $::whoisd(server) $::whoisd(port) $word
}
proc whoisd:pub {nick uhost hand chan text} {
	if {[string compare [set word [lrange [split $text] 0 0]] ""] == 0} { putserv "NOTICE $nick :$::whoisd(prefix) Usage: $::whoisd(cmd_pub) <domain>" ; return }
	if {![regexp {^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$} $word]} { putserv "NOTICE $nick :$::whoisd(prefix) Error: Invalid Domain." ; return }
	whoisd:connect 1 $chan $nick $::whoisd(server) $::whoisd(port) $word
}
proc whoisd:tlddcc {hand idx text} {
	if {[string compare [set word [lrange [split $text] 0 0]] ""] == 0} { putdcc $idx "$::whoisd(prefix) Usage: .$::whoisd(cmd_tlddcc) <tld>" ; return }
	if {[string index $word 0] != "."} { putdcc $idx "$::whoisd(prefix) Error: Invalid TLD." ; return }
	whoisd:connect 0 $idx {} $::whoisd(server) $::whoisd(port) $word
}
proc whoisd:tldpub {nick uhost hand chan text} {
	if {[string compare [set word [lrange [split $text] 0 0]] ""] == 0} { putserv "NOTICE $nick :$::whoisd(prefix) Usage: $::whoisd(cmd_tldpub) <tld>" ; return }
	if {[string index $word 0] != "."} { putserv "NOTICE $nick :$::whoisd(prefix) Error: Invalid TLD." ; return }
	whoisd:connect 1 $chan $nick $::whoisd(server) $::whoisd(port) $word
}
proc whoisd:out {type dest nick text} {
	if {[string length [string trim $text]] < 1} { return }
	if {!$type} { putdcc $dest "$::whoisd(prefix) $text" ; return }
	switch -- $::whoisd(rplmode) {
		"0" { putserv "PRIVMSG $dest :$::whoisd(prefix) $text" }
		"1" { putserv "NOTICE $dest :$::whoisd(prefix) $text" }
		"2" { putserv "PRIVMSG $nick :$::whoisd(prefix) $text" }
		"3" { putserv "NOTICE $nick :$::whoisd(prefix) $text" }
	}
}
proc whoisd:connect {type dest nick server port word} {
	if {[catch {socket -async $server $port} sock]} { whoisd:out $type $dest $nick "Error: Connection to $server:$port failed." ; return }
	fileevent $sock writable [list whoisd:write $type $dest $nick $word $sock $server $port [utimer $::whoisd(timeout) [list whoisd:timeout $type $dest $nick $server $port $sock $word]]]
}
proc whoisd:write {type dest nick word sock server port timerid} {
	if {[set error [fconfigure $sock -error]] != ""} {
		whoisd:out $type $dest $nick "Connection to $::whoisd(server) failed."
		whoisd:die $sock $timerid
		return
	}
	set lookup $word
	if {$server == $::whoisd(server)} { set lookup [lrange [split $word "."] end end] }
	puts $sock "$lookup\n"
	flush $sock
	fconfigure $sock -blocking 0
	fileevent $sock readable [list whoisd:read $type $dest $nick $word $sock $server $port $timerid]
	fileevent $sock writable {}
}
proc whoisd:read {type dest nick word sock server port timerid} {
	while {![set error [catch {gets $sock output} read]] && $read > 0} {
		if {$server == $::whoisd(server)} {
				if {[regexp {(not found)} $output]} {
					set output "Error: Invalid TLD."
					whoisd:out $type $dest $nick $output
					whoisd:die { $sock $timerid }
				}
				if {[string index $word 0] == "." || ![string match *.* $word]} {
						if {[regexp {Country: (.*)$} $output -> country]} {
							whoisd:out $type $dest $nick "$word is $country"
							whoisd:die { $sock $timerid }		
						}
				}
				if {[regexp {Whois Server \(port (.*?)\): (.*)$} $output -> port server]} {
					whoisd:connect $type $dest $nick $server $port $word
					whoisd:die { $sock $timerid }
				}
				if {[regexp {URL for registration services: (.*)$} $output -> url]} {
				#do nothing atm
				}
		} else {
			if {[regexp -nocase {No match|not found|Invalid query|does not exist|no data found|status:         avail|domain is available|(null)|no entries found|not registered|no objects found|domain name is not} $output]} { 
				whoisd:out $type $dest $nick "$word is available!"
				whoisd:die $sock $timerid
			}
		}
	if {!$type} { whoisd:out $type $dest $nick $output }
	if {$error} {
		whoisd:out $type $dest $nick "Error: Connection to server has been lost."
		whoisd:die $sock $timerid
	}
 }
}
proc whoisd:die {sock timerid} {
		catch { close $sock }
		catch { killutimer $timerid }
}
proc whoisd:timeout {type dest nick server port sock word} {
	catch { close $sock }
	#whoisd:out $type $dest $nick "Connection to $server:$port timed out."
	if {$server != $::whoisd(server)} { whoisd:out $type $dest $nick "$word is taken!" }
}

putlog "whoisd.tcl $whoisdver loaded"
