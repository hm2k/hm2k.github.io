;.oO{ regmIRC v2.8 by HM2K }Oo. - IRC@HM2K.ORG

;Description: A client script for automatically registering mIRC

;Installation: Make sure regmirc.mrc is in your $mircdir then type: /load -rs regmirc.mrc

;Usage: /regmirc <name> or /mircreg <name>

;Notice: Only use this script if you have registered mIRC, please read http://www.hm2k.com/posts/why-i-registered-mirc

alias regmirc.ver return regmIRC v2.8 (Updated: 18/09/08)

alias regmirc {
  if ($1) { $regmirc.relay * (regmIRC) $regmirc.get($1-) }
  else { $regmirc.relay * (regmIRC) Usage: /regmirc <name> }
}

on *:load: if (!$exists(mirc.reg)) { mircreg $nick }
alias mircreg {
  regmirc $iif($1-,$1-,$fullname)
  var %mirc.reg = mirc.reg
  if (!$exists(%mirc.reg)) {
    if ($?!="Register mIRC now?") {
      mirc.reg $iif($1-,$1-,$fullname)
      $regmirc.relay * (regmIRC) mIRC was successfully registered.
      if ($?!="Restart mIRC now to activate registration?") {
        echo $regmirc.relay * (regmIRC) mIRC is restarting...
        run $mircexe
        exit
      }
      else { $regmirc.relay * (regmIRC) You will need to restart mIRC to activate registration. }
    }
  }
}

alias mirc.reg {
  var %mirc.reg = mirc.reg
  write -c %mirc.reg
  write %mirc.reg REGEDIT4
  write %mirc.reg [HKEY_CURRENT_USER\Software\mIRC]
  write %mirc.reg [HKEY_CURRENT_USER\Software\mIRC\UserName]
  write %mirc.reg $+(@=",$1-,")
  write %mirc.reg [HKEY_CURRENT_USER\Software\mIRC\License]
  write %mirc.reg $+(@=",$regmIRC.gen($1-),")
  run regedit /s %mirc.reg
  ;.remove %mirc.reg
}

alias -l regmirc.get {
  if ($len($1-) < 5) { return $+(,$1-,) is too short. Must be 5 characters minimum } 
  elseif ($len($1-) > 26) { return $+(,$1-,) is too long. Must be 26 characters maximum }
  else { return Name: $+(,$1-,) Serial: $+(,$regmirc.gen($1-),) }
}

alias -l regmirc.gen { ;Thanks Nitrus
  var %len = $len($1-)
  if ((%len >= 5) && (%len <= 26)) {
    var %table = 11&6&17&12&12&14&5&12&16&10&11&6&14&14&4&11&9&12&11&10&8&10&10&16&8&4&6&10&12&16&8&10&4&16
    var %c = 4
    while (%c <= %len) {
      var %s1 = $calc(%s1 + ($asc($mid($1-,%c,1)) * $gettok(%table,$calc(%c - 3),38)))
      var %s2 = $calc(%s2 + (($asc($mid($1-,%c,1)) * $asc($mid($1-,$calc(%c - 1),1))) * $gettok(%table,$calc(%c - 3),38)))
      inc %c
    }
    if ((%s1) && (%s2)) { return $+(%s1,-,%s2) }
  }
}

alias -l regmirc.relay { ;output relay v0.03 by HM2K (Updated 22/05/08)
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
