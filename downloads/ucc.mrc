;.oO{ XE.com UCC for mIRC v0.06 by HM2K }Oo. - IRC@HM2K.ORG

;Description: Allows you to convert an amount from one currency to another

;Installation: Make sure ucc.mrc is in your $mircdir then type: /load -rs ucc.mrc

;Usage: /ucc or /uccsay <amount> <from> <to> [nick/chan] (eg: 10 GBP EUR)

;History
;UCC v0.06 - Updated relay
;UCC v0.05 - Numbers returned with commas would cause a problem, fixed.
;UCC v0.04 - We're out of beta, fixed the output relay, added repeatcheck
;UCC v0.031 - Fixed a relay bug, usage a bit clearer and more currency codes
;UCC v0.03 - Fixed logic problems (thanks iWolf), and added uccsay
;UCC v0.02 - Fixed a few problems, better output
;UCC v0.01 - Original release

;currency codes (updated: 29/05/08)
;full list here: http://www.xe.com/ucc/full.php?obsolete=yes (view the HTML source code)
alias -l uccode { return AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BRL BSD BTN BWP BYR BZD CAD CDF CHF CLP CNY COP CRC CUC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GGP GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS IMP INR IQD IRR ISK JEP JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SPL SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TVD TWD TZS UAH UGX USD UYU UZS VEF VND VUV WST XAF XAG XAU XCD XDR XOF XPD XPF XPT YER ZAR ZMK ZWD }

;!ucc for channel use
#!ucc off
on *:text:!ucc*:#: { ucc $strip($2-) $chan | $repeatcheck(!ucc) }
#!ucc end

#uccdebug off
;debug mode so you know whats going on
alias -l ucc.debug {
  var %win @ucc
  if (!$window(%win)) { window -e %win }
  if ($1-) { aline %win $timestamp $1- }
}
alias -l sockwrite {
  ucc.debug > sockwrite $1-
  sockwrite $1-
}
alias -l sockopen {
  ucc.debug > sockopen $1-
  sockopen $1-
}
#uccdebug end

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

alias ucc {
  if (!$1) { $ucc.relay Usage: ucc <amount> <from> <to> [nick/chan] (eg: ucc 10 GBP EUR) | return }
  if ($1 !isnum) { $ucc.relay $1 is not a valid amount | return }
  if (!$istok($uccode,$2,32)) { $ucc.relay $2 is not a valid currency, use $uccode | return }
  if (!$istok($uccode,$3,32)) { $ucc.relay $3 is not a valid currency, use $uccode | return }
  if ($sock($ucc.id($1-))) { sockclose $ucc.id($1-) }
  sockopen $ucc.id($1-) www.xe.com 80
  set % $+ $ucc.id($1-) $1-
}

alias uccsay { ucc $1- $active }

alias -l ucc.id { return ucc. $+ $md5($1-) }

alias -l ucc.out {
  if ($2-3) && ($4-5) { $ucc.relay($gettok($(% $+ $1,2),4,32)) $2-3 is $4-5 | return }
  else { $ucc.relay($gettok($(% $+ $1,2),4,32)) Couldn't gather information for that currency, try www.xe.com/ucc | return }
}

alias -l ucc.relay { ;output relay v0.03 by HM2K (Updated 22/05/08)
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


alias -l ucc.strip { !.echo -q $regsub(< $+ $1- $+ <>,/<[^>]*>/g,$chr(32),%x) | return %x }

on *:sockopen:ucc.*:{
  ;http://www.xe.com/ucc/convert.cgi?Amount=1&From=EUR&To=USD
  var %ucc.get $+(/ucc/convert.cgi?Amount=,$gettok($(% $+ $sockname,2),1,32),&From=,$gettok($(% $+ $sockname,2),2,32),&To=,$gettok($(% $+ $sockname,2),3,32))
  sockwrite -n $sockname GET %ucc.get HTTP/1.1
  sockwrite -n $sockname Host: www.xe.com
  sockwrite -n $sockname
  ;unset % $+ $sockname
}

on *:sockread:ucc.*:{
  sockread %ucc.y
  tokenize 32 %ucc.y
  if ($group(#uccdebug) == on) ucc.debug < $sockname sockread %ucc.y
  if ($ucc.strip(%ucc.y)) {
    var %ucc.y = $ucc.strip(%ucc.y)
    var %ucc.y = $remove(%ucc.y,$chr(44))
    if (($numtok(%ucc.y,32) == 2) && ($gettok(%ucc.y,2,32) == $gettok($(% $+ $sockname,2),3,32))) { sockmark $sockname $sock($sockname).mark %ucc.y }
    if (($numtok(%ucc.y,32) == 2) && ($gettok(%ucc.y,2,32) == $gettok($(% $+ $sockname,2),2,32))) { sockmark $sockname $sock($sockname).mark %ucc.y }
  }
}
on *:sockclose:ucc.*: {
  ucc.out $sockname $sock($sockname).mark
  unset % $+ $sockname
}
;EOF
