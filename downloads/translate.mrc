;.oO{ Translate (Using Google) v1.0 by HM2K }Oo. - www.hm2k.org

;Installation: Make sure translate.mrc is in your $mircdir then type: /load -rs google.mrc

;Usage: 

;Translate (Using Google) v1.0 - Original public release.

;Settings
alias -l translate.ver return Translate (Using Google) v1.0
alias -l translate.url return http://translate.google.com/translate_a/t?client=t&text=$&sl=$&tl=$

;Code
alias -l translate.server return $gettok($translate.url,2,47)
alias -l translate.out return $translate.relay($1-)
alias -l translate.relay {
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

alias translate {
  if (!$1) { $translate.out Usage: translate (-<server>) <text> | halt }
  if ($left($1,1) == -) { var %server = $right($1,-1) }
  translate.open $iif(%server,%server,$translate.server) $translate.encode($iif(%server,$2-,$1-))
}
alias googlesay { translate.open $translate.server $translate.encode($1-) $active }

#!translate off
on *:text:!translate*:*: {
  if (!$2) { $translate.out($iif($chan,$chan,$nick)) Usage: translate <text> | return }
  translate.open $iif(%server,%server,$translate.server) $translate.encode($2-) $iif($chan,$chan,$nick)
  $repeatcheck(!translate)
}
#!google end

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

alias -l translate.encode {
  return $urlencode($strip($1-))
}

alias -l translate.open {
  if (!$1) { $translate.out Usage: translate.open <server[:port]> <encoded%20text> [nick/chan] | halt }
  if ($sock($translate.id($2))) { sockclose $translate.id($2-) }
  sockopen $translate.id($2) $iif(: isin $1,$replace($1,:,$chr(32)),$1 80)
  set % $+ $translate.id($2) $1 $2 $3
}

alias -l translate.id { return translate. $+ $md5($1) }

on *:sockopen:translate.*: {
  var %url / $+ $gettok($translate.url,3-,47)
  var %url $reptok(%url,$,$gettok($(% $+ $sockname,2),2,32),1,47)
  if ($sockerr > 0) { return }
  sockwrite -tn $sockname HEAD /search?btnI=&q= $+  HTTP/1.0
  sockwrite -tn $sockname $crlf
}
on *:sockread:translate.*: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname) != $null) { sockread -f %y }
  if ($sockbr == 0) { return }

  if (Location: isin %y) {
    var %y $gettok(%y,2,32)
    if ($left(%y,1) == /) var %y $+(http://,$sock($sockname).addr,%y)
    sockmark $sockname %y
    halt
  }

  goto i
}
on *:sockclose:translate.*: { 
  var %out $iif($sock($sockname).mark,$sock($sockname).mark,Google wasn't feeling lucky.) See: $+(http://,$sock($sockname).addr,/search?q=,$gettok($(% $+ $sockname,2),2,32))
  $translate.out($iif($gettok($(% $+ $sockname,2),3,32),$ifmatch,)) %out
  unset $(% $+ $sockname,1)
}
menu status,menubar,channel,query {
  $translate.ver
  .Google Search: { google $?="text?" }
  .Google Say: { googlesay $?="text?" }
  .!google trigger $group(#!google) : {
    if ($group(#!google) == off) { .enable #!google | translate.out !google is enabled }
    else { .disable #!google | translate.out !google is disabled }
  }
}

alias -l urlencode {
  var %t = $len($1-),%r = "",%c
  while (%t) {
    %c = $asc($right($1,%t))
    if (%c == 32) { %c = + }
    elseif ((%c <= 32) || (%c == 34) || (%c == 43) || (%c >= 127)) { %c = % $+ $base($ifmatch,10,16,2) }
    else { %c = $chr(%c) }
    %r = %r $+ %c
    dec %t
  }
  return %r
}
#translate.sockdebug off
;debug mode for sockets v0.02 by HM2K
alias -l sockdebug {
  var %win @sockdebug
  if (!$window(%win)) { window -e %win }
  if ($1-) { aline %win $timestamp $1- }
}
alias -l sockopen {
  sockopen $1-
  sockdebug -> sockopen $1-
}
alias -l sockwrite {
  sockwrite $1-
  sockdebug > sockwrite $1-
}
alias -l sockread {
  sockread $($1-,1)
  sockdebug < sockread $sockname $($1-,2)
}
alias -l sockclose {
  sockclose $1-
  sockdebug <- sockclose $1-
}
#translate.sockdebug end

;EOF
