;whoisd v1.0.8 by HM2K - domain whois and TLD country code lookup

;Description
;Allows you (or channel users, if enabled) to check if a domain is available or taken,
;also now offers the ability to check the country code of a given TLD.

;Installation: Make sure whoisd.mrc is in your $mircdir then type: /load -rs whoisd.mrc

;Usage:
;/whoisd <domain> [nick/chan] - says if domain is available or not
;!whoisd <domain> - says if domain is available or not on channel trigger (if group #!whoisd is on)
;/tld <tld> [nick/chan] - says the country code of a tld
;!tld <tld> - says the country code of a tld on channel trigger (if group #!tld is on)

;History:
;whoisd v1.0.8 - Added NOT FOUND for .me tld, improved debug script
;whoisd v1.0.7 - Updated output relay
;whoisd v1.0.6 - Added sponsoring organisation to TLDs, and added sockdebug
;whoisd v1.0.5 - Better support for domains
;whoisd v1.0.4 - Unset the temp var on sockclose.
;whoisd v1.0.3 - TLD now returns country name correctly, fixed the output, added a repeat checker
;whoisd v1.0.2 - Added TLD country lookup, based on TCL version, added flexible debugging
;whoisd v1.0.1 - Added some documentation.
;whoisd v1.0 - Original public release.

;This is for debug mode only - I like this method
#whoisd.sockdebug off
;debug mode for sockets v0.02 by HM2K
alias -l sockdebug {
  var %win @whoisd
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
#whoisd.sockdebug end

#!whois off
on *:text:!whois *:#: { whoisd $strip($2) $chan | $repeatcheck(!whois) }
#!whois end

#!tld on
on *:text:!tld *:#: { tld $strip($2) $chan | $repeatcheck(!tld) }
#!tld end

;Main whois lookup server - You don't need to adjust this
alias whoisd.server { return whois.iana.org }
alias whoisd.prefix { return whoisd: }

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

alias whoisd { ;Usage: <domain> [nick/chan]
  if (!$1) { $whoisd.relay Usage: /whoisd <domain> [nick/chan] | halt }
  var %i ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$
  if ($regex($1,%i) != 1) { $whoisd.relay $whoisd.prefix Invalid domain | halt }
  whoisd.open $whoisd.server $1 $2
}

alias whoisds { whoisd $1 $active }

alias tld { ;Usage: <domain> [nick/chan]
  if (!$1) { $whoisd.relay Usage: /tld <tld> [nick/chan] | halt }
  if (($left($1,1) != .) && (*.* iswm $1)) { $whoisd.relay tld: Invalid TLD | halt }
  whoisd.open $whoisd.server $1 $2
}
alias tlds { tld $1 $active }

alias -l whoisd.relay { ;output relay v0.03 by HM2K (Updated 22/05/08)
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

alias whoisd.open { ;Usage: <server[:port]> <domain> [nick/chan]
  if (!$1) { $whoisd.relay Usage: /whoisd.open <server[:port]> <domain> [nick/chan] | halt }
  if ($sock($whoisd.id($2))) { sockclose $whoisd.id($2) }
  if ($1) { sockopen $whoisd.id($2) $iif(: isin $1,$replace($1,:,$chr(32)),$1 43) }
  else { $whoisd.relay Usage: /whoisd.open <server[:port]> <domain> [nick/chan] | halt }
  set % $+ $whoisd.id($2) $1 $strip($2) $3
}

alias -l whoisd.id { return whoisd. $+ $md5($1) }

alias -l whoisd.err {
  if ($sockerr == 3) { return $iif($sock($sockname).wserr,$sock($sockname).wserr,failure establishing socket connection) }
  if ($sockerr == 4) { return error resolving hostname }
}

on *:sockopen:whoisd.*: {
  if ($sockerr > 0) { $whoisd.relay($gettok($(% $+ $sockname,2),3,32)) $whoisd.prefix $whoisd.err | return }
  if ($whoisd.server isin $gettok($(% $+ $sockname,2),1,32)) { $iif($numtok($gettok($(% $+ $sockname,2),2,32),46),.sockwrite -nt $sockname $gettok($gettok($(% $+ $sockname,2),2,32),$ifmatch,46),) }
  else { .sockwrite -nt $sockname $gettok($(% $+ $sockname,2),2,32) }
}
on *:sockread:whoisd.*: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname)) { sockread -f %whoisd.y }
  if ($sockbr == 0) { return }

  if ($whoisd.server isin $gettok($(% $+ $sockname,2),1,32)) {
    if ($left($gettok($(% $+ $sockname,2),2,32),1) == .) || (*.* !iswm $gettok($(% $+ $sockname,2),2,32)) {
      if (*not found.* iswm %whoisd.y) {
        $whoisd.relay($gettok($(% $+ $sockname,2),3,32)) tld: Invalid TLD
        whoisd.close
        halt
      }
      if (*Organization: * iswm %whoisd.y) {
        sockmark $sockname $gettok(%whoisd.y,2-,32)
      }
      if (*Country: * iswm %whoisd.y) {
        $whoisd.relay($gettok($(% $+ $sockname,2),3,32)) $whoisd.prefix $gettok($(% $+ $sockname,2),2,32),1) is $gettok(%whoisd.y,2-,32) $iif($sock($sockname).mark,$+([,$sock($sockname).mark,]))
        whoisd.close
        halt
      }
    }
    else {
      if (Whois Server == $gettok(%whoisd.y,1-2,32)) {
        .timer 1 1 whoisd.open $+($gettok(%whoisd.y,5,32),:,$remove($gettok(%whoisd.y,4,32),:,$chr(41))) $gettok($(% $+ $sockname,2),2-,32)
        if ($sock($sockname)) { whoisd.close }
        halt
      }
      elseif (*URL for registration services:* iswm %whoisd.y) {
        ;$whoisd.relay($gettok($(% $+ $sockname,2),3,32)) $whoisd.prefix This TLD has no whois server, try: $gettok(%whoisd.y,5,32) - $(% $+ $sockname,2)
        ;whoisd.close
        ;halt
      }
      if (*not found.* iswm %whoisd.y) {
        $whoisd.relay($gettok($(% $+ $sockname,2),3,32)) $whoisd.prefix Invalid TLD
        whoisd.close
        halt
      }
    }
  }
  ;if (*"=xxx"* iswm %whoisd.y) {
  ;  .timer 1 1 whoisd.open $gettok($(% $+ $sockname,2),1,32) = $+ $gettok($(% $+ $sockname,2),2-,32)
  ;  if ($sock($sockname)) whoisd.close
  ;  halt
  ;}
  if ((*Error for* iswm %whoisd.y) || (*ERROR: Invalid search string.* iswm %whoisd.y) || (*Bad Characters in query* iswm %whoisd.y) || (*Domain error* iswm %whoisd.y)) {
    $whoisd.relay($gettok($(% $+ $sockname,2),3,32)) $whoisd.prefix $gettok($(% $+ $sockname,2),2,32) caused an error...
    whoisd.close
    halt
  }
  if ((*No match* iswm %whoisd.y) || (*Not found* iswm %whoisd.y) || (*Status:*FREE* iswm %whoisd.y) || (NOT FOUND iswm %whoisd.y)) {
    $whoisd.relay($gettok($(% $+ $sockname,2),3,32)) $whoisd.prefix $gettok($(% $+ $sockname,2),2,32) is available!
    whoisd.close
    halt
  }
  goto i
}
on *:sockclose:whoisd.*: {
  if ($whoisd.server !isin $gettok($(% $+ $sockname,2),1,32)) { $whoisd.relay($gettok($(% $+ $sockname,2),3,32)) $whoisd.prefix $gettok($(% $+ $sockname,2),2,32) is taken! }
  else { $whoisd.relay($gettok($(% $+ $sockname,2),3,32)) $whoisd.prefix Could not lookup data for $gettok($(% $+ $sockname,2),2,32) }
  whoisd.close
}

alias whoisd.close {
  unset $(% $+ $sockname,1)
  sockclose $sockname  
}
