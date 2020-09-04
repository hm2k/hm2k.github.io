;.oO{ Notepod for mIRC v1.7 by HM2K *beta* }Oo. - IRC@HM2K.ORG

;Description: NotePod is a channel definition script, similar in many respects to explain and fluxlearn and others, it works in almost the same way as notepod.tcl for eggdrop does, but better.

;Installation: Make sure notepod.mrc is in your $mircdir then type: /load -rs notepod.mrc

;History:
;Notepod for mIRC v1.7 - Added more features including help, and search functions.
;Notepod for mIRC v1.6 - Made a couple of adjustments before a public release, added the lock and unlock feature.
;Notepod for mIRC v1.5 - Changed the script so it has multi-channel support and added new configs
;Notepod for mIRC v1.4 - Made it more userfriendly... By adding popups and more customisation.
;Notepod for mIRC v1.3 - Remove routine added to make sure the definitions are successfully removed. Other bugs fixed.
;Notepod for mIRC v1.2 - Public release, beta.
;Notepod for mIRC v1.1 - Started again from scratch, this time with much better code
;Notepod for mIRC v1.05 - Semi-public release of the code, a few updates
;Notepod for mIRC v1.0 - Very old and bulky code, very much based on ^m2's and Genesis's work

alias np.ver return Notepod for mIRC v1.7 *beta*
alias np.ini { return notepod.ini }
alias np.txt { return $iif($exists($readini($np.ini,$chan,txt)),$readini($np.ini,$chan,txt),explain.txt) }
alias -l np.admin { return $readini($np.ini,global,admin) }
alias -l np.chans { return $readini($np.ini,global,chans) }
alias -l np.trig { return $readini($np.ini,$chan,trigger) }
alias -l np.bots { return $readini($np.ini,$chan,bots) }
alias -l np.input { return $readini($np.ini,$chan,input) }
alias -l np.prefix { return $readini($np.ini,$chan,prefix) }
alias np.staff { return $readini($np.ini,$chan,staff) $np.admin }

