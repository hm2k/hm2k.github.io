;Remember my channels v0.1 by HM2K (11/09/08)

alias -l data return $mircdirmychans.txt

on *:connect: connectmychans

alias connectmychans {
  if ($chan(*) == 0) {
    if ($input(Do you want to join your remembered channels for this network (if any)?,y)) { joinmychans }
  }
}

on me:*:JOIN:#: addmychan $chan
on me:*:PART:#: remmychan $chan

alias addmychan {
  if (!$read($data,w,$+($network,:,$iif($1,$1,$chan),*))) { write $data $+($network,:,$iif($1,$1,$chan)) $iif($2,$2,$chan($chan).key) }
}

alias remmychan {
  write -ds $+ $+($network,:,$iif($1,$1,$chan)) $data
}

alias joinmychans {
  var %i = 1
  var %t = $lines($data)
  while (%i <= %t) {
    var %r = $read($data,%i)
    if ($gettok(%r,1,58) == $network) .quote JOIN $gettok(%r,2-,58)
    inc %i
  }
}
alias savemychans {
  var %i = 1
  var %t = $chan(0)
  while (%i <= %t) {
    write $data $+($network,:,$chan(%i))
    inc %i
  }
}
