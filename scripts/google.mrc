;.oO{ Google v1.6 by HM2K }Oo. - www.hm2k.org

;Installation: Make sure google.mrc is in your $mircdir then type: /load -rs google.mrc

;Usage: /g or /google <string> or /gs or /googlesay <string>
;There is also a popup menu

;Google v1.6 - Changed the lookup method to a more complicated one (it means the script is more flexable), and added total results to the output, debug mode was added too. -- doesn't work atm resorted back
;Google v1.5 - Added simple flood protection, and urlencoding.
;Google v1.4 - Completly changed most of the way the script works including the output.
;Google v1.3 - Original public release.

alias -l google.ver return Google v1.6
alias -l google.server return www.google.com
alias -l google.out $iif(%google.out,msg %google.out,echo $color(info2 text) -gat) * Google: $1-

alias g google $1-
alias gs googlesay $1-

alias google {
  if ($1 == $null) { google.out usage: /google <text> | halt }
  var %google.x google_ $+ $rand(1,99)
  sockopen %google.x $google.server 80
  sockmark %google.x $urlencode($replace($1-,$chr(32),+))
}
alias googlesay { set %google.out $active | google $1- }

on *:sockopen:google_*: {
  if ($sockerr > 0) { return }
  ;This was part of the old lookup method, changed in v1.6 -- didn't work correctly
  sockwrite -tn $sockname HEAD /search?btnI=&q= $+ $sock($sockname).mark HTTP/1.0
  ;sockwrite -tn $sockname GET /custom?q= $+ $sock($sockname).mark HTTP/1.0
  sockwrite -tn $sockname $crlf
}
on *:sockread:google_*: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname) != $null) { sockread -f %google.y }
  if ($sockbr == 0) { return }

  ;This is for debug mode only
  ;if ($window(@google) == $null) { window @google }
  ;if (%google.y) { aline @google $remove(%google.y,<,>) }

  ;.!echo -q $regex(%google.y,/(.*?)p class=g><a href="(.*?)">(.*?)/g)
  ;if ($regml(2)) { set %google.url %google.url $regml(2) }

  ;This was part of the old lookup method, changed in v1.6
  if (Location: isin %google.y) {
    set %google.y $gettok(%google.y,2,32)
    if ($left(%google.y,1) == /) set %google.y $+(http://,$google.server,%google.y)
    set %google.url %google.y
    halt
  }

  goto i
}
on *:sockclose:google_*: { google.out $iif(%google.url,$gettok(%google.url,1,32) $iif(%google.results,$+($chr(40),%google.results,$chr(32),results,$chr(41)),),No results were found.) See More: $+(http://,$google.server,/search?q=,$sock($sockname).mark) | unset %google.* }
#!google off
on *:text:!google *:*: {
  if (%googleflood < 4) { inc %googleflood } | if (%googleflood == 4) { return } | if (!%googleflood) set -u8 %googleflood 1
  set %google.out $iif($chan,$chan $nick,$nick)
  google $2-
}
#!google end
menu status,menubar,channel,query {
  $google.ver
  .Google Search: { google $?="text?" }
  .Google Say: { googlesay $?="text?" }
  .!google trigger $group(#!google) : {
    if ($group(#!google) == off) { .enable #!google | google.out !google is enabled }
    else { .disable #!google | google.out !google is disabled }
  }
}
;this was added after to help with the way google searches
alias -l urlencode {
  var %t = $1-, %r = "", %c
  while ($len(%t)) {
    %c = $asc($left(%t,1))
    %r = %r $+ $iif((%c <= 32) || (%c == 34) || (%c >= 127),% $+ $base($ifmatch,10,16,2),$chr(%c))
    %t = $right(%t,-1)
  }
  return %r
}
