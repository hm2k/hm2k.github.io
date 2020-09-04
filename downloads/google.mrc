;.oO{ Google v1.9 by HM2K }Oo. - www.hm2k.org

;Installation: Make sure google.mrc is in your $mircdir then type: /load -rs google.mrc

;Usage: /g or /google <string> or /gs or /googlesay <string> (There is also a popup menu)

;Google v1.9 - Changed the error message to be more in line with what google does now
;Google v1.8 - Revamped some of the code a little
;Google v1.7 - Resorted back to the simple method, fixed a few relaying bugs
;Google v1.6 - Changed the lookup method to a more complicated one (it means the script is more flexable), and added total results to the output, debug mode was added too.
;Google v1.5 - Added simple flood protection, and urlencoding.
;Google v1.4 - Completly changed most of the way the script works including the output.
;Google v1.3 - Original public release.

;Settings
alias -l google.ver return Google v1.9
alias -l google.server return www.google.com
alias -l google.prefix return * Google:

;Code
alias letme say http://letmegooglethatforyou.com/?q= $+ $urlencode($1-)

alias -l google.out return $google.relay($1-) $google.prefix
alias -l google.relay {
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

alias g google $1-
alias gs googlesay $1-

alias google {
  if (!$1) { $google.out Usage: google (-<server>) <text> | halt }
  if ($left($1,1) == -) { var %server = $right($1,-1) }
  google.open $iif(%server,%server,$google.server) $google.encode($iif(%server,$2-,$1-))
}
alias googlesay { google.open $google.server $google.encode($1-) $active }

#!google off
on *:text:!google*:*: {
  if (!$2) { $google.out($iif($chan,$chan,$nick)) Usage: google <text> | return }
  if ($1 == !googleuk) { var %server = www.google.co.uk }
  if ($1 == !google2) { var %server = www2.google.com }
  if ($1 == !google3) { var %server = www3.google.com }
  google.open $iif(%server,%server,$google.server) $google.encode($2-) $iif($chan,$chan,$nick)
  $repeatcheck(!google)
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

alias -l google.encode {
  return $urlencode($strip($1-))
}

alias -l google.open { ;Usage: <server[:port]> <text> [nick/chan]
  if (!$1) { $google.out Usage: google.open <server[:port]> <text> [nick/chan] | halt }
  if ($sock($google.id($2))) { sockclose $google.id($2) }
  if ($1) { sockopen $google.id($2) $iif(: isin $1,$replace($1,:,$chr(32)),$1 80) }
  else { $google.out Usage: google.open <server[:port]> <text> [nick/chan] | halt }
  set % $+ $google.id($2) $1 $strip($2) $3
}

alias -l google.id { return google. $+ $md5($1) }

on *:sockopen:google.*: {
  if ($sockerr > 0) { return }
  sockwrite -tn $sockname HEAD /search?btnI=&q= $+ $gettok($(% $+ $sockname,2),2,32) HTTP/1.0
  sockwrite -tn $sockname $crlf
}
on *:sockread:google.*: {
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
on *:sockclose:google.*: { 
  var %out $iif($sock($sockname).mark,$sock($sockname).mark,Google wasn't feeling lucky.) See: $+(http://,$sock($sockname).addr,/search?q=,$gettok($(% $+ $sockname,2),2,32))
  $google.out($iif($gettok($(% $+ $sockname,2),3,32),$ifmatch,)) %out
  unset $(% $+ $sockname,1)
}
menu status,menubar,channel,query {
  $google.ver
  .Google Search: { google $?="text?" }
  .Google Say: { googlesay $?="text?" }
  .!google trigger $group(#!google) : {
    if ($group(#!google) == off) { .enable #!google | google.out !google is enabled }
    else { .disable #!google | google.out !google is disabled }
  }
}

alias -l urlencode {
  var %t = $len($1-),%r = "",%c
  while (%t) {
    %c = $asc($right($1,%t))
    if (%c == 32) { %c = + }
    elseif ((%c <= 32) || (%c == 34) || (%c == 38) || (%c == 43) || (%c >= 127)) { %c = % $+ $base($ifmatch,10,16,2) }
    else { %c = $chr(%c) }
    %r = %r $+ %c
    dec %t
  }
  return %r
}
#google.sockdebug off
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
#google.sockdebug end

;EOF
