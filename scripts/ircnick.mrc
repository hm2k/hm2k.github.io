.oO{ IRCNick v0.52 by HM2K }Oo. - IRC@HM2K.ORG
;ircnick.com no longer exists, this script was abandoned.

;Description:
;Ever wanted to know more information about a user, without going through the process of asking them, well ircnick.com provide a database of irc users, which allows you to quickly and easily lookup a nick, this mIRC script allows you to take advantage of this. You can simply input the nick, and it will return their info right into mIRC. This script comes with a popup and optional triggers.

;Installation: Make sure ircnick.mrc is in your $mircdir then type: /load -rs ircnick.mrc

;Usage: /ircnick <nick>
;There is also a popup menu

;IRCnick v0.52 - Minor changes, echo no longer add to log files
;IRCnick v0.5 - Major bugs fixed, quicker nick lookup.
;IRCnick v0.2 - More error checking, output bug fix, image support
;IRCnick v0.11 - Bugs fixed, menu added, extra options, more error checking
;IRCnick v0.1 - Original release, nothing special, a few bugs

alias ircnick.ver return IRCNick v0.52
alias ircnick {
  if ($1 == $null) { $ircnick.out usage: /ircnick <nick> | halt }
  if ($len($1) == 1) { $ircnick.out error: Invalid nick length | halt }
  if (%ircnick == $null) set %ircnick $1
  var %ircnick.i 0
  :i
  inc %ircnick.i 1
  var %ircnick.x ircnick_ $+ %ircnick.i
  if ($sock(%ircnick.x) != $null) { goto i }
  sockopen %ircnick.x ircnick.com 80
  sockmark %ircnick.x %ircnick
}
alias ircnick.out return $iif(%ircnick.out,%ircnick.out,$ircnick.echo)
alias ircnick.echo return echo $color(info2 text) -gat * IRCnick:
on *:sockopen:ircnick_*: {
  if ($sockerr > 0) { return }
  sockwrite -tn $sockname GET /? $+ %ircnick HTTP/1.0
  sockwrite -tn $sockname Host: ircnick.com
  sockwrite -tn $sockname $crlf
}
on *:sockread:ircnick_*: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname) != $null) { sockread %ircnick.y }
  if ($sockbr == 0) { return }
  var %ircnick.y $remove(%ircnick.y,<tr>,</tr>,<td>,<td >,<td>,<font class="profile">,</font></td>,<a href=,</a>,Username,<font, face="Verdana" size="2" color="#000000">,<strong>,</strong>,</font>,",mailto:)
  if (%ircnick.z == nick) { set %ircnick.nick nick: %ircnick.y | unset %ircnick.z }
  if (nick: isin %ircnick.y) set %ircnick.z nick
  if (%ircnick.z == network) { set %ircnick.network network: %ircnick.y | unset %ircnick.z }
  if (network: isin %ircnick.y) { set %ircnick.z network }
  if (%ircnick.z == name) { set %ircnick.name name: %ircnick.y | unset %ircnick.z }
  if (name: isin %ircnick.y) { set %ircnick.z name }
  if (%ircnick.z == sex) { set %ircnick.sex sex: %ircnick.y | unset %ircnick.z }
  if (sex: isin %ircnick.y) { set %ircnick.z sex }
  if (%ircnick.z == age) { set %ircnick.age age: %ircnick.y | unset %ircnick.z }
  if (age: isin %ircnick.y) { set %ircnick.z age }
  if (%ircnick.z == country) { set %ircnick.country country: %ircnick.y | unset %ircnick.z }
  if (country: isin %ircnick.y) { set %ircnick.z country }
  if (%ircnick.z == mail) { set %ircnick.mail email: $gettok(%ircnick.y,1,62) | unset %ircnick.z }
  if (mail address: isin %ircnick.y) { set %ircnick.z mail }
  if (%ircnick.z == web) { set %ircnick.web website: $gettok(%ircnick.y,1,32) | unset %ircnick.z }
  if (website: isin %ircnick.y) { set %ircnick.z web }
  if (%ircnick.z == icq) { set %ircnick.icq icq: %ircnick.y | unset unset %ircnick.z }
  if (icq: isin %ircnick.y) { set %ircnick.z icq }
  if ($+(thumbs/,%ircnick) isin %ircnick.y) { set %ircnick.img img: $+(http://ircnick.com/images/,%ircnick,.jpg) }
  if (waiting for authorization isin %ircnick.y) { set %ircnick.error error: %ircnick is still waiting for authorization! }
  if (No matching user isin %ircnick.y) { set %ircnick.error error: No user matching %ircnick }
  if (list of similar nicks isin %ircnick.y) { set %ircnick.error error: Could not find an exact match, see: http://ircnick.com/? $+ %ircnick }
  goto i
}
on *:sockclose:ircnick_*: { $ircnick.out %ircnick.nick %ircnick.network %ircnick.name %ircnick.sex %ircnick.age %ircnick.country %ircnick.mail %ircnick.web %ircnick.icq %ircnick.img %ircnick.error | unset %ircnick.* | unset %ircnick }
#!ircnick off
on *:text:!ircnick *:*: if ($2) { set %ircnick.out msg $iif($chan,$chan,$nick) * IRCnick | ircnick $2 }
#!ircnick end
menu status,menubar,channel,query {
  $ircnick.ver
  .Enter IRCnick: { ircnick $?="Nick?" }
  .!ircnick trigger $group(#!ircnick) : {
    if ($group(#!ircnick) == off) { .enable #!ircnick | $ircnick.out !ircnick is enabled }
    else { .disable #!ircnick | $ircnick.out !ircnick is disabled }
  }
}
