;w3c v0.1 *beta* by HM2K (Updated: 09/01/09)

;Description: Allows you to update your w3c via mIRC

;Installation: Make sure w3c.mrc is in your $mircdir then type: /load -rs w3c.mrc

;Usage: /w3c <url>

;History
;w3c v0.1 - 09/01/09 - Original release

;Settings
alias w3c_url return http://validator.w3.org/check?verbose=1&uri=
alias w3c_css_url return http://jigsaw.w3.org/css-validator/validator?profile=css2&warning=2&uri=

alias w3c {
  if (!$1) { $w3c.relay Usage: w3c <url> | return }
  if ($sock($w3c.id($1-))) { sockclose $w3c.id($1-) }
  sockopen $w3c.id($1-) $gettok($w3c_url,2,47) 80
  sockmark $w3c.id($1-) $1-
}

alias w3cs {
  w3c $1 $active
}

alias -l w3c.id { return w3c. $+ $left($md5($1-),5) }

alias -l w3c.relay { ;output relay v0.03 by HM2K (Updated 22/05/08)
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

on *:sockopen:w3c.*:{
  var %w3c.path / $+ $gettok($w3c_url,3-,47) $+ $urlencode($sock($sockname).mark)
  sockwrite -n $sockname HEAD %w3c.path HTTP/1.1
  sockwrite -n $sockname Host: $gettok($w3c_url,2,47)
  sockwrite -n $sockname User-Agent: mIRC/ $+ $version
  sockwrite -n $sockname 
  sockmark $sockname $sock($sockname).mark ;
}
on *:sockread:w3c.*:{
  sockread $(% $+ $sockname $+ _read,1)
  tokenize 32 $(% $+ $sockname $+ _read,2)
  unset $(% $+ $sockname $+ _read,1)
  if (X-W3C-Validator-Status: isin $1-) {
    if ($2 == Valid) sockmark $sockname $sock($sockname).mark Passed!
    elseif ($2 == Invalid) sockmark $sockname $sock($sockname).mark Failed!
    elseif ($2 == Abort) sockmark $sockname $sock($sockname).mark Aborted!
    else sockmark $sockname $sock($sockname).mark $2
  }
  if (X-W3C-Validator-Errors: isin $1-) {
    sockmark $sockname $sock($sockname).mark $2 Error(s)
  }
  if (X-W3C-Validator-Warnings: isin $1-) {
    sockmark $sockname $sock($sockname).mark $2 Warning(s)
  }
}
on *:sockclose:w3c.*: {
  w3c.done
}

alias w3c.done {
  tokenize 59 $sock($sockname).mark
  $w3c.relay($gettok($1,2,32)) $2- $brak(See: $w3c_url $+ $gettok($1,1,32))
  if ($sock($sockname)) sockclose $sockname
}

#w3c.sockdebug off
;debug mode for sockets v0.02 by HM2K
alias -l sockdebug {
  var %win @w3c
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
#w3c.sockdebug end

alias -l brak return $+($chr(40),$1-,$chr(41))
alias -l striphtml { !.echo -q $regsub(< $+ $1- $+ <>,/<[^>]*>/g,$chr(32),%x) | return %x }
alias -l urlencode {
  var %t = $1-, %r = "", %c
  while ($len(%t)) {
    %c = $asc($left(%t,1))
    %r = %r $+ $iif((%c <= 32) || (%c == 34) || (%c == 43) || (%c >= 127),% $+ $base($ifmatch,10,16,2),$chr(%c))
    %t = $right(%t,-1)
  }
  return %r
}
;EOF
