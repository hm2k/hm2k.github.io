;Twitter Updater for mIRC v0.01 *beta* by HM2K (Updated: 16/04/08)

;Description: Allows you to update your twitter via mIRC

;Installation: Make sure twitter.mrc is in your $mircdir then type: /load -rs twitter.mrc

;Usage: /twitter <message>

;History
;twitter v0.01 - Original release

;Settings
alias -l twitter_server return twitter.com

alias twit twitter $1-

alias twitter {
  if (!%twitter_auth) { twitter.config }
  if (!$1) { $twitter.relay Usage: twitter <message> | return }
  if ($len($1-) > 140 ) { $twitter.relay Your message is too long $brak($len($1-) chrs) $+ , limit is 140 chrs | return }
  if ($sock($twitter.id($1-))) { sockclose $twitter.id($1-) }
  sockopen $twitter.id($1-) $twitter_server 80
  sockmark $twitter.id($1-) $1-
}

alias twitter.config {
  var %twitter_user $iif($1,$1,$$?="What is your twitter username?")
  var %twitter_pass $iif($2,$2,$$?*="What is your twitter password?")
  .set %twitter_auth $encode($+(%twitter_user,:,%twitter_pass),m)
}

alias -l twitter.id { return twitter. $+ $left($md5($1-),5) }

alias -l twitter.out {
  unset $(% $+ $sockname $+ _read,1)
  $twitter.relay $2-
}

alias -l twitter.relay {
  var %prefix twitter:
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

on *:sockopen:twitter.*:{
  var %twitter.get /statuses/update.xml
  var %twitter.headers $+(status=,$urlencode($sock($sockname).mark))
  sockwrite -n $sockname POST %twitter.get HTTP/1.1
  sockwrite -n $sockname Host: $twitter_server
  sockwrite -n $sockname User-Agent: mIRC/ $+ $version
  sockwrite -n $sockname Authorization: Basic %twitter_auth
  sockwrite -n $sockname Content-Type: application/x-www-form-urlencoded
  sockwrite -n $sockname Content-Length: $len(%twitter.headers)
  sockwrite -n $sockname
  sockwrite -n $sockname %twitter.headers
  sockwrite -n $sockname 
}
on *:sockread:twitter.*:{
  sockread $(% $+ $sockname $+ _read,1)
  tokenize 32 $(% $+ $sockname $+ _read,2)
  if ($gettok($1-,1,32) == Status: && $gettok($1-,2,32) != 200) {
    if ($gettok($1-,2,32) == 401) {
      twitter.out $sockname username or password is incorrect.
      unset %twitter_auth
    }
    else { twitter.out $sockname $1- }
    sockclose $sockname
  }
  if ($sock($sockname).mark isin $1-) {
    twitter.out $sockname Updated to: $sock($sockname).mark
    sockclose $sockname
  }
}
on *:sockclose:twitter.*: {
  unset $(% $+ $sockname,1)
  ;twitter.out $sockname $sock($sockname).mark
}

#twitter.sockdebug off
;debug mode for sockets v0.02 by HM2K
alias -l sockdebug {
  var %win @twitter
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
#twitter.sockdebug end

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
