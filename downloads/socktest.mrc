;socktest v0.01 by HM2K

;Description: This script is used for testing and debugging

;settings
alias socktest.prefix return socktest.

alias socktest {
  if (!$1) { $socktest.out Usage: socktest <url> }
  if ($sock($socktest.id($1-))) { sockclose $socktest.id($1-) }
  sockopen $socktest.id($1-) $parse_url($1-).host $iif($parse_url($1).port,$ifmatch,80)
  sockmark $socktest.id($1-) $1-
}

on *:sockopen:socktest.*:{
  var %socktest.method GET
  var %socktest.query $iif($parse_url($sock($sockname).mark).path,$ifmatch,/) $+ $parse_url($sock($sockname).mark).query $+ $parse_url($sock($sockname).mark).fragment
  var %socktest.host $sock($sockname).addr

  sockwrite -n $sockname %socktest.method %socktest.query HTTP/1.1
  sockwrite -n $sockname Host: %socktest.host
  sockwrite -n $sockname User-Agent: mIRC/ $+ $version
  sockwrite -n $sockname 
}
on *:sockread:socktest.*:{
  sockread %r
  tokenize 32 $(%r,2)
}
on *:sockclose:socktest.*: {
  ;do nothing
}

alias -l socktest.id { ;produces a unique id based on the input
  return $socktest.prefix $+ $md5($1-)
}

alias -l socktest.relay { ;output relay v0.03 by HM2K (Updated 22/05/08)
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
  if ($isid) return %out
  %out $1-
}

#socktest.sockdebug on
alias -l sockdebug { ;debug mode for sockets v0.02 by HM2K
  var %win @sockdebug
  if (!$window(%win)) { window -e %win }
  if ($1-) { aline %win $timestamp $1- }
}
alias -l sockopen {
  sockdebug -> sockopen $1-
  sockopen $1-
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
#socktest.sockdebug end
