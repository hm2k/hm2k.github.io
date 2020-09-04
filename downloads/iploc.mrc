;.o0{ IP Location v0.1 by HM2K }0o. - IRC@HM2K.ORG

;Description: find the location of an ip using arin and ripe ip checks

alias iploc {
  if (!$1) { $iploc.out Usage: /iploc <ip> [nick/chan] | halt }
  if ($remove($1,.) !isnum) { $iploc.out Error: must be an valid ip address | halt }
  iploc.open whois.arin.net:43 $1-
}

alias -l iploc.out {
  var %prefix iploc:
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
  return %out %prefix
}

alias iploc.open {
  if (!$1) { $iploc.out Usage: /iploc.open <server[:port]> <ip> | halt }
  if ($1) { sockopen $iploc.id($2) $iif(: isin $1,$replace($1,:,$chr(32)),$1 43) }
  else { $iploc.out Usage: /iploc.open <server> <ip> | halt }
  if ($remove($2,.) isnum) sockmark $iploc.id($2) $2-
  else { $iploc.out Usage: /iploc.open <server> <ip> | sockclose $iploc.id($2) | halt }
}

alias -l iploc.id { return iploc_ $+ $longip($1) }

on *:sockopen:iploc_*: {
  if ($sockerr > 0) { return }
  .sockwrite -nt $sockname $gettok($sock($sockname).mark,1,32)
}
on *:sockread:iploc_*: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname)) { sockread -f %y }
  if ($sockbr == 0) { return }

  if ($group(#iploc.debug) == on) iploc.debug < $sockname sockread %y

  if (ReferralServer: == $gettok(%y,1,32)) {
    .timer 1 1 iploc.open $gettok($gettok(%y,2,32),2,47) $gettok($sock($sockname).mark,1,32)
    if ($sock($sockname)) sockclose $sockname
    halt
  }

  if (*RIPE-*NET-* iswm %y) {
    .timer 1 1 iploc.open whois.ripe.net $gettok($sock($sockname).mark,1,32)
    if ($sock($sockname)) sockclose $sockname
    halt
  }

  if (*afrinic.net* iswm %y) {
    .timer 1 1 iploc.open whois.afrinic.net $gettok($sock($sockname).mark,1,32)
    if ($sock($sockname)) sockclose $sockname
    halt
  }

  if (country: == $gettok(%y,1,32)) { sockmark $sockname $sock($sockname).mark $gettok(%y,2,32) }
  if (country: === $gettok(%y,1,9)) { sockmark $sockname $sock($sockname).mark $gettok(%y,2,9) }
  if (network:Country:* iswm %y) { sockmark $sockname $sock($sockname).mark $gettok(%y,3,58) }

  goto i
}
on *:sockclose:iploc_*: {
  if ($gettok($sock($sockname).mark,2,32)) { $iploc.out $gettok($sock($sockname).mark,1,32) is $gettok($sock($sockname).mark,2,32) }
  else { $iploc.out $gettok($sock($sockname).mark,1,32) has no country }
  unset % $+ $sockname
}

#iploc.sockdebug off
;debug mode for sockets v0.02 by HM2K
alias -l sockdebug {
  var %win @iploc
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
#iploc.sockdebug end
