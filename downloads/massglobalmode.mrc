;massglobalmode v0.3 by HM2K (based on a script by tonix)

alias op 
alias mop mass +o $chan rv
alias mdop mass -o $chan o
alias gop global +o $$1
alias gdop global -o $$1

alias mout echo 2 -gat ***

;mass mode/kick /m <+|-ovbeik> <#chan> <a|o|v|r>
alias mass { 
  if (($3 == $null) || ($left($1,1) !isin k+-)) { mout syntax /mass <+|-ovbeik> <#chan> <a|o|v|r> | return }
  if ($2 !ischan) { mout you're not on $2 | return }
  if ($me !isop $2) { mout you're not an op in $2 | return }
  set %m.i 0
  if (($mid($1,1,1) == k) || ($mid($1,2,1) == k)) {
    :kloop
    if (%m.i == $nick($2,0,$3)) { goto kend }
    inc %m.i 1
    if ($nick($2,%m.i,$3) != $me) { set %m.n %m.n $+ $crlf $+ kick $2 $nick($2,%m.i,$3) $4  }
    goto kloop
    :kend
    if (%m.n != $null) { .quote %m.n }
    goto end
  }
  else {
    :mloop
    if (%m.i == $nick($2,0,$3)) { goto mend }
    inc %m.i 1
    if ($nick($2,%m.i,$3) != $me) { set %m.n %m.n $+ $chr(32) $+ $nick($2,%m.i,$3) }
    goto mloop
    :mend
    if (%m.n != $null) { mmode $2 $left($1,1) $+ $str($mid($1,2,1),$gettok(%m.n,0,32)) %m.n }
    goto end
  }
  :end
  unset %m.*
}
;global mode/kick /global <+|-ovbeik> <nick|mask>
alias global {
  if (($2 == $null) || ($left($1,1) !isin k+-)) { mout syntax /global <+|-ovbei> <nick|mask> | return }
  set %g.i 0
  if (($mid($1,1,1) == k) || ($mid($1,2,1) == k)) {
    :kloop
    if (%g.i == $comchan($2,0)) { goto end }
    inc %g.i 1
    if ($me isop $comchan($2,%g.i) { set %g.n %g.n $+ $crlf $+ kick $comchan($2,%g.i)) $2 $3  }
    goto kloop
  }
  if (@ !isin $2) {
    :mloop
    if (%g.i == $comchan($2,0)) { goto end }
    inc %g.i 1
    if ($me isop $comchan($2,%g.i)) { set %g.n %g.n $+ $crlf $+ mode $comchan($2,%g.i) $left($1,2) $2 }
    goto mloop
  }
  if (@ isin $2) {
    :nloop
    if (%g.i == $chan(0)) { goto end }
    inc %g.i 1
    if ($me isop $chan(%g.i)) { set %g.n %g.n $+ $crlf $+ mode $chan(%g.i) $left($1,2) $2 }
    goto nloop
  }
  :end
  if (%g.n != $null) { .quote %g.n }
  unset %g.*
}

;multimode /mmode <#chan> <+|-ovbeik> <nick|mask>
alias mmode {
  set %mmode.max 4
  set %mmode.loop 0
  set %mmode.loop2 0
  :loop
  inc %mmode.loop 1
  if ($mid($2,%mmode.loop,1) isin +-) { set %mmode.flags %mmode.flags $+ $mid($2,%mmode.loop,1) | set %mmode.opr $mid($2,%mmode.loop,1) }
  else { set %mmode.flags %mmode.flags $+ $mid($2,%mmode.loop,1) | set %mmode.args %mmode.args $gettok($3-,$calc(%mmode.loop - 1),32) | inc %mmode.loop2 1 }
  if (%mmode.loop2 == %mmode.max) { set %mmode.thecommand %mmode.thecommand $+ $crlf $+ mode $1 %mmode.flags %mmode.args | unset %mmode.args | set %mmode.loop2 0 | set %mmode.flags %mmode.opr }
  if (%mmode.loop == $len($2)) { if (%mmode.loop2 > 0) { set %mmode.thecommand %mmode.thecommand $+ $crlf $+ mode $1 %mmode.flags %mmode.args } | goto end }
  goto loop
  :end
  .quote %mmode.thecommand
  unset %mmode.*
}

menu nicklist,channel,query {
  -
  normal
  .op:mode $chan +o $$*
  .deop:mode $chan -o $$*
  .voice:mode $chan +v $$*
  .devoice:mode $chan +o $$*
  .kick:kick $chan $$* $$?="msg?"
  mass
  .op
  ..ops:mass +o $chan o
  ..voices:mass +o $chan v
  ..regular's:mass +o $chan r
  ..all:mass +o $chan a
  .deop
  ..ops:mass -o $chan o
  ..voices:mass -o $chan v
  ..regular's:mass -o $chan r
  ..all:mass -o $chan a
  .voice
  ..ops:mass +v $chan o
  ..voices:mass +v $chan v
  ..regular's:mass +v $chan r
  ..all:mass +v $chan a
  .devoice
  ..ops:mass -v $chan o
  ..voices:mass -v $chan v
  ..regular's:mass -v $chan r
  ..all:mass -v $chan a
  .kick
  ..ops:mass k $chan o $$?="msg?"
  ..voices:mass k $chan v $$?="msg?"
  ..regular's:mass k $chan r $$?="msg?"
  ..all:mass k $chan a $$?="msg?"
  .help:mass
  .about:mout massglobalmode
  global
  .op:global +o $$1
  .deop:global -o $$1
  .voice:global +v $$1
  .devoice:global -v $$1
  .kick:global k $$1 $$?="msg?"
  .help:global
  .about:mout massglobalmode
  -
}
