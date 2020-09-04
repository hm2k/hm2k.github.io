;.oO{ Seen (and lastspoke) Channel script v1.11 by HM2K }Oo. - IRC@HM2K.ORG

;Description:
;Looking for someone? huh? Well, look no further, this script is designed to keep log of people 
;quiting, parting, being kicked out of and changing their nick...
;It also tells you if they are still on IRC, on a different channel or such, its basically the easiest way to keep track of people.
;It can now also tell you when someone last spoke.

;Installation: Make sure seen.mrc is in your $mircdir then type: /load -rs seen.mrc

;Useage: Use the "Seen" menu to control the script, the main function is the triggers and the timer.
;Remember to turn these on from the menu if you want others to beable to use it
;For local use, you can use /seen and /lastspoke

;Seen v1.11   - 22/08/08 Added the repeat check script which I forgot to add
;Seen v1.1	- 20/05/08 Lastspoke can work from seen.log now too, added relay so can be used locally, redid input and output, reset your log file
;Seen v1.03	- 09/06/06 now has lastspoke, other functions were fixed too.
;Seen v1.02	- Cleaned up the script, added this file.
;Seen v1.01	- Fixed a few bugs and added new features.
;Seen v1.0	- Initial Public Release - Basic Code.

;Settings
alias -l seen.log return seen.log

;Core - No further editing
alias -l seen.ver return Seen v1.11 by HM2K

alias seen { $seen.relay seen: $seen.do($1) }
alias seens { $seen.relay($chan) seen: $seen.do($1) }
alias lastspoke { $seen.relay lastspoke: $lastspoke.do($1) }
alias lastspokes { $seen.relay($chan) lastspoke: $lastspoke.do($1) }

alias -l seen.relay {
  var %out echo $color(info2) -gat
  if ($modespl) {
    if ($1) {
      if (($ifmatch != Status Window) && ($ifmatch != -)) {
        if ($left($1,1) != $chr(35)) { var %out msg $1 }
        elseif ($chan($1)) { var %out msg $1 }
      }
    }
    elseif (($nick) && ($nick != $me)) var %out notice $nick
  }
  return %out
}

