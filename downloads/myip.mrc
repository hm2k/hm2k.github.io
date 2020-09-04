;.oO{ What Is My IP v0.4 by HM2K }Oo. - IRC@HM2K.ORG

;description: Corrects your "Local IP" in mIRC to fix common problems with DCC
;installation: /load -rs myip.mrc
;usage: it should update automatically on connect, or you can issue /myip

;MyIP v0.4: Now uses more reliable whatismyip.akamai.com
;MyIP v0.3: Fixed regex, and has an optional remote trigger
;MyIP v0.2: Uses regex instead now
;MyIP v0.1: Original release

;run the lookup on connect
on *:connect: myip

;connect to the ip lookup site
alias myip { .sockclose myip | .sockopen myip whatismyip.akamai.com 80 }

;send commands to the ip lookup site
on *:SOCKOPEN:myip:{
  if (!$sockerr) {
    .sockwrite -nt $sockname GET / HTTP/1.0
    .sockwrite -nt $sockname Host: whatismyip.akamai.com
    .sockwrite -nt $sockname Connection: close
    .sockwrite -nt $sockname $crlf
  }
}

;gather the ip from the ip lookup site
on *:SOCKREAD:myip:{
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname)) { sockread -f %x }
  if ($sockbr == 0) { return }
  .!echo -q $regex($sockname,%x,/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/gi)
  if ($regml($sockname,0)) { .enable #myip | .dns $regml($sockname,1) }
  goto i
}

#myip off
;This will set your localinfo to the correct ip, allowing dcc send to work correctly again
on *:DNS:localinfo $iif($naddress,$ifmatch,$iaddress) $iaddress | echo $color(info2 text) -gta * Local IP: $ip | .disable #myip
#myip end

#myipremote off
;This will set your localinfo to the correct ip from a remote trigger
on *:text:.myip:#: { .msg $chan MyIP is currently $ip - updating... | myip }
#myipremote end

#myip.sockdebug off
alias -l sockdebug { ;v0.03 by HM2K (updated: 16/09/08)
  var %win @myip
  if (!$window(%win)) { window -e %win }
  if ($1-) { aline -p %win $timestamp $1- }
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
#myip.sockdebug end
