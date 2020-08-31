;.oO{ regmIRC v2.6 by HM2K }Oo. - IRC@HM2K.ORG

;Installation: Make sure regmIRC.mrc is in your $mircdir then type: /load -rs regmIRC.mrc

alias regmIRC.ver return regmIRC v2.6

on *:load: if (!$exists(regmIRC.reg)) { regmirc $nick }
on *:unload: unset %regmIRC.*

alias regmIRC {
  if (!$1) { echo $color(info2 text) -gat * regmIRC: usage: /regmIRC <name> | return }
  echo $color(info2 text) -gat * regmIRC: $regmirc.serial($1-)
  if (!$exists(regmIRC.reg)) {
    var %regmIRC.reg = $?!="Click yes, to register mirc"
    if (%regmIRC.reg == $true) {
      write -c regmIRC.reg
      write regmIRC.reg REGEDIT4
      write regmIRC.reg [HKEY_CURRENT_USER\Software\mIRC]
      write regmIRC.reg [HKEY_CURRENT_USER\Software\mIRC\UserName]
      write regmIRC.reg $+(@=",$1-,")
      write regmIRC.reg [HKEY_CURRENT_USER\Software\mIRC\License]
      write regmIRC.reg $+(@=",$regmIRC.gen($1-),")
      run regedit /s regmIRC.reg
      var %regmIRC.exit = $?!="Click yes, to restart mIRC now to activate Registration!"
      if (%regmIRC.exit == $true) {
        echo $color(info2 text) -gat * regmIRC: mIRC is restarting...
        run $mircexe
        exit
      }
      else { echo $color(info2 text) -gat * regmIRC: You will need to restart mIRC to activate registration. }
    }
  }
  ;.remove regmIRC.reg
}

alias regmirc.error { $iif($len($1-) < 5, return $+(,$1-,) is too short. Must be 5 characters minimum, $iif($len($1-) > 26, return $+(,$1-,) is too long. Must be 26 characters maximum, return)) }
alias regmirc.serial { $iif(!$regmirc.error($1-), return Name: $+(,$1-,) Serial: $+(,$regmIRC.gen($1-),), return $regmirc.error($1-)) }

alias regmIRC.gen {
  if (($len($1-) > 5) && ($len($1-) < 26)) {
    var %regmIRC.gen.table = 11&6&17&12&12&14&5&12&16&10&11&6&14&14&4&11&9&12&11&10&8&10&10&16&8&4&6&10&12&16&8&10&4&16
    var %regmIRC.gen.counter = 4
    :x
    if (%regmIRC.gen.counter > $len($1-)) { goto end }
    var %regmIRC.gen.s1 = $calc(%regmIRC.gen.s1 + ($asc($mid($1-,%regmIRC.gen.counter,1)) * $gettok(%regmIRC.gen.table,$calc(%regmIRC.gen.counter - 3),38)))
    var %regmIRC.gen.s2 = $calc(%regmIRC.gen.s2 + (($asc($mid($1-,%regmIRC.gen.counter,1)) * $asc($mid($1-,$calc(%regmIRC.gen.counter - 1),1))) * $gettok(%regmIRC.gen.table,$calc(%regmIRC.gen.counter - 3),38)))
    inc %regmIRC.gen.counter
    goto x
    :end
    if ((%regmIRC.gen.s1) && (%regmIRC.gen.s2)) { return $+(%regmIRC.gen.s1,-,%regmIRC.gen.s2) }
  }
}
;Thanks Nitrus
