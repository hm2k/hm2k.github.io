;.oO{ What Is My IP v0.13 by HM2K }Oo. - IRC@HM2K.ORG

on *:connect: myip
alias myip { .sockopen myip www.whatismyip.com 80 }
on *:SOCKOPEN:myip:{
  if (!$sockerr) {
    .sockwrite -nt $sockname $1- GET / HTTP/1.0
    .sockwrite -nt $sockname $1- Host: www.whatismyip.com
    .sockwrite -nt $sockname $1- Connection: Close
    .sockwrite -nt $sockname $1- $crlf
  }
}
on *:SOCKREAD:myip:{
  if (!$sockerr) {
    .sockread %x
    ;This is for debug mode only
    ;if ($window(@myip) == $null) { window @myip }
    ;if (%x) { aline @myip %x }

    .!echo -q $regex(%x,/<TITLE>WhatIsMyIP.com - (.+)</TITLE>/g)
    if ($regml(0)) { .enable #myip | .dns $regml(1) }
  }
}
#myip off
on *:DNS:localinfo $iif($naddress,$ifmatch,$iaddress) $iaddress | echo $color(info2 text) -gta * Local IP: $ip | .disable #myip
#myip end
