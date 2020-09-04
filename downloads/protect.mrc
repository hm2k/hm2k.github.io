;.oO{ Protection Bot 0.1 by HM2K *beta* }Oo. - IRC@HM2K.ORG

;Installation: Make sure protect.mrc is in your $mircdir then type: /load -rs protect.mrc

;on *:connect: protect
alias protect protect.load %protect.serv %protect.port
alias protect.reload protect.kill | protect
alias protect.join protect.dump join $1
menu @protect {
  load:protect.load $$?="serv?" $$?="port?"
  reload:protect.reload
  kill:protect.kill
  msg:protect.dump PRIVMSG $$?="nick/chan?" : $+ $$?="msg?"
  dump:protect.dump $$?="dump?"
  logging
  .show incomming (not recommended) %l1: if (%l1 != *) { set %l1 * | unset %l3 } | else { unset %l1 }
  .show outgoing %l2:if (%l2 != *) { set %l2 * } | else { unset %l2 }
  -
}
on *:input:@protect: {
  if ($left($1,1) != /) {
    protect.dump $1-
    halt
  }
}
alias protect.window {
  if ($window(@protect) == $null) {
    window -e @protect 0 0 9999 9999
  }
}
alias protect.rand {
  var %x $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z)
  return $left(%x,$rand(5,9))
}
alias protect.load {
  if ($2 !isnum) {
    echo -at * Protect: /protect.load <serv> <port>
    return
  }
  if ($portfree(113) == $true) { socklisten ident 113 }
  sockclose protect
  sockopen protect $1 $2
  set %protect.serv $1
  set %protect.port $2
}
alias protect.kill {
  if ($sock(protect) != $null) {
    protect.dump quit $1-
    sockclose protect
  }
}
alias protect.dump {
  if ($1 == $null) {
    echo -at * Protect: /protect.dump <text>
    return
  }
  if ($sock(protect) != $null) {
    sockwrite -tn protect $1-
    if (%l2 == *) {
      protect.window
      echo -t @protect -> $1-
    }
  }
}
on *:sockopen:protect: {
  if ($sockerr > 0) { return }
  protect.dump user $protect.rand $protect.rand $protect.rand $protect.rand
  sockmark protect $protect.rand
  protect.dump nick $sock(protect).mark
}
on *:sockclose:protect: {
  protect.load %protect.serv %protect.port
}
on *:sockread:protect: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname) != $null) { sockread %x }
  if ($sockbr == 0) { return }
  if (($gettok(%x,2,32) == 431) || ($gettok(%x,2,32) == 432) || ($gettok(%x,2,32) == 433)) { protect.dump nick $protect.rand }
  if (($gettok(%x,2,32) == 461) || ($gettok(%x,2,32) == 451)) {
    protect.dump user $protect.rand $protect.rand $protect.rand $protect.rand
    protect.dump nick $protect.rand
  }
  if ($gettok(%x,2,32) == 376) { protect.dump who $sock(protect).mark }
  if ($gettok(%x,2,32) == 352) { set %protect.mask $+($gettok(%x,3,32),!,$gettok(%x,5,32),@,$gettok(%x,6,32)) }
  ;protect.dump join #hm2k | protect.dump join #nemesisforce
  if ($remove($gettok(%x,1,33),:) == $me) {
    if ($gettok(%x,2,32) == PRIVMSG) { 
      if ($gettok(%x,4,32) == :!opme) { protect.dump mode $remove($gettok(%x,3,32),:) +o $remove($gettok(%x,1,33),:) }
      if ($gettok(%x,4,32) == :!op) { protect.dump mode $gettok(%x,3,32) +o $gettok(%x,5,32) }
      if ($gettok(%x,4,32) == :!dop) { protect.dump mode $gettok(%x,3,32) -o $gettok(%x,5,32) }
      if ($gettok(%x,4,32) == :!join) { protect.dump join $gettok(%x,5,32) }
      if ($gettok(%x,4,32) == :!part) { protect.dump part $gettok(%x,$iif($gettok(%x,5,32),5,3),32) }
      if ($gettok(%x,4,32) == :!hop) { protect.dump part $gettok(%x,$iif($gettok(%x,5,32),5,3),32) | protect.dump join $gettok(%x,$iif($gettok(%x,5,32),5,3),32) }
      if ($gettok(%x,4,32) == :!kick) { protect.dump kick $gettok(%x,3,32) $gettok(%x,5,32) }
      if ($gettok(%x,4,32) == :!dump) { protect.dump $gettok(%x,5,32) }
      if ($gettok(%x,4,32) == :!invite) { protect.dump invite $iif($chr(35) isin $gettok(%x,5,32),$me $gettok(%x,5,32),$gettok(%x,5,32) $gettok(%x,6,32)) }
      if ($gettok(%x,4,32) == :!msg) { protect.dump privmsg $gettok(%x,5,32) : $+ $gettok(%x,6-,32) }
      if ($gettok(%x,4,32) == :!slap) { protect.dump privmsg $gettok(%x,3,32) : $+ ACTION slaps $gettok(%x,5,32) around a bit with a large trout }
      if ($gettok(%x,4,32) == :!nick) { protect.dump nick $iif($gettok(%x,5,32),$gettok(%x,5,32),$protect.rand }
      if ($gettok(%x,4,32) == :!reload) { protect.reload }
    }
    if ($gettok(%x,2,32) == JOIN) { protect.dump mode $remove($gettok(%x,3,32),:) +o $remove($gettok(%x,1,33),:) }
    if ($gettok(%x,2,32) == INVITE) { protect.dump join $remove($gettok(%x,4,32),:) }
  }
  if (($gettok(%x,2,32) == KICK) && ($gettok(%x,4,32) == $sock(protect).mark)) { protect.dump join $gettok(%x,3,32) }
  if ($gettok(%x,1,32) == PING) { protect.dump privmsg 0 0 }
  if ($remove($gettok(%x,1,33),:) == $sock(protect).mark) {
    if ($gettok(%x,2,32) == NICK) { sockmark protect $remove($gettok(%x,3,32),:) | protect.dump who $sock(protect).mark }
  }
  if (%l1 == *) {
    protect.window
    echo -t @protect %x
  }
  goto i
}
on *:socklisten:ident: {
  if ($sockerr > 0) { return }
  var %i 0
  :i
  inc %i 1
  var %x ident_ $+ %i
  if ($sock(%x) != $null) { goto i }
  sockaccept %x
}
on *:sockread:ident_*: {
  sockread %x
  sockwrite $sockname %x : USERID : UNIX : $protect.rand
  if ($sock(ident) != $null) { sockclose ident }
}
on *:join:#: if (($nick == $sock(protect).mark) && ($nick !isop $chan) && ($me isop $chan)) { mode $chan +o $nick }
on *:op:#: {
  if (($opnick == $sock(protect).mark) && ($me !isop $chan)) { protect.dump mode $chan +o $opnick }
  elseif (($opnick == $me) && ($sock(protect).mark !isop $chan)) { mode $chan +o $opnick }
}
on *:deop:#: {
  if (($nick != $me) && ($nick != $sock(protect).mark)) {
    if (($opnick == $me) && ($sock(protect).mark isop $chan)) { protect.dump mode $chan +o $opnick | protect.dump kick $chan $nick :Don't deop $me }
    elseif ($opnick == $sock(protect).mark,5) { mode $chan +o $opnick | kick $chan $nick :Don't deop $sock(protect).mark }
  }
}
on *:kick:#: { 
  if (($nick != $me) && ($nick != $sock(protect).mark)) {
    if (($knick == $me)  && ($sock(protect).mark,5 isop $chan)) { protect.dump kick $chan $nick :Don't kick $me }
    elseif (($knick == $sock(protect).mark,5) && ($me isop $chan)) { kick $chan $nick :Don't kick $sock(protect).mark }
  }
}
on *:ban:#: {
  if (($nick != $me) && ($nick != $sock(protect).mark)) {
    if (($banmask iswm $address($me,5)) && ($me isop $chan))  { mode $chan -b $banmask | kick $chan $nick Don't ban $me }
    elseif ($banmask iswm $address($sock(protect).mark,5)) { protect.dump mode $chan -b $banmask | protect.dump kick $chan $nick :Don't ban $sock(protect).mark }
  }
}
alias protect.joinop {
  var %joinop 0
  while (%joinop < $chan(0)) {
    inc %joinop
    if ($me isop $chan(%joinop)) {
      protect.dump join $chan(%joinop)
    }
  }
}
alias protect.partop {
  var %joinop 0
  while (%joinop < $chan(0)) {
    inc %joinop
    if ($me isop $chan(%joinop)) {
      protect.dump part $chan(%joinop)
    }
  }
}
