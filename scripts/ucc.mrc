;.oO{ XE.com UCC *beta* for mIRC v0.01 by HM2K }Oo. - IRC@HM2K.ORG

;this is for channel use added in after
on *:text:!ucc*:#: { set %ucc.chan $chan | ucc $2- }

#uccdebug off
;debug mode so you know whats going on
alias -l ucc.debug {
  if (!$window(@ucc)) { window -e @ucc }
  if ($1-) { aline @ucc $timestamp $1- }
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

alias ucc {
  if ($active) set %ucc.chan $active
  if (!$1) { ucc.relay Syntax: ucc <amount> <from> <to> (eg: ucc 10 GBP EUR) - Country Currency Codes: $uccode | return }
  if ($1 !isnum) { ucc.relay Please enter a true amount | return }
  if (!$istok($uccode,$2,32)) { ucc.relay That is not a valid currency, try $uccode | return }
  if (!$istok($uccode,$3,32)) { ucc.relay That is not a valid currency, try $uccode | return }
  sockopen ucc www.xe.com 80
  set %ucc.amount $1
  set %ucc.from $2
  set %ucc.to $3
}

alias -l uccode { return ARS AUD BBD BGN BMD BRL BSD CAD CHF CLP CNY CYP CZK DKK DZD EGP EUR FJD GBP HKD HUF IDR ILS INR ISK JMD JOD JPY KRW KRW LBP MXN MYR NOK NZD PHP PKR PLN ROL RUR SAR SDD SEK SGD SKK THB TRL TTD TWD USD VEB XAG XAU XCD XDR XPD XPT ZAR ZMK }
alias -l ucc.out {
  if (%ucc.from2) || (%ucc.to2) { ucc.relay $gettok(%ucc.from2,1-2,32) is $gettok(%ucc.to2,1-2,32) | return }
  else { ucc.relay Couldn't gather information for that currency, please try www.xe.com/ucc | return }
}
alias -l ucc.relay { $iif($modespl,msg %ucc.chan,echo -a) UCC: $1- | unset %ucc.* }
alias -l ucc.strip { !.echo -q $regsub(< $+ $1- $+ <>,/<[^>]*>/g,$chr(32),%ucc.x) | return %ucc.x }

on *:sockopen:ucc:{
  set %ucc.get /ucc/convert.cgi?Amount= $+ %ucc.amount $+ &From= $+ %ucc.from $+ &To= $+ %ucc.to
  sockwrite -n $sockname GET %ucc.get HTTP/1.1
  sockwrite -n $sockname Host: www.xe.com
  sockwrite -n $sockname
}

on *:sockread:ucc:{
  sockread %ucc.temp
  tokenize 32 %ucc.temp
  if ($group(#uccdebug) == on) ucc.debug < $sockname sockread %ucc.temp
  if ($ucc.strip(%ucc.temp)) { 
    var %ucc.temp2 = $remove($ucc.strip(%ucc.temp),$chr(46))
    var %ucc.temp2 = $iif($gettok(%ucc.temp2,1,32) isnum,$ucc.strip(%ucc.temp),)
    $iif($gettok(%ucc.temp2,2,32) == %ucc.to,set %ucc.to2 %ucc.temp2,)
    $iif($gettok(%ucc.temp2,2,32) == %ucc.from,set %ucc.from2 %ucc.temp2,)
    .timerucc 1 1 ucc.out
  }
}
