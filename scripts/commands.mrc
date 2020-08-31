;.oO{ Commands Script v0.22 by HM2K }Oo. - IRC@HM2K.ORG

menu nicklist {
  -
  XDCC
  .List:.msg $$* xdcc list
  .Get:.msg $$* xdcc send #$$?="Enter Pack Number"
  Op/Voice
  .OP: { op $$1- }
  .OP Pattern: { mode $chan +o $$1 | mode $chan +oo $$1 $$1 | mode $chan +ooo $$1 $$1 $$1 | mode $chan +oooo $$1 $$1 $$1 $$1 | mode $chan +ooo $$1 $$1 $$1 | mode $chan +oo $$1 $$1 | mode $chan +o $$1 }
  .DOP: { dop $$1- }
  .-
  .Voice: { v $$1- }
  .DVoice: { dv $$1- }
  Kick/Ban
  .KB:kb $$* BANNED
  .Customer KB: set %kick $?="Enter Reason" | kb $$* %kick
  .Mass Host Ban: ban # $$* 2
  .Mass Ident/HostBan: ban # $$* 3
  .Mass Nick: ban # $$* $+ !*@*
  .Set Ban: mode # +b $$?="Set Ban"
  .-
  .Custom Kick: kick # $$* $?="Enter Reason"
  .Kick: kick # $$* KICKED
  .Op Beg Kick: kick # $$* KICK ME?
  .Kick Cycle: kick # $$* Cycle
  .Kick Flood: kick # $$* Flood
  .Kick Banned: kick # $$* Banned
  Mass Invite: .invite $$* $$?="Enter Channel"
}
alias kb { .ban -ku180 $chan $1 2 $iif($2,$2-,kb) }
alias op {
  var %x $1-
  while (%x) {
    var %y %y $+ mode $chan +oooo $gettok(%x,1-4,32) $+ $crlf
    var %x $deltok(%x,1-4,32)
  }
  .quote %y
}
alias dop {
  var %x $1-
  while (%x) {
    var %y %y $+ mode $chan -oooo $gettok(%x,1-4,32) $+ $crlf
    var %x $deltok(%x,1-4,32)
  }
  .quote %y
}
alias v {
  var %x $1-
  while (%x) {
    var %y %y $+ mode $chan +vvvv $gettok(%x,1-4,32) $+ $crlf
    var %x $deltok(%x,1-4,32)
  }
  .quote %y
}
alias dv {
  var %x $1-
  while (%x) {
    var %y %y $+ mode $chan -vvvv $gettok(%x,1-4,32) $+ $crlf
    var %x $deltok(%x,1-4,32)
  }
  .quote %y
}
#takeover off
menu channel {
  -
  TakeOver
  .AutoMassDeop on OP $chr(91) $+ $group(#automdeop) $+ $chr(93)
  ..ON: {
    .set %to.chan $chan
    .enable #automdeop
    .echo -a [TakeOver] AutoMassDeop on OP is $group(#automdeop) %to.chan
  }
  ..OFF: {
    .disable #automdeop
    .echo -a [TakeOver] AutoMassDeop on OP is $group(#automdeop)
    .unset %to.chan
  }
  .-
  .FLOODS
  ..MSG Flood: { set %to.flood $$?="nick/chan?" | flood.msg }
  ..Notice Flood: { set %to.flood $$?="nick/chan?" | flood.notice }
  ..URL Flood: { set %to.flood $$?="nick/chan?" | flood.url }
  ..Injustice Flood: { set %to.flood $$?="nick/chan?" | flood.injustice }
  ..Finger Flood: { set %to.flood $$?="nick/chan?" | flood.finger }
  ..Version Flood: { set %to.flood $$?="nick/chan?" | flood.version }
  ..Ping Flood: { set %to.flood $$?="nick/chan?" | flood.ping }
  ..All Flood: { set %to.flood $$?="nick/chan?" | flood.msg | flood.notice | flood.url | flood.injustice | flood.ping | flood.version | flood.finger }
  .-
  .MASS DEOP [/mdeop]:/mdeop
  .MASS OP [/mop]:/mop
  .-
  .Non-ops [/mban]:/mban
  .Ops [/mbanops]:/mbanops
  .All [/mbanall]:/mbanall
  .-
  .Non-ops [/mkick]:/mkick
  .Ops [/mkickops]:/mkickops
  .All [/mkickall]:/mkickall
  .-
  .Set TakeOver Modes [/tomodes]:/tomodes
  .UnSet TakeOver Modes [/untomodes]:/untomodes
}
alias flood.msg { msg %to.flood $str(@,900) }
alias flood.notice { notice %to.flood $str(@,900) }
alias flood.injustice { ctcp %to.flood CLIENTINFO SED UTC ACTION DCC CDCC BDCC XDCC VERSION CLIENTINFO USERINFO ERRMSG FINGER TIME PING ECHO INVITE WHOAMI OP OPS UNBAN XLINK XMIT UPTIME :Use CLIENTINFO <COMMAND> to get more specific information }
alias flood.ping { ctcp %to.flood PING $str(@,900) }
alias flood.version { ctcp %to.flood VERSION }
alias flood.finger { ctcp %to.flood FINGER }
alias flood.url { msg %to.flood http://www.fuckyou.com/ http://www.fuckoff.com/ http://www.eatshit.com/ http://www.qwerty.com/ http://www.yousuck.com/ http://www.eatdick.com/ http://www.fuckme.com/ http://www.upyours.com/ http://www.shitface.com/ http://www.shutthefuckup.com/ http://www.fuckmycunt.com/ http://www.fuckmenow.com/ http://www.fucker.com/ http://www.motherfucker.com/ http://www.fuckhernow.com/ http://www.suckdick.com/ http://www.materbate.com/ http://www.fuckingbitch.com/ http://www.stupidbastard.com/ http://www.shitfuck.com/ http://www.fucku.com/ http://www.fuckfuck.com/ http://www.fuckmenow.com/ http://www.shithead.com/ http://www.dumbshit.com/ http://www.fatfuck.com/ http://www.fucksuck.com/ http://www.fuckup.com/ http://www.shiter.com/ http://www.thischansucks.com/ http://www.com.com/ http://www.www.com/ http://www.lame.com/ http://www.me.com/ http://www.1234567890.com/ http://www.you.com/ }
alias tomodes {
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  set %to.key $randomkey
  mode # +ntimps
  mode # +lk 1 %to.key
  topic # TakeOver by $me
}
alias untomodes {
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  mode # +ntps-mil
  mode # -k %to.key
  unset %to.key
  topic # "
}
alias mkick { 
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  %to.numberofnicks = $nick(#,0)
  %to.temp1 = 1
  :mkick
  if ($nick(#,%to.temp1) !isop $chan) { kick $chan $nick(#,%to.temp1) Good BYE! }
  inc %to.temp1
  if (%to.temp1 <= %to.numberofnicks) { goto mkick } 
}
alias mkickops { 
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  %to.numberofnicks = $nick(#,0)
  %to.temp1 = 1
  :mkickops
  if (( $nick(#,%to.temp1) isop $chan ) && ( $nick(#,%to.temp1) != $me )) { 
    kick $chan $nick(#, %to.temp1) Fuck Off Lamah! 
  }
  inc %to.temp1
  if (%to.temp1 <= %to.numberofnicks ) { goto mkickops } 
}
alias mkickall { 
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  %to.numberofnicks = $nick(#,0)
  %to.temp1 = 1
  :mkickall
  if ( $nick(#,%to.temp1) != $me ) { kick $chan $nick(#,%to.temp1) Fuck Off Lamah! }
  inc %to.temp1
  if (%to.temp1 <= %to.numberofnicks) { goto mkickall } 
}
alias mban {
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  %to.bn = 1
  %to.nbn = $nick(#,0)
  :bans
  if ( $nick(#,%to.bn) !isop $chan )  { 
    ban $nick(#,%to.bn) 
  } 
  inc %to.bn 
  if ( %to.bn <= %to.nbn ) { goto bans }
}
alias mbanops {
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  %to.bn = 1
  %to.nbn = $nick(#,0)
  :bansops
  if (( $nick(#, %to.bn) isop $chan ) && ( $nick(#, %to.bn) != $me )) { 
    ban $chan $nick(#,%to.bn)
  } 
  inc %to.bn 
  if ( %to.bn <= %to.nbn ) { goto bansops }
}
alias mbanall {
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  %to.bn = 1
  %to.nbn = $nick(#,0)
  :mbanall
  if ( $nick(#,%to.bn) != $me ) { 
    ban $nick(#,%to.bn) 
  } 
  inc %to.bn 
  if ( %to.bn <= %to.nbn ) { goto mbanall }
}
alias mdeop { 
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  set %to.i 0 
  set %to.nicks 
  set %to.j 0 
  :start 
  inc %to.i
  %to.nick = $opnick(#,%to.i)
  if (%to.nick == $null) { mode # -oooo %to.nicks | halt } 
  if (%to.nick == $me) goto start 
  set %to.nicks %to.nicks %to.nick  
  inc %to.j 
  if (%to.j == 4) { mode # -oooo %to.nicks | set %to.j 0 | set %to.nicks } | goto start
}
alias mop { 
  if ($me !isop $chan ) { .echo -a [TakeOver] You have to be oped to use this command! | halt }
  set %to.i 0 
  set %to.nicks 
  set %to.j 0 
  :start 
  inc %to.i
  %to.nick = $nick(#,%to.i)
  if (%to.nick == $null) { mode # +oooo %to.nicks | halt } 
  if (%to.nick == $me) goto start 
  set %to.nicks %to.nicks %to.nick  
  inc %to.j 
  if (%to.j == 4) { mode # +oooo %to.nicks | set %to.j 0 | set %to.nicks } | goto start
}
alias randomkey {
  var %to.x $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z)
  return $left(%to.x,$rand(5,9))
}
#automdeop off
on *:OP:#: if (($opnick == $me) && ($chan == %to.chan)) { mdeop } 
#automdeop end
#takeover end