alias -l seen.do {
  if (!$chan) { return }
  if (!$1) { return You did not enter a nick to search. }
  if ($1 == $nick) { return Lost your self again, huh $nick $+ ? }
  if ($1 == $me) { return $nick $+ , I'm over here! }
  if ($1 ison $chan) { return $1 is here! }
  var %seen.found = $read -s $+ $1 $seen.log
  if (%seen.found) { return $seen.out($1 %seen.found) }
  else { return $1 has not been seen by me. }
}

alias lastspoke.do {
  if (!$chan) { return }
  if (!$1) { return You did not enter a nick to search. }
  if ($1 == $nick) { return You are talking now! }
  if ($1 == $me) { return I never speak! }
  ;if ($1 !ison $chan) { return $1 isn't on this channel! }
  var %lastspoke.found = $read -slastspoke. $+ $1 $seen.log
  if (%lastspoke.found) { return $seen.out($1 %lastspoke.found) }
  else { return $1 has been very quiet... }
}

#!seen off
on *:text:!seen*:#: { $seen.relay $nick $seen.do($2) | $repeatcheck(!seen) }
#!seen end

#!lastspoke off
on *:text:!lastspoke*:#: { $seen.relay $nick $seen.do($2) | $repeatcheck(!lastspoke) }
#!lastspoke end

#seen.log off
on ^*:NICK: { seen.in $nick $address $ctime nick $chan $newnick }
on ^*:KICK:#: { seen.in $knick $address $ctime kick $chan $1- }
on ^*:PART:#: { seen.in $nick $address $ctime part $chan $1- }
on ^*:QUIT: { seen.in $nick $address $ctime quit $1- }
on ^*:TEXT:*:#: { seen.in lastspoke. $+ $nick $address $ctime lastspoke $chan $1- }

alias -l seen.in { ;dolog $nick $address $action $ctime $info
  writereplace $1 $seen.log $1 $2 $3 $4 $5-
}
alias -l writereplace { ;usage: writereplace $file $key $line
  write -ds $+ $1 $2 | write $2 $3-
}
#seen.log end

alias -l seen.out {
  tokenize 32 $1-
  if ($gettok($1-,4,32) == lastspoke) { return $1 last spoke on $gettok($1-,5,32) $duration($calc($ctime - $gettok($1-,3,32))) ago $iif($gettok($1-,6-,32),saying $gettok($1-,6-,32)) }
  if ($gettok($1-,4,32) == kick) { return $1 $brak($2) was last seen being kicked from $gettok($1-,5,32) $duration($calc($ctime - $gettok($1-,3,32))) ago $iif($gettok($1-,6-,32),with the reason $brak($gettok($1-,6-,32))) }
  if ($gettok($1-,4,32) == part) { return $1 $brak($2) was last seen parting $gettok($1-,5,32) $duration($calc($ctime - $gettok($1-,3,32))) ago $iif($gettok($1-,6-,32),stating $brak($gettok($1-,6-,32))) }
  if ($gettok($1-,4,32) == quit) { return $1 $brak($2) was last seen quitting $duration($calc($ctime - $gettok($1-,3,32))) ago $iif($gettok($1-,6-,32),$brak($gettok($1-,6-,32))) }
  if ($gettok($1-,4,32) == nick) { return $1 $brak($2) was last seen changing nicks to $gettok($1-,6,32) $gettok($1-,5,32) $duration($calc($ctime - $gettok($1-,3,32))) ago }
}

;backets - I got fed up of repeating the same thing
alias -l brak return $+($chr(40),$1-,$chr(41))

alias -l repeatcheck { ;v0.12 by HM2K - will disable the appropriate group if its flooded
  var %rep.lim = 3
  var %rep.t.lim = 25
  var %rep.t.expr = 10
  if (%rep.lockusr- [ $+ [ $nick ] ]) { echo $ifmatch | haltdef }
  inc $+(-u,%rep.t.lim,$chr(32),%,rep-,$nick,.,$len($strip($1-)),.,$hash($strip($1-),32)) 1
  if (%rep- [ $+ [ $nick ] $+ . $+ [ $len($strip($1-)) ] $+ . $+ [ $hash($strip($1-),32) ] ] == %rep.lim) {
    ;ignore -u60 $address($nick,5)
    if ($group($chr(35) $+ $1) == on) { .disable $chr(35) $+ $1 | .echo -gat $1 is $group($chr(35) $+ $1) due to a repeat flood from $iif($chan,$nick in $chan,$nick) $+ , to re-enable: /enable $chr(35) $+ $1 }
    .set $+(-u,%rep.t.expr,$chr(32),%,rep.lockusr-,$nick) 1
  }
}

menu channel,menubar,status {
  $seen.ver
  .!seen Trigger ( $+ $group(#!seen) $+ ): {
    if ($group(#!seen) == off) { .enable #!seen }
    else { .disable #!seen }
    echo $colour(info2) -ta $brak(!seen Trigger) $group(#!seen)
  }
  .!lastspoke Trigger ( $+ $group(#!lastspoke) $+ ): {
    if ($group(#!lastspoke) == off) { .enable #!lastspoke }
    else { .disable #!lastspoke }
    echo $colour(info2) -ta $brak(!lastspoke Trigger) $group(#!lastspoke)
  }
  .Logging ( $+ $group(#seen.log) $+ ): {
    if ($group(#seen.log) == off) { .enable #seen.log }
    else { .disable #seen.log }
    echo $colour(info2) -ta $brak(Seen Logging) $group(#seen.log)
  }
  .Clear Seen Log
  ..Are you sure
  ...Yes: { .write -c $seen.log | echo $colour(info2) -ta $brak(Clear Seen Log) Successful! }
  ...No:  { echo $colour(info2) -ta $brak(Clear Seen Log) Failed. }
}

;EOF