alias np.cfg {
  if (!$chan) { echo Please run this command within a channel }
  if ($istok($np.chans,$chan,44)) writeini -n $np.ini global chans $+($np.chans,$chr(44),$chan)
  if ((!$1) || ($1 == admin)) writeini -n $np.ini global admin $input(Who is/are the admin(s)?,eqa,Notepod: global settings,$iif($np.admin,$np.admin,HM2K))
  if ((!$1) || ($1 == chans)) writeini -n $np.ini global chans $input(What are the notepod channels?,eqa,Notepod: global settings,$iif($np.chans,$np.chans,#serialz))
  if ((!$1) || ($1 == txt)) writeini -n $np.ini $chan txt $input(Enter the filename for where the definitions are stored,eqa,Notepod: $chan settings,$iif($np.txt,$np.txt,explain $+ $chan $+ .txt))
  if ((!$1) || ($1 == trig)) writeini -n $np.ini $chan trigger $input(What do you want your notepod trigger as?,eqa,Notepod: $chan settings,$iif($np.trig,$np.trig,??))
  if ((!$1) || ($1 == prefix)) writeini -n $np.ini $chan prefix $input(What do you want your prefix trigger (for learn, forget, replace and whoset) as?,eqa,Notepod: $chan settings,$iif($np.prefix,$np.prefix,!))
  if ((!$1) || ($1 == bots)) writeini -n $np.ini $chan bots $input(Which bots run notepod?,eqa,Notepod: $chan settings,$iif($np.bots,$np.bots,MiloDaCat Serial-03 chernoble ^IceMan-X))
  if ((!$1) || ($1 == staff)) writeini -n $np.ini $chan staff $input(Who are your channel staff?,eqa,Notepod: $chan settings,$iif($readini($np.ini,$chan,staff),$ifmatch,LOQUILLO deicer))
  if ((!$1) || ($1 == input)) writeini -n $np.ini $chan input $input(Typing "?? <def>" will display in the channel (local setting)),yqa)
}
alias np.error { return $iif($nick,.notice $nick,echo -gatc info) notepod error: }
alias np.add if ($2) { np.remove $1 | write $np.txt $lower($1) $iif($nick,$nick,$me) $2- }
alias np.rename if ((!$np($2)) && ($np($1))) { var %np.tmp = $np($1) | np.remove $1 | np.add $2 %np.tmp }
alias np.remove { while ($np($1)) { write -ds $+ $1 $np.txt } }
alias np.lock if ($left($gettok($read -ns $+ $gettok($1,1,32) $np.txt,2-,32),1) != :) { var %np.tmp = $np($1) | np.remove $1 | write $np.txt $1 $iif($nick,$nick,$me) : $+ %np.tmp | return $1 was locked. }
alias np.unlock if ($left($gettok($read -ns $+ $gettok($1,1,32) $np.txt,2-,32),1) == :) { var %np.tmp = $np($1) | np.remove $1 | write $np.txt $1 $iif($nick,$nick,$me) %np.tmp | return $1 was unlocked. }
alias -l np.nolock return $iif($left($1-,1) == :,$right($1-,-1),$1-)
alias -l np.islocked return $iif($left($1-,1) == :,$true,$false)
alias -l np.whoset return $iif($read -ns $+ $gettok($1,1,32) $np.txt, $gettok($read -ns $+ $gettok($1,1,32) $np.txt,1,32), )
alias np.auth return $iif($nick == $np.whoset($1),$true,$iif($istok($np.staff,$nick,32),$true,$false))

on *:text:*:#: {
  if (($istok($np.chans,$chan,44)) && ($nick !isreg $chan)) {
    if (($2 == ==) && ($nick isin $np.bots) && (!$np.notdef($3-))) { np.remove $1 | write $np.txt $1 $nick $3- | return }
    ;if (($2 == ==) && ($np($1)) && ($np.notdef($3-))) { np.remove $1 | return }
    if (($nick isop $chan) || ($istok($np.staff,$nick,32)) && ($2)) {
      if (($1 == $np.prefix $+ learn) && (!$np($2))) { write $np.txt $2 $nick $3- | .notice $nick $lower($2) was learned. | return }
      if (($1 == $np.prefix $+ replace) && ($np.auth($2)) && ($np($2))) { np.add $2- | .notice $nick $lower($2) was replaced. | return }
      if (($1 == $np.prefix $+ forget) && ($np.auth($2)) && ($np($2))) { np.remove $2 | .notice $nick $lower($2) was forgotten. | return }
      if (($1 == $np.prefix $+ rename) && ($np.auth($2)) && ($np($2))) { np.rename $2 $3 | .notice $nick $lower($2) was renamed to $3 | return }
      if (($1 == $np.prefix $+ whoset) && ($np.whoset($2))) { .notice $nick $2 was set by $np.whoset($2) | return }
      if (($1 == $np.prefix $+ lock) && ($np.auth($2))) { $iif($np.lock($2),notice $nick $ifmatch,return) | return }
      if (($1 == $np.prefix $+ unlock) && ($np.auth($2))) { $iif($np.unlock($2),notice $nick $ifmatch,return) | return }
    }
    if (($1 == $np.trig $+ ?) && ($istok($np.staff,$nick,32))) { $iif($np.scan($2-),msg $chan matched $numtok($ifmatch,32) definitions: $ifmatch,) | return }
    if ($1 == $np.prefix $+ sort) && ($istok($np.admin,$nick,32)) { .notice $chan $np.sort($np.txt) lines of $np.txt were sorted. | return }
    if (($1 == $np.trig) && ($me !isreg $chan) && ($2)) { 
      if ($2 == ??) { np.help | return }
      else { msg $chan $iif($np($2), $2 == $np($2), $2 == Sorry $+ $chr(44) that term is not defined.) | return }
    }
  }
}
alias -l np.notdef return $istok(that term is not defined.;<not Defined>;<not set>,$1-,59)
on *:notice:*:#: {
  if ($istok($np.chans,$chan,44)) { 
    if (($2 == ==) && ($nick isin $np.bots) && ($nick !isreg $chan) && (!$np.notdef($3-)) { np.remove $1 | write $np.txt $1 $nick $3- | return }
  }
}
on *:input:#: if (($1 == ??) && ($np.input)) { haltdef | $iif($np($2),say $3 $ifmatch,$return) }

