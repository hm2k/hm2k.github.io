;various useful commands by HM2K

#loadall on
alias loadall { ;v0.1 (29/10/08) - loads all mirc scripts found in specified directory
  var %d $iif($1,$1,$mircdirscripts)
  var %t $findfile(%d,*.mrc,0)
  var %i 1
  while (%i < %t) {
    var %f $findfile(%d,*.mrc,%i)
    if (!$script(%f)) { load -rs %f }
    inc %i
  }
}
#loadall end

#amp on
alias amp {
  if ($isdde(mplug)) { dde mplug announce }
  else { echo -ga *** AMIP is not active, start winamp or download from http://amip.tools-for.net/ }
}
#amp end

#recovernick on
alias mynick $iif($isid,return,nick) $mnick
on *:quit: if (($me != $mynick) && ($nick == $mynick)) { mynick }
on *:nick: if (($me != $mynick) && ($nick == $mynick)) { mynick }
;on *:notify: if (($me != $mynick) && ($nick == $mynick)) { mynick }
;on *:unotify: if (($me != $mynick) && ($nick == $mynick)) { mynick }
#recovernick end

#regainops on
on *:part:#: if (($nick != $me) && ($me !isop $chan) && ($nick($chan,0) <= 2) && ($opnick($chan,0) == 0)) { .hop -c $chan }
#regainops end

#cycle on
alias cycle {
  kick $iif($2,$2,$chan) $$1 cycle
  invite $$1 $iif($2,$2,$chan)
}
#cycle end

alias servers { .enable #servers | .raw links } ; by HM2K v0.2
#servers off
raw 364:*: {
  haltdef
  if ((services. !isin $2) && (.hub !isin $2) && (hub. !isin $2) && (stats. !isin $2) && (ircd. !isin $2) && (ipv6. !isin $2)) {
    if ($chr(42) isin $2) { set %servers %servers $replace($2,*.,irc.) }
    else { set %servers %servers $2 }
  }
}
raw 365:*: { haltdef | .disable #servers | echo -a %servers | unset %servers }
#servers end


#shortmodes on
on *:input:*: if (($left($1,2) == /+) || ($left($1,2) == /-)) { mode $chan $right($1-,-1) | halt }
#shortmodes end

#time on
alias time {
  var %format = dddd dd mmmm yyyy - hh:nn:ss tt
  if ($1) { var %tz = $1 }
  if (%tz == PST) { var %offset = -8 * 3600 }
  elseif (%tz == EST) { var %offset = -5 * 3600 }
  elseif (%tz == CST) { var %offset = -6 * 3600 }
  elseif (%tz == AEST) { var %offset = +10 * 3600 }
  else {
    var %tz = $iif($daylight,BST,GMT)
    var %offset = 0
  }
  say $asctime($calc($gmt + %offset),%format) $upper(%tz)
}
#time end

#hosts on
alias hosts {
  run C:\WINDOWS\system32\notepad.exe C:\WINDOWS\system32\drivers\etc\hosts
}
#hosts end

#backward-text on
alias backward {
  var %a = 1, %b
  while ($mid($1-,%a,1) != $null) {
    %b = $ifmatch $+ %b
    inc %a
  }
  $iif($isid,return,say) %b
}
#backward-text end

#randompasswd on
alias random { return $remove($encode($left($+($rand(a,z),$+ $rand(0,9),$rand(A,Z),$rand(a,z),$+ $rand(0,9),$rand(A,Z),$rand(a,z),$+ $rand(0,9),$rand(A,Z)),9),m),=) }
alias passwd { return $left($+($rand(a,z),$+ $rand(0,9),$rand(A,Z),$rand(a,z),$+ $rand(0,9),$rand(A,Z),$rand(a,z),$+ $rand(0,9),$rand(A,Z)),8) }
#randompasswd end

#telnet2dcc on
alias telnet2dcc if ($2 == $null) { echo $colour(info2) * telnet2dcc usage: /telnet2dcc <ip> <port> | return } | .quote privmsg $me : $+ $chr(1) $+ DCC CHAT chat $longip($1) $2 $+ $chr(1)
#telnet2dcc end

#countdown on
alias countdown { ; countdown by HM2K v0.3 (updated 22/05/08)
  tokenize 32 $1-
  var %date $gettok($1,1-2,47)
  var %year $asctime($ctime,yyyy)
  var %time $iif($2,$2,00:00:00)
  var %past $iif($ctime($+(%date,/,%year) %time) < $ctime,1,0)
  if (%past) var %year $calc($asctime($ctime,yyyy) + 1)
  var %countdown $calc($ctime($+(%date,/,%year) %time) - $ctime)
  return $duration(%countdown)
}
#countdown end

#olog on
alias olog {
  if (!$1) { run $window($active).logfile | return }

  var %path $mircdirlogs
  if ($1 isnum) {
    var %match $+($gettok($active,1,32),*.log)
    var %matches $findfile(%path,%match,0)
    var %num $iif($1 < 0,$calc(%matches + $1),$1)
  }
  else {
    var %match $+($1,*.log)
    var %num $iif($2,$2,1)
  }

  var %log $findfile(%path,%match,%num)

  if ($isid) { return %log }
  else {
    if ($exists(%log)) { run %log }
    else { echo $colour(info2) log %log does not exist. }
  }
}
#olog end

#getops on
alias getops {
  var %i = 1
  while (%i <= $nick($chan,0)) {
    if ($nick($chan,%i) isop $chan) { var %var = %var $nick($chan,%i) }
    inc %i
  }
  var %var = $remtok(%var,$me,1,32)
  $iif($isid,return,say) $1- %var
}
#getops end

#moreslaps on
menu nicklist,query {
  Slaps
  .Trout:/me slaps $$* around a bit with a large trout
  .Trout2:/me slaps a large trout around a bit with $$*
  .Default:/me slaps $$* around a bit with a larger than mirc default trout
  .Troutification:/me does the troutification not $$*
  .Pregnant Trout:/me slaps $$* around a bit with a pregnant trout
  .Slap:/me slaps $$* 
  .Banana:/me beats $$* $+ 's ass with an oversized inflatable banana
  .Pie:/me fills $$* $+ 's face with a big cream pie!
  .Kazoo:/me slaps $$* with a Kazoo!
  Poke:/me pokes $$*
}
#moreslaps end

#morenicklist on
menu nicklist {
  Mass Invite: .invite $$* $$?="Enter Channel"
}
#morenicklist end

#opcmds on
alias kb if ($me isop $chan) { .ban -ku1200 $chan $1 3 $iif($2,$2-,kb) }
alias op {
  if ($1) {
    var %y
    var %x $1-
    while (%x) {
      var %y %y $+ mode $chan +oooo $gettok(%x,1-4,32) $+ $crlf
      var %x $deltok(%x,1-4,32)
    }
    .quote %y
  }
}
alias dop {
  if ($1) {
    var %y
    var %x $1-
    while (%x) {
      var %y %y $+ mode $chan -oooo $gettok(%x,1-4,32) $+ $crlf
      var %x $deltok(%x,1-4,32)
    }
    .quote %y
  }
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
#opcmds end

#invite2 on
alias invite2 { ;v0.2 Updated: 07/01/09
  if (!$1) { echo -gat Usage: invite2 <nick> (chan) }
  if (!$2 && !$chan && $active) { var %i $active $1 }
  else { var %i $1 $iif($2,$2,$chan) }
  tokenize 32 %i
  invite $1 $2
  msg $1 You have been invited to join $2
}
#invite2 end

#badword off
alias badword { ;badword v0.3 by HM2K Usage: $badword($1-)
  var %x = bitch asshole fuck nigger shit bastard whore slut wanker cunt slag dick prick arse nigger cock faggot niggah pussy penis vagina
  var %y = 0
  var %z = $numtok(%x,32)
  while (%y < %z) {
    inc %y
    if ($gettok(%x,%y,32) isin $1-) { return $true }
  }
  return $false
}
#badword end

#comchans on
alias comchans { ;v0.5 Updated: 07/01/09
  if (!$1 && !$isid) { echo $colour(info2) * Usage: /comchans <nick> | return }
  var %i = $comchan($1,0)
  if (!%i && !$isid) { echo $colour(info2) * $1 isn't on any matching channels | return }
  var %j = 0
  var %k
  while (%j < %i) {
    inc %j
    var %k = %k $comchan($1,%j)
  }
  if ($isid) return %k
  echo $colour(info2) * $1 matches %i channels: %k
}
#comchans end
