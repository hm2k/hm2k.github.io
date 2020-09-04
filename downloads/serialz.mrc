;.oO{ Serialz Script v0.69 by HM2K *beta* }Oo. - IRC@HM2K.ORG

;Installation: Make sure serialz.mrc, regmirc.mrc, notepod.mrc, winzip.mrc and winzip.dll is in your $mircdir then type: /load -rs serialz.mrc

alias -l sz.ver return Serialz Script v0.69 by HM2K *beta* http://www.hm2k.org/
on *:load: { sz.cfg | sz.load }
on *:unload: unset %sz.*

alias sz.ini { return serialz.ini }
alias sz.cfg {
  if (!$chan) { echo Please run this command within a channel | halt }
  if (!$istok($sz.chans,$chan,44)) writeini -n $sz.ini global chans $+($sz.chans,$chr(44),$chan)
  if ((!$1) || ($1 == admin)) writeini -n $sz.ini global admin $input(Who is/are the admin(s)?,eqa,Serialz: global settings,$iif($sz.admin,$sz.admin,HM2K))
  if ((!$1) || ($1 == dircracks)) writeini -n $sz.ini global dircracks $sdir($iif($sz.dir.cracks,$sz.dir.cracks,$mircdir),Where are your crack files (.zip and .rar files) located?)
  if ((!$1) || ($1 == dirserials)) writeini -n $sz.ini global dirserials $sdir($iif($sz.dir.serials,$sz.dir.serials,$mircdir),Where are your serial files (.txt serial lists) located?)
  if ((!$1) || ($1 == dirsearch)) writeini -n $sz.ini global dirsearch $sdir($iif($sz.dir.search,$sz.dir.search,$mircdir),Where are your search files (.nfo or .txt group release lists) located?)
  if ((!$1) || ($1 == cmdmsg)) writeini -n $sz.ini global cmdmsg $input(What message commands do you accept?,eqa,Serialz: global settings,$iif($sz.cmd.msg,$sz.cmd.msg,!serial !search !regmirc !winzip !addserial))
  if ((!$1) || ($1 == cmdchan)) writeini -n $sz.ini $chan cmdchan $input(What channel commands do you accept from $chan ?,eqa,Serialz: $chan settings,$iif($sz.cmd.chan,$sz.cmd.chan,!serial !search))
  if ((!$1) || ($1 == cmdhelp)) writeini -n $sz.ini $chan cmdhelp $input(What is the channel !help command for $chan ?,eqa,Serialz: $chan settings,$iif($sz.cmd.help,$sz.cmd.help,!rulez))
  if ((!$1) || ($1 == voicemsg)) $iif($input(Enter the "voice me" message,eqa,Serialz: global settings,$iif($sz.voicemsg,$sz.voicemsg,will not function without being voiced +v please ask an op to voice me -- thanks!)),writeini -n $sz.ini global voicemsg $ifmatch,remini $sz.ini global voicemsg)
  if ((!$1) || ($1 == isnoton)) $iif($input(Enter the message ti send when user is not on a channel,eqa,Serialz: global settings,$iif($sz.isnoton,$sz.isnoton,you MUST be on one of my channels to use my functions)),writeini -n $sz.ini global isnoton $ifmatch,remini $sz.ini global isnoton)
  if ((!$1) || ($1 == sponsor)) $iif($input(If the channel is sponsored leave a sponsorship message,eqa,Serialz: $chan settings,$iif($sz.sponsor,$sz.sponsor,Sponsored by #serialz)),writeini -n $sz.ini $chan sponsor $ifmatch,remini $sz.ini $chan sponsor)
  if ((!$1) || ($1 == help)) $iif($input(Please leave a help note for $chan (Optional),eqa,Serialz: $chan settings,$iif($sz.help,$sz.help,Channel commands are $sz.cmd.chan)),writeini -n $sz.ini $chan help $ifmatch,remini $sz.ini $chan help)
  if ((!$1) || ($1 == cmdacc)) $iif($input(Please list any other commands that are accepted in $chan (Optional),eqa,Serialz: $chan settings,$iif($sz.cmd.acc,$sz.cmd.acc,!help)),writeini -n $sz.ini $chan cmdacc $ifmatch,remini $sz.ini $chan cmdacc)
  if ((!$1) || ($1 == globalstaff)) writeini -n  $sz.ini $chan staff $input(Who are your global (any chan) staff?,eqa,Serialz: $chan settings,$iif($sz.staff,$sz.staff,LOQUILLO deicer))
  if ((!$1) || ($1 == chanstaff)) writeini -n  $sz.ini $chan staff $input(Who are your channel staff?,eqa,Serialz: $chan settings,$iif($sz.staff,$sz.staff,LOQUILLO deicer))
  sz.voiceme
}
alias sz.off { if ($istok($sz.chans,$iif($1,$1,$chan),44)) { writeini -n $sz.ini chans $input(Remove the channel from the list to turn it off,eqa,Serialz: global settings,$iif($sz.chans,$sz.chans,#Serialz)) } }
alias sz.load {
  if (!$script(regmirc.mrc)) && ($exists(regmirc.mrc)) load -rs regmirc.mrc
  if (!$script(notepod.mrc)) && ($exists(notepod.mrc)) load -rs notepod.mrc
  if (!$script(winzip.mrc)) && ($exists(winzip.mrc)) load -rs winzip.mrc
}
alias sz.chans { return $readini($sz.ini,global,chans) }
alias sz.admin { return $readini($sz.ini,global,admin) }
alias sz.adminchan { return $readini($sz.ini,global,adminchan) }
alias sz.cmd.msg { return $readini($sz.ini,global,cmdmsg) }
alias sz.cmd.chan { return $readini($sz.ini,$chan,cmdchan) }
alias sz.cmd.acc { return $readini($sz.ini,$chan,cmdacc) }
alias sz.cmd.other { return $readini($sz.ini,$chan,cmdother) }
alias sz.cmd.help { return $readini($sz.ini,$chan,cmdhelp) }
alias sz.cmd.sponsor { return $readini($sz.ini,$chan,sponsor) }
alias sz.help { return $readini($sz.ini,$chan,help) }
alias sz.voicemsg { return $readini($sz.ini,global,voicemsg) }
alias sz.isnoton { return $readini($sz.ini,global,isnoton) }
alias sz.staff { return $readini($sz.ini,global,staff) $readini($sz.ini,$chan,staff) }
alias sz.cmd.all { return $sz.cmd.chan $sz.cmd.msg $sz.cmd.acc $sz.cmd.help $sz.cmd.other }
alias sz.dir.cracks { return $readini($sz.ini,global,dircracks) }
alias sz.dir.serials { return $readini($sz.ini,global,dirserials) }
alias sz.dir.search { return $readini($sz.ini,global,dirsearch) }
alias sz.iscmd return $iif($regex($left($1,1),[[:punct:]]) == 1,$true,$false))

;alias sz.relay if ($me !isreg $sz.adminchan) msg $sz.adminchan $1-
alias sz.relay return
#serialz on
;on *:connect: join $sz.chans
on *:join:#: {
  if ($nick == $me) {
    if (!$istok($sz.chans,$chan,44)) { echo -gatc info2 Serialz Error: $chan is NOT configured, please run sz.cfg }
    if ($istok($sz.chans,$chan,44)) {
      if ($timer(join $+ $chan)) { .timerjoin $+ $chan off }
      if ($me isreg $chan) { sz.voiceme }
      if ($me !isreg $chan) { sz.voiceme off }
    }
  }
}
alias sz.voiceme {
  if ($chan != $sz.adminchan) {
    if ((!$timer(voice $+ $chan)) && ($me isreg $chan)) { .timervoice $+ $chan 0 500 sz.voiceme $chan }
    if ($me !isreg $chan) { .timervoice $+ $chan off }
    if ($chr(35) == $left($1,1)) { describe $1 $sz.voicemsg }
  }
}
on *:part:#: if (($nick == $me) && ($istok($sz.chans,$chan,44))) { sz.voiceme off }
on *:kick:#: if (($knick == $me) && ($istok($sz.chans,$chan,44))) { .timerjoin $+ $chan 0 120 .join $chan | sz.voiceme }
on *:voice:#: if (($vnick == $me) && ($istok($sz.chans,$chan,44))) { sz.voiceme off }
on *:devoice:#: if (($vnick == $me) && ($istok($sz.chans,$chan,44))) { sz.voiceme }
on *:op:#: if (($opnick == $me) && ($istok($sz.chans,$chan,44))) { sz.voiceme off }
on *:deop:#: if (($opnick == $me) && ($istok($sz.chans,$chan,44)) && ($me isreg $chan)) { sz.voiceme }
on *:invite:#: if ($istok($sz.admin $szstaff,$nick,32)) { .join $chan }
on *:text:*:*: {
  if ($sz.ison) { 
    if ($window($nick) && (!$chan)) { close -m $nick }
    if (($me isreg $chan) && ($istok($sz.chans,$chan,44))) { sz.voiceme | halt }
    if (($1 == !total) && ($istok($sz.admin,$nick,32))) { describe $chan has a total of $sz.total | halt }
    if (($istok(get dir pdcc grab please hey xdcc dcc send help rulez hi how,$1,32)) && (!$chan)) { .close -m $nick | halt }
    if ($sz.iscmd($1)) { 
      if ($sz.log) {
        if ($window(@serialz) == $null) { window @serialz }
        aline @serialz $timestamp < $+(<,$nick,$iif($chan,$+(:,$chan), :msg),>) $1-
      }
      sz $1-
      if ($result) {
        if ($sz.log) { aline @serialz $timestamp > $+(<,$nick,$iif($chan,$+(:,$chan), :msg),>) $result }
        .notice $nick $result
      }
      elseif (($istok($sz.cmd.chan,$1,32)) && (!$istok($sz.cmd.other,$1,32)) && ($2)) { 
        .notice $nick nothing found.
        sz.relay $+(<,$nick,$iif($chan, $+(:,$chan), :msg),>) $1- -- no result
      }
    }
    if ($nick isreg $chan) { $sz.repeat($1-) }
    if ($chan == $null) { $sz.repeat($1-) }
  }
  else { close -m $nick | .notice $nick $sz.isnoton }
}
alias sz {
  tokenize 32 $remove($1-,")
  if ($left($1,1) == !) {
    if ($left($gettok($2-,1,32),1) == -) { halt }
    if (($istok($sz.cmd.all,$1,32)) && (!$chan)) { 
      if (($readini($sz.ini, triggers, $1)) && ($istok($sz.cmd.msg,$1,32))) { $readini($sz.ini, triggers, $1) }
      if (($1 == !get) && ($istok($sz.cmd.msg,$1,32)) && ($2)) { 
        if ($exists($+($sz.dir.cracks,$2-))) { dcc send $nick $+(",$sz.dir.cracks,\,$2-,") | return Sending file via DCC send, MD5 checksum $md5($+($sz.dir.cracks,\,$2-),2) }
        else { sz.relay $+(<,$nick,$iif($chan, $+(:,$chan), :msg),>) $1- -- no result | return File $2 not found, try another bot. }
      }
    }
    if (($readini($sz.ini, triggers, $1)) && ($istok($sz.cmd.chan,$1,32))) { $readini($sz.ini, triggers, $1) }
    if (($1 == !serial) && ($istok($sz.cmd.all,$1,32))) { 
      if ($2) {
        if ($sz.np($2)) && (!$3) { return * $sz.np($2-) }
        elseif ($sz.serial($2-)) { return $sz.serial($2-) }
      }
      else { return Usage: $1 <program name> }
    }
    if (($1 == !search) && ($istok($sz.cmd.all,$1,32))) { 
      if ($2) {
        if (($right($2,4) == .zip) || ($right($2,4) == .rar)) { 
          if (($istok($sz.cmd.msg,!get,32)) && ($exists($+($sz.dir.cracks,\,$2)))) { return File $2 was found, to recieve type: /msg $me !get $2 }
        }
        if ($sz.np($2)) && (!$3) { return * $sz.np($2-) }
        if ($nopath($findfile($sz.dir.cracks,$replace($+(*,$2-,*),$chr(32),*),1))) { return File $ifmatch was found as the closest match. To recieve type /msg $me !get $ifmatch }
        if ($sz.search($2-)) { return matched: $ifmatch }
        if ($sz.serial($2-)) { return $ifmatch }
      }
      else { return Usage: $1 <program name> }
    }
  }
  if (($1 == !addserial) && ($istok($sz.cmd.all,$1,32))) { 
    if ($3) { write $sz.dir.serials $+ \!addserial.txt $2- | return Your serial has been added, thanks. }
    else { return Usage: $1 <program name> <version> : <serial> }
  }
  if ($istok($sz.chans,$chan,44)) {
    if (($1 == !cmd) || ($1 == !msg)) { 
      if (!$2) { return Accepting: $sz.cmd.chan ( /msg $me $sz.cmd.msg ) }
      $iif($istok($sz.cmd.chan,$2,32), return Accepting: $2, $iif($2 isin $sz.cmd.msg, return Accepting: /msg $me $2, return))
    }
    if (($1 == $sz.cmd.help) && ($sz.help)) { return $sz.help }
    if (($1 == !get) && ($istok($sz.cmd.all,$1,32)) && ($nick isreg $chan)) {
      if ($exists($+($sz.dir.cracks,$2))) { return File $2 was found, to recieve type: /msg $me !get $2 }
      else { return The proper format for a !get is .. /msg <BOT> !get <filename> .. type !msg to see who is a <BOT> and who's accepting which command. }
    }
    if ((!$istok($sz.cmd.all,$1,32)) && ($nick isreg $chan)) { return $1 is an invalid channel trigger, try: $sz.cmd.help }
    if (($left($1,1) == @) && ($nick isreg $chan)) { return $1 is an invalid channel trigger, try: $sz.cmd.help }
  }
}
alias sz.serial {
  var %y = 0
  var %z = $findfile($sz.dir.serials,*.txt,0,1)
  var %tmp = $strip($1-)
  var %tmp = $remove($+(*,$replace(%tmp,$chr(32),*),*),$chr(40),$chr(41),<,>,$chr(44),@,#,~,/,\,+,`)
  ;var %tmp = $replace(%tmp,.,*)
  while (%y <= %z) {
    inc %y
    if (($findfile($sz.dir.serials,*.txt,%y,1)) && ($read $+(-nw,%tmp) $findfile($sz.dir.serials,*.txt,%y,1))) { return $replace($sz.striphtml($read $+(-nw,%tmp) $findfile($sz.dir.serials,*.txt,%y,1)),$chr(9),$chr(32)) }
  }
}
alias sz.search {
  var %y = 0
  var %z = $findfile($sz.dir.search,*.txt,0,1)
  var %z = %z + $findfile($sz.dir.search,*.nfo,0,1)
  var %tmp = $strip($1-)
  var %tmp = $remove($+(*,$replace(%tmp,$chr(32),*),*),$chr(40),$chr(41),<,>,$chr(44),@,#,~,/,\,+,`)
  ;var %tmp = $replace(%tmp,.,*)
  while (%y <= %z) {
    inc %y
    if (($findfile($sz.dir.search,*.txt,%y,1)) && ($read $+(-nw,%tmp) $findfile($sz.dir.search,*.txt,%y,1))) { return $read $+(-nw,%tmp) $findfile($sz.dir.search,*.txt,%y,1) }
    elseif (($findfile($sz.dir.search,*.nfo,%y,1)) && ($read $+(-nw,%tmp) $findfile($sz.dir.search,*.nfo,%y,1))) { return $read $+(-nw,%tmp) $findfile($sz.dir.search,*.nfo,%y,1) }
  }
}
alias -l sz.repeat {
  var %sz.rep.lim = 3
  var %sz.rep.t.lim = 25
  if (%sz.rep.lockusr- [ $+ [ $nick ] ]) { haltdef }
  inc -u [ $+ [ %sz.rep.t.lim ] ] %rep- [ $+ [ $nick ] $+ . $+ [ $len($strip($1-)) ] $+ . $+ [ $hash($strip($1-),32) ] ] 1
  if (%rep- [ $+ [ $nick ] $+ . $+ [ $len($strip($1-)) ] $+ . $+ [ $hash($strip($1-),32) ] ] == %sz.rep.lim) {
    .notice $nick no repeating, slow down.
    .ignore -u60 $address($nick,5)
    .set -u10 %sz.rep.lockusr- [ $+ [ $nick ] ] 1
  }
}
alias sz.ison {
  var %y = 0
  var %z = $numtok($sz.chans,44)
  while (%y <= %z) {
    inc %y
    if ($nick ison $gettok($sz.chans,%y,44)) { return $true }
  }
  return $false
}
alias -l sz.isop {
  var %y = 0
  var %z = $numtok($sz.chans,44)
  while (%y <= %z) {
    inc %y
    if ($nick isop $gettok($sz.chans,%y,44)) { return $true }
  }
  return $false
}
alias -l sz.striphtml {
  if ($1) {
    var %i,%parm = <> $replace($remove($1-,> <,><),$chr(9),$chr(32)) <>,%n = 2
    while ($gettok($gettok(%parm,%n,62),1,60)) {
      %i = %i $ifmatch
      inc %n
    }
    var %i = $replace(%i, - - , - )
    return %i
  }
}
alias -l sz.np {
  tokenize 32 $1-
  if ($1) {
    var %i = $np($1)
    var %i = $replace(%i,??,!serial)
    var %i = $replace(%i, -- -- , -- )
    var %i = $replace(%i, -- - , -- )
    var %i = $replace(%i, - - , - )
    var %i = $remove(%i, (for +o/+v only),@ and +v ,(ops and v know the commands) )
    if ((.rar isin %i) || (.zip isin %i)) { var %i = $sz.hlfiles(%i) }
    return %i
  }
}
alias -l sz.hlfiles {
  var %str = $$1, %extensions = zip|rar
  if ($2 != $null) %extensions = $2
  var %t, %i = 1, %r = $regex(n, %str, /([^\s]+?\.( $+ %extensions $+ ))\b/ig)
  while ($regml(n,%i)) { 
    %t = $ifmatch 
    if ($exists($sz.dir.cracks $+ %t)) { %str = $reptok(%str, %t, $+($chr(3),3,%t,$chr(3)), 32) }
    else { %str = $reptok(%str, %t, $+($chr(3),4,%t,$chr(3)), 32) } 
    inc %i 2 
  } 
  return %str
}
alias -l sz.queue {
  if ($timer(sz.queue) == $null) { .timersz.queue 0 5 sz.queue }
  if ($window(@sz.queue) == $null) { window -h @sz.queue }
  if ($1) { aline @sz.queue $1- }
  else {
    if ($line(@sz.queue,1) != $null) {
      $line(@sz.queue,1)
      dline @sz.queue 1
    }
  }
}
alias sz.total {
  window -h @serialztotal
  .set %sz.total.serial.files $findfile($sz.dir.serials,*.*,*,filter -fw $1- @serialztotal *)
  .filter -ww @serialztotal @serialztotal
  window -c @serialztotal
  return $filtered serials and $findfile($sz.dir.cracks,*,0) cracks
}
alias sz.rename {
  %i = 1
  while (%i <= $findfile($sz.dir.cracks,*,0)) {
    ;echo -gat $nopath($findfile($sz.dir.cracks,*,%i))
    if ($chr(32) isin $nopath($findfile($sz.dir.cracks,*,%i))) { .rename $findfile($sz.dir.cracks,*,%i).shortfn $replace($findfile($sz.dir.cracks,*,%i),$chr(32),_) | echo -gat Renamed: %i $findfile($sz.dir.cracks,*,%i) -> $replace($findfile($sz.dir.cracks,*,%i),$chr(32),_) }
    inc %i
  }
}
alias sz.dupecheck {
  var %dir $sz.dir.cracks
  window -hc @dupecheck
  window @dupecheck
  var %x $findfile(%dir,*,0,1,aline @dupecheck $md5($1-,2) $replace($asctime($file($1-).mtime),$chr(32),_) $bytes($file($1-).size,3).suf $1-)
  filter -wwct 1 32 @dupecheck @dupecheck
  var %i 1
  while (%i <= $line(@dupecheck,0)) {
    if ($gettok($line(@dupecheck,%i),1,32) == $gettok($line(@dupecheck,$calc(%i - 1)),1,32)) { 
      if (!$window(@dupes)) { window -salb +tnexs @dupes 10 10 800 600 @dupes verdana 12 }
      aline @dupes $md5($gettok($line(@dupecheck,$calc(%i - 1)),4-,32),2) $ctime($file($gettok($line(@dupecheck,$calc(%i - 1)),4-,32)).mtime) $gettok($line(@dupecheck,$calc(%i - 1)),4-,32)
      aline @dupes $md5($gettok($line(@dupecheck,$calc(%i)),4-,32),2) $ctime($file($gettok($line(@dupecheck,$calc(%i)),4-,32)).mtime) $gettok($line(@dupecheck,$calc(%i)),4-,32)
    }
    inc %i
  }
}
menu @dupes {
  remove file: .remove $gettok($sline($active,1),3-,32) | .dline $active $sline($active,1).ln
  remove entry: .dline $active $sline($active,1).ln
}
#serialz end