alias np.sort if ($exists($1)) { filter -ffct 1 32 $1 $1 | return $filtered }
alias np.nukedupe {
  if ($exists($1)) {
    window -sh @nukedupe
    loadbuf @nukedupe $1-
    var %nd.line 1
    while (%nd.line <= $line(@nukedupe,0)) {
      while ($gettok($line(@nukedupe,%nd.line),1,32) == $gettok($line(@nukedupe,$calc(%nd.line - 1)),1,32)) {
        dline @nukedupe $calc(%nd.line - 1)
      }
      inc %nd.line
    }
    savebuf @nukedupe $1-
    window -c @nukedupe
  }
}
alias np if ($1) { return $np.nolock($gettok($read -ns $+ $gettok($1,1,32) $np.txt,2-,32)) }
alias np.help {
  if ($nick !isreg $chan) { 
    .msg $nick $np.ver
    .msg $nick $np.trig <def> show a definition (v/o)
  }
  if ($istok($np.staff,$nick,32) || $istok($np.admin,$nick,32) || $nick isop $chan) {
    .msg $nick $np.prefix $+ learn <def> <text> - add a new definition (o)
    .msg $nick $np.prefix $+ forget <def> - remove definition you set (o)
    .msg $nick $np.prefix $+ replace <def> <newtext> - replace definition you set (o)
    .msg $nick $np.prefix $+ whoset <def> - shows who set definition (o)
  }
  if ($istok($np.staff,$nick,32) || $istok($np.admin,$nick,32)) {
    .msg $nick As a member of staff, you can $np.prefix $+ forget or $np.prefix $+ replace any definition.
    .msg $nick You can also use the scan command
    .msg $nick $np.trig $+ ? <text|wildcard> - returns the names of the defs matching the text or wildcard.
  }
  if ($istok($np.admin,$nick,32)) {
    .msg $nick Configured notepod staff: $np.staff
    .msg $nick As a configured notepod admin, you can LOCK a definition by prepending a : when using $np.prefix $+ learn
    .msg $nick $np.prefix $+ lock <def> - lock a current definition.
    .msg $nick $np.prefix $+ unlock <def> - unlock a current definition.
    .msg $nick $np.prefix $+ sort - sorts list alphabetically and removes any dupes.
    .msg $nick Configured notepod admin: $np.admin
  }
}
alias notepod {
  if (!$window(@notepod)) { window -salbd +tnexs @notepod 10 10 800 600 @notepod verdana 12 }
  clear @notepod
  filter -fw $np.txt @notepod $iif($1,$+(*,$1,*),)
}
alias np.scan {
  if ($1-) {
    if (!$window(@np.scan)) { window -hs @np.scan }
    clear @np.scan
    filter -fw $np.txt @np.scan $iif(* isin $1-,$1-,$+(*,$1-,*))
    var %i 1
    while (%i <= $line(@np.scan,0)) {
      var %var = %var $gettok($line(@np.scan,%i),1,32)
      inc %i
    }
    window -c @np.scan
    return $gettok(%var,1-50,32)
  }
}

menu channel {
  notepod
  .notepod menu:notepod
  .run config:np.cfg
  .edit notepod file:run $np.txt
}
menu @notepod {
  dclick { msg $?="channel(s) or nick(s)?" $np($gettok($sline(@notepod,1),1,32)) }
  msg $gettok($sline(@notepod,1),1,32) to chan/nick: { msg $?="channel(s) or nick(s)?" $np($gettok($sline(@notepod,1),1,32)) }
  update term $gettok($sline(@notepod,1),1,32): { msg $np.def ?? $gettok($sline(@notepod,1),1,32) }
  clipboard term $gettok($sline(@notepod,1),1,32): { clipboard $np($gettok($sline(@notepod,1),1,32)) }
  refresh: { notepod }
  -
  local
  .learn: { write $np.txt $?="term?" $me $?="definition?" | notepod }
  .replace $gettok($sline(@notepod,1),1,32): { $np.remove($gettok($sline(@notepod,1),1,32)) | write $np.txt $gettok($sline(@notepod,1),1,32) $me $?="new definition?" | notepod }
  .forget $gettok($sline(@notepod,1),1,32): { $np.remove($gettok($sline(@notepod,1),1,32)) | notepod }
  remote
  .learn: { msg $np.def !learn $?="term?" $?="definition?" | notepod }
  .replace $gettok($sline(@notepod,1),1,32): { msg $np.def !replace $gettok($sline(@notepod,1),1,32) $me $?="new definition?" | notepod }
  .forget $gettok($sline(@notepod,1),1,32): { msg $np.def !forget $gettok($sline(@notepod,1),1,32) | notepod }
}
