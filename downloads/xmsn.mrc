;.oO{ XMSN *beta* for mIRC v0.05 by HM2K }Oo. - IRC@HM2K.ORG

alias xmsn.ver return XMSN-HM2K 0.1

;Thanks to artwerks for his script which this is loosly based upon - http://msnmirc.scriptsdb.org/
;Thanks to Mike Mintz for the MSN Protocol research website - http://www.hypothetic.org/docs/msn/
;Thanks to Phurix for testing/using this script - http://www.phurix.co.uk/

;10/05/06 Now requires ssl.dll to auth via passport.net, thanks to Artwerks for his fixes

alias xmsndebug {
  if ($group(#xmsndebug) == on) .disable #xmsndebug | echo -a MSN: debugging is disabled
  else .enable #xmsndebug | echo -a MSN: debugging is enabled
}
#xmsndebug off
;This is for debug mode only - everything will relay to a window called @xmsn if this is enabled
alias -l xmsn.debug {
  if (!$window(@xmsn)) { window -e @xmsn }
  if ($1-) { aline @xmsn $timestamp $1- }
}
alias -l sockwrite {
  xmsn.debug > sockwrite $1-
  sockwrite $1-
}
alias -l sockopen {
  xmsn.debug > sockopen $1-
  sockopen $1-
}
#xmsndebug end

on me:join:%xmsnchan: xmsn
on *:connect: xmsn
on *:unload: xmsn.signoff
on *:exit: xmsn.signoff

;this is all for channel commands.
alias -l xmsn.cmds return help signon msg add rem block unblock restart signoff status nick ver ping spam clearq close
on *:text:!msn*:%xmsnchan: {
  if ($2 !isin $xmsn.cmds) { xmsn.relay That is not a valid command... | return }
  if ($2 == signon) { xmsn $3 $4 | return }
  if ($2 == ver) { xmsn.relay $xmsn.ver | return }
  if ($2 == clearq) { xmsn.clearq | xmsn.relay Queue was cleared | return }
  if ($2 == status) {
    if ($3) { xmsn.cmd status $3 | return }
    elseif (%xmsn.status) { xmsn.cmd ping | xmsn.relay status is currently set as %xmsn.status (change to $xmsn.statuss $+ ) | return }
  }
  if ($2 == restart) { xmsn.signoff | xmsn | return }
  if ($sock(xmsn.server)) {
    if ($2 == msg) { xmsnmsg $3- | return }
    if (*@*.* iswm $3) {
      if ($2 == add) { xmsn.cmd add $3 | return }
      if ($2 == rem) { xmsn.cmd rem $3 | return }
      if ($2 == block) { xmsn.cmd block $3 | return }
      if ($2 == unblock) { xmsn.cmd unblock $3 | return }
    }
    if ($2 == signoff) { xmsn.signoff | return }
    if ($2 == nick) { xmsn.cmd nick $3- | return }
    if ($2 == spam) { set -u3 %xmsn.spam on | xmsn.cmd status HDN | xmsn.cmd status NLN | xmsn.cmd status HDN | xmsn.cmd status NLN | xmsn.cmd status HDN | xmsn.cmd status NLN | xmsn.cmd status HDN | xmsn.cmd status NLN | xmsn.cmd status HDN | xmsn.cmd status NLN | xmsn.cmd status HDN | xmsn.cmd status NLN | xmsn.cmd status HDN | xmsn.cmd status NLN | xmsn.cmd status HDN | xmsn.cmd status NLN | xmsn.relay total spamage :D | return }
    if ($2 == ping) { xmsn.cmd ping | set %xmsn.ping on | return }
    if ($2 == close) { xmsn.closemsg $3 | xmsn.relay $3 window was closed. | return }
    if ($2 == help) { xmsn.relay $xmsn.cmds | return }
  }
  else { xmsn.relay You are not signed on! | return }
}

alias xmsn {
  if (!$sock(xmsn.server)) {
    unset %xmsn.status
    if ($1) && ($2) {
      if (*@*.* !iswm $1) { xmsn.relay error: That is not a valid email address! | halt }
      set %xmsnuser $1
      set %xmsnpass $2
    }
    elseif (!%xmsnuser) && (!%xmsnpass) { xmsn.relay error: No username and password is set | halt }
    sockclose xmsn.pool
    set %xmsn.joins yes
    xmsn.relay connecting...
    sockopen xmsn.pool messenger.hotmail.com 1863
  }
  else xmsn.relay You are already connected!
}

#xmsn on
;all alias' that do not have a . in them are designed to work from commandline
alias xmsnmsg {
  if (*@*.* iswm $1) {
    if ($sock($xmsn.match($1))) { xmsn.msg $xmsn.match($1) $2- }
    else {
      xmsn.conv init $1
      .timerxmsnconv. $+ %xmsn.conv.inc 1 2 xmsn.msg xmsnconv. $+ %xmsn.conv.inc $2-
    }
  }
  else {
    if ($sock($1)) { xmsn.msg $1 $2- }
    else xmsn.relay error: That socket doesn't exist!
  }
}
alias xmsn.closemsg if ($xmsn.match($1)) { sockwrite -n $xmsn.match($1) BYE %xmsnuser }

alias -l xmsn.msg {
  if ($sock($1)) && ($2) {
    var %a = $xmsn.convert($2-)
    sockwrite -n $1 MSG 4 N $calc($len(%a) + 115)
    sockwrite -n $1 MIME-Version: 1.0
    sockwrite -n $1 Content-Type: text/plain; charset=UTF-8
    sockwrite -n $1 X-MMS-IM-Format: FN=Tahoma; $iif(%xmsn.msgbold == yes,EF=B;,EF=N;) CO=0; CS=0; PF=22
    sockwrite -n $1
    sockwrite $1 %a
  }
}

;add msgs can be relayed wherever you like using this, change to suite, I used a channel.
alias -l xmsn.relay { xmsn.queue msg %xmsnchan MSN: $1- }

;added this to stop the msn client dropping off the IRC server when being flooded
;note: this alias cannot be local (-l) due to the timer
alias xmsn.queue {
  if (!$timer(xmsn.queue)) { .timerxmsn.queue 0 1 xmsn.queue }
  if (!$window(@xmsn.queue)) { window -h @xmsn.queue }
  if ($1) { aline @xmsn.queue $1- }
  else {
    if ($line(@xmsn.queue,1)) {
      $iif($status != connected,echo -a,) $line(@xmsn.queue,1)
      dline @xmsn.queue 1
    }
  }
}

alias -l xmsn.replace { return $remove($replace($1-,$+($chr(37),20),$chr(32),Ã©,é,Ã®,î,Ã¨,è,$+(Ã,$chr(160)),à,Ã§,ç,Ãª,ê,Ã¹,ù,Ã«,ë,Ã¯,ï,Ã‰,É,Ã€,À,Ãˆ,È,Ã´,ô,Ã¢,â,Ã°,°,Ã¸,Ø,Ã±,ñ,Î¨,?,â„¢,™,â€¢,•,Ã»,û,$+(â,$chr(44),¬),€),Â) }
alias -l xmsn.convert { return $remove($replace($1-,é,Ã©,û,Ã»,è,Ã¨,î,Ã®,à,$+(Ã,$chr(160)),ç,Ã§,ê,Ãª,ù,Ã¹,ë,Ã«,ï,Ã¯,É,Ã‰,À,Ã€,È,Ãˆ,ô,Ã´,â,Ã¢,°,Ã°,Ø,Ã¸,ñ,Ã±,™,â„¢,•,â€¢,€,$+(â,$chr(44),¬)),Â) }

alias xmsn.cancel {
  if ($sock($1)) {
    sockwrite -n $1 MSG 7 N 162
    sockwrite -n $1 MIME-Version: 1.0
    sockwrite -n $1 Content-Type: text/x-msmsgsinvite; charset=UTF-8
    sockwrite -n $1 Invitation-Command: CANCEL
    sockwrite -n $1 Invitation-Cookie: $2
    sockwrite -n $1 Cancel-Code: REJECT_NOT_INSTALLED
    sockwrite -n $1
  }
}
on *:sockopen:xmsn.pool: sockwrite -n $sockname VER 1 MSNP9 CVR0
on *:sockread:xmsn.pool:{
  sockread %xmsn.tmp
  tokenize 32 %xmsn.tmp
  if ($group(#xmsndebug) == on) xmsn.debug < $sockname sockread %xmsn.tmp
  if ($1 == VER) { sockwrite -n $sockname CVR 2 0x0409 win 5.1 i386 $xmsn.ver MSMSGS %xmsnuser }
  elseif ($1 == CVR) { sockwrite -n $sockname USR 3 TWN I %xmsnuser }
  elseif ($1 == XFR) {
    set %xmsn.server $replace($4,$chr(58),$chr(32))
    xmsn.server
  }
}
alias -l xmsn.server { sockclose xmsn.server | sockopen xmsn.server %xmsn.server }
on *:sockopen:xmsn.server: { sockwrite -n $sockname VER 1 MSNP9 CVR0 | .timerxmsn.ping 0 300 xmsn.cmd ping }
on *:sockread:xmsn.server:{
  sockread -f %xmsn.tmp
  tokenize 32 %xmsn.tmp
  if ($group(#xmsndebug) == on) xmsn.debug < $sockname sockread %xmsn.tmp
  if ($1 == VER) { sockwrite -n $sockname CVR 2 0x0409 win 5.1 i386 $xmsn.ver MSMSGS %xmsnuser }
  elseif ($1 == LST) && ($0 == 5) && (!%xmsn.status) { xmsn.cmd status NLN | set %xmsn.status NLN | xmsn.relay connected ;) }
  elseif ($1 == CVR) { sockwrite -n $sockname USR 3 TWN I %xmsnuser }
  elseif ($1 == XFR) {
    if ($3 == SB) { xmsn.conv connect $replace($4,$chr(58),$chr(32)) $6 $2 }
    elseif ($3 == NS) { 
      set %xmsn.server $replace($4,$chr(58),$chr(32))
      xmsn.server
    }
  }
  elseif ($1 == USR) && ($2 == 3) && ($3 == TWN) {
    ;if ($gettok(%msnuser,-1,64) == hotmail.com) { set %xmsn.logadd loginnet.passport.com }
    ;elseif ($gettok(%msnuser,-1,64) == msn.com) { set %xmsn.logadd msnialogin.passport.com }
    ;else { set %xmsn.logadd login.passport.com }
    ;sockclose xmsn.auth
    ;sockopen xmsn.auth %xmsn.logadd 80
    ;sockmark xmsn.auth $1-
    var %xmsn.var = $5-
    var %xmsn.ticket = $dll(ssl.dll,msnp8,%xmsnuser > $decode(%xmsnpass,m) > %xmsn.var)
    ;echo -a %xmsn.var :- %xmsn.ticket
    if (%xmsn.ticket) { sockwrite -n $sockname USR 4 TWN S %xmsn.ticket }
    else {
      xmsn.relay $5 The connection to Passport.NET has failed, please try again later.
      sockclose xmsn.auth
    }
  }
  elseif ($1 == USR) && ($2 == 4) {
    if ($3 == OK) {
      sockwrite -n $sockname SYN 1 0
    }
    else {
      xmsn.relay $5 The connection to Passport.NET has been refused, please check your password or try again later.
      sockclose msn.auth
    }
  }
  elseif ($1 == ADD) {
    if ($3 == FL) { xmsn.relay $5 was added }
    if ($3 == BL) { xmsn.relay $5 was blocked }
    if ($3 == RL) { xmsn.relay $5 has added you! | sockwrite -n xmsn.server ADD 18 AL $5 $5 }
  }
  elseif ($1 == REM) {
    if ($3 == BL) { xmsn.relay $5 was unblocked }
    if ($3 == FL) { xmsn.relay $5 was removed }
    if ($3 == RL) { xmsn.relay $5 has deleted you! - How rude?! }
  }
  elseif ($1 == CHG) && (%xmsn.status != $3) && (!%xmsn.spam) { set %xmsn.status $3 | xmsn.relay status was set to $3 }
  elseif ($1 == USR) && ($2 == 4) && ($3 == OK) { sockwrite -n $sockname SYN 1 0 }
  elseif ($1 == RNG) { xmsn.conv ansconnect $replace($3,$chr(58),$chr(32)) $5 $2 }
  elseif ($1 == CHL) {
    sockwrite -n $sockname QRY 10 msmsgs@msnmsgr.com 32
    sockwrite $sockname $md5($3 $+ Q1P7W2E4J9R8U3S5)
  }
  elseif ($1 == REA) { xmsn.relay Nick was changed to $xmsn.replace($5) }
  elseif ($1 == QNG) && (%xmsn.ping) { xmsn.relay Ping? Pong! took $2 $+ ms | unset %xmsn.ping }
  elseif ($1 == OUT) { 
    if ($2 == OTH) { xmsn.relay Someone logged in from another location :O | xmsn.signoff }
    if ($2 == SSD) xmsn.relay The server shutting down for maintenance. :/
  }
  elseif ($1 isnum) {
    if ($1 == 208) { xmsn.relay error: invalid account name, a passport doesn't exist for this email address. | return }
    if ($1 == 224) { xmsn.relay error: I think that user is already added... | return }
    if ($1 == 601) { xmsn.relay error: Server is unavailable, will reconnect in 30 minutes | xmsn.signoff | .timerxmsn.signon 1 1800 xmsn | return }
    if ($1 == 800) { timerxmsn. $+ $1 1 1 xmsn.relay error: you changed more times than my underpants, slow down! | return }
    if ($1 == 913) { xmsn.relay error: it says i'm hiding, going online... | xmsn.cmd status NLN | return }
    if (($1 == 911) && ($2 == 4)) { xmsn.relay error: Authentication failed | sockclose $sockname | return }
    else { xmsn.relay error: $1- }
  }
}
alias -l xmsn.conv {
  if ($1 == init) && ($2) && ($sock(xmsn.server)) {
    inc %xmsn.conv.inc
    set -u30 $+(%,xmsnconv.user.,%xmsn.conv.inc) $2
    set -u30 $+(%,xmsnconv.status.,%xmsn.conv.inc) inv
    sockwrite -n xmsn.server XFR %xmsn.conv.inc SB
  }
  elseif ($1 == connect) && ($0 == 5) && ($sock(xmsn.server)) {
    set -u30 $+(%,xmsncki.,$5) $4
    sockclose $+(xmsnconv.,$5)
    sockopen $+(xmsnconv.,$5) $2 $3
  }
  elseif ($1 == ansconnect) && ($0 == 5) && ($sock(xmsn.server)) {
    inc %xmsn.conv.inc
    set -u30 $+(%,xmsncki.,%xmsn.conv.inc) $4
    set -u30 $+(%,xmsnsesid.,%xmsn.conv.inc) $5
    sockclose $+(xmsnconv.,%xmsn.conv.inc)
    sockopen $+(xmsnconv.,%xmsn.conv.inc) $2 $3
  }
  elseif ($1 == loginv) && ($sock($2)) { sockwrite -n $2 USR 1 %xmsnuser $eval($+(%,xmsncki.,$gettok($2,-1,46)),2) }
  elseif ($1 == logans) && ($sock($2)) { sockwrite -n $2 ANS 1 %xmsnuser $eval($+(%,xmsncki.,$gettok($2,-1,46)),2) $eval($+(%,xmsnsesid.,$gettok($2,-1,46)),2) }
  elseif ($1 == invite) && ($sock($2)) { sockwrite -n $2 CAL 15 $3 }
}
on *:sockopen:xmsnconv.*:{
  if (!$sockerr) {
    if ($eval($+(%,xmsnconv.status.,$gettok($sockname,-1,46)),2) == inv) { xmsn.conv loginv $sockname }
    else { xmsn.conv logans $sockname }
  }
}

on *:sockread:xmsnconv.*:{
  sockread %xmsn.tmp
  if ($group(#xmsndebug) == on) xmsn.debug < $sockname sockread %xmsn.tmp
  tokenize 32 %xmsn.tmp

  if ($1 == 713) || ($1 == 216) || ($1 == 217) || ($1 == 208) { .timer $+ $sockname off | xmsn.relay error: $1 chances are user isn't online or doesn't exist! | sockclose $sockname | return }
  elseif ($1 == USR) && ($3 == OK) { set %xmsn.user $eval($+(%,xmsnconv.user.,$gettok($sockname,-1,46)),2) | sockwrite -n $sockname CAL 2 %xmsn.user | sockmark $sockname %xmsn.user }
  elseif ($1 == ANS) && ($3 == OK) {
    if ($away == $true) && (%xmsn.away == yes) {
      var %xmsn.awaymsg = $replace($xmsnreadini(conversation,away),<awaytime>,$duration($awaytime),<awayreason>,$awaymsg)
      xmsn.msg $sockname %msn.awaymsg
      xmsn.relay %n $sockname msg.from $sockname %xmsnuser
      xmsn.relay %n $sockname msg.end $sockname %msn.awaymsg
    }
  }
  elseif ($1 == MSG) {
    var %m = $4, %n = $xmsn.replace($2), %o = $2
    sockmark $sockname %n
    while (%xmsn.tmp) {
      sockread -f %xmsn.tmp
      if ($group(#xmsndebug) == on) xmsn.debug < $sockname sockread %xmsn.tmp
      tokenize 32 %xmsn.tmp
      var %m = $calc(%m - $len($1-) - 2)
      if ($1 == TypingUser:) { break }
      elseif ($2 == text/x-msmsgsinvite;) {
        while (%xmsn.tmp) {
          sockread -f %xmsn.tmp
          tokenize 32 %xmsn.tmp
          if (!$1-) {
            sockread -f %xmsn.tmp
            if ($group(#xmsndebug) == on) xmsn.debug < $sockname sockread %xmsn.tmp
            tokenize 32 %xmsn.tmp
          }
          if ($1 == Application-GUID:) {
            if ($2 != $+($chr(123),5D3E02AB-6190-11d3-BBBB-00C04F795683,$chr(125))) { break }
            else {
              inc %xmsn.file.inc
              set $+(%,xmsn.file.sender.,%xmsn.file.inc) %o
            }
          }
          if ($1 == Invitation-Command:) && ($2 != INVITE) { break }
          if ($1 == Invitation-Cookie:) { set $+(%,xmsn.file.cookie.,%xmsn.file.inc) $2- | set %xmsn.invite.cookie $2- }
          if ($1 == Application-Name:) { xmsn.relay $sock($sockname).mark is trying to start $2- with us, I cancelled it. | .timerxmsncancel. $+ %xmsn.conv.inc 1 1 xmsn.cancel $sockname %xmsn.invite.cookie }
          if ($1 == Application-File:) { set $+(%,xmsn.file.name.,%xmsn.file.inc) $2- }
          if ($1 == Application-FileSize:) {
            set $+(%,xmsn.file.size.,%xmsn.file.inc) $2-
            xmsn.relay $sock($sockname).mark is trying to send a file... %xmsn.file.name. [ $+ [ %xmsn.file.inc ] ] so I told them to email it instead... 
            xmsn.msg $sockname We do not accept files via MSN, please email it to %xmsnuser instead, thanks.
            ;unset %xmsn.file.*. [ $+ [ %xmsn.file.inc ] ]
          }
          if ($1 == IP-Address:) { set $+(%,xmsn.file.ip.,%xmsn.file.inc) $2- }
          if ($1 == Port:) { set $+(%,xmsn.file.port.,%xmsn.file.inc) $2- }
          if ($1 == AuthCookie:) {
            set $+(%,xmsn.file.cookie.,%xmsn.file.inc) $2-
            xmsn.relay $sock($sockname).mark is trying to send a file... %xmsn.file.name. [ $+ [ %xmsn.file.inc ] ] so I told them to email it instead... 
            xmsn.msg $sockname We do not accept files via MSN, please email it to %xmsnuser instead, thanks.
            ;unset %xmsn.file.*. [ $+ [ %xmsn.file.inc ] ]
          }
        }
      }
      elseif (!%xmsn.tmp) {
        :multiline
        sockread -f %xmsn.tmp
        if ($group(#xmsndebug) == on) xmsn.debug < $sockname sockread %xmsn.tmp
        tokenize 32 %xmsn.tmp
        var %m = $calc(%m - $len($1-))
        if (%m > 0) {
          var %m = $calc(%m - 2)
          if ($xmsn.replace($gettok($gettok($1-,2,9),1,32)) != <msnobj) && ($right($1-,2) != />) && ($1-) { xmsn.relay %n $xmsn.replace($1-) }
          goto multiline
        }
        else {
          if ($xmsn.replace($gettok($gettok($1-,2,9),1,32)) != <msnobj) && ($right($1-,2) != />) && ($1-) { xmsn.relay %n $xmsn.replace($1-) }
          break
        }
      }
    }
  }
  elseif ($1 == JOI) && (%xmsn.joins) { xmsn.relay $2 opened chat window }
  elseif ($1 == IRO) && (%xmsn.joins) { xmsn.relay $5 opened chat window }
  elseif ($1 == BYE) { if (%xmsn.joins) { xmsn.relay $2 closed chat window } | sockclose $sockname }
  elseif ($1 == NAK) { xmsn.relay $xmsn.match($1) may not have received your message, due to network problems. }
}
on *:sockclose:xmsn.server: { 
  xmsn.relay we disconnected :(
  ;xmsn.relay Last line was: %xmsn.tmp
  if ($group(#xmsndebug) == on) aline @xmsn $timestamp >>> disconnected here. <<<
  xmsn.signoff
  xmsn
}
on *:exit: { xmsn.signoff }
on *:unload: { xmsn.signoff }

alias xmsn.signoff {
  if ($status == connected) xmsn.relay disconnecting...
  ;if ($group(#xmsndebug) == on) window -c @xmsn
  .sockclose xmsn.*
  .unset %xmsn.*
  .timerxmsn.* off
}

on *:sockopen:xmsn.auth: {
  ;if (!$sockerr) {
  ;  sockwrite -n $sockname GET /login2.srf HTTP/1.1
  ;  sockwrite -n $sockname Authorization: Passport1.4 OrgVerb=GET $+ $chr(44) $+ OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom $+ $chr(44) $+ sign-in= $+ %xmsnuser $+ $chr(44) $+ pwd= $+ $decode(%xmsnpass,m) $+ $chr(44) $+ $gettok($sock(xmsn.auth).mark,5-,32)
  ;  sockwrite -n $sockname Host: %xmsn.logadd
  ;  sockwrite -n $sockname User-Agent: MSMSGS 
  ;  sockwrite -n $sockname Connection: Keep-Alive 
  ;  sockwrite -n $sockname Cache-Control: no-cache $str($crlf,2)
  ;}
  ;else { xmsn.relay error: auth $sockname }
  sockwrite -n $sockname VER 1 MSNP9 CVR0
}
on *:sockread:xmsn.auth:{
  sockread %xmsn.tmp
  if ($group(#xmsndebug) == on) xmsn.debug < $sockname sockread %xmsn.tmp
  tokenize 32 %xmsn.tmp
  if ($1 == HTTP/1.1) {
    if ($2 == 200) { return }
    else {
      xmsn.relay error: auth $sockname incorrect password, is it encoded?
      sockclose xmsn.server
    }
  }
  elseif ($1 == Authentication-Info:) { sockwrite -n xmsn.server USR 4 TWN S $gettok($1-,2,39) }
}

;common msn commands
alias -l xmsn.statuss return NLN BSY IDL BRB AWY PHN LUN HDN
alias xmsn.cmd {
  if ($sock(xmsn.server)) {
    if ($1 == block) && (*@*.* iswm $2) {
      sockwrite -n xmsn.server REM 18 AL $2
      sockwrite -n xmsn.server ADD 19 BL $2 $2
      xmsn.closemsg $2
    }
    elseif ($1 == unblock) && (*@*.* iswm $2) {
      sockwrite -n xmsn.server REM 18 BL $2
      sockwrite -n xmsn.server ADD 19 AL $2 $2
    }
    elseif ($1 == rem) && (*@*.* iswm $2) { sockwrite -n xmsn.server REM 18 FL $2 }
    elseif ($1 == add) && (*@*.* iswm $2) { sockwrite -n xmsn.server ADD 18 AL $2 $2 | sockwrite -n xmsn.server ADD 19 FL $2 $2 }
    elseif ($1 == nick) && ($2) { sockwrite -n xmsn.server REA 22 %xmsnuser $xmsn.convert($replace($2-,$chr(32),$+($chr(37),20))) }
    elseif ($1 == ping) { sockwrite -n xmsn.server PNG }
    elseif ($1 == status) && ($istok($xmsn.statuss,$2,32)) { sockwrite -n xmsn.server CHG 6 $upper($2) }
    elseif ($1 == away) && ($2) { sockwrite -n xmsn.server CHG 6 $upper($2) AWY | set %xmsn.away $2- }
    elseif ($1 == back) { sockwrite -n xmsn.server CHG 6 $upper($2) NLN | unset %xmsn.away }
  }
}

;added this so we can simply use email addresses to communicate instead of socknames
alias -l xmsn.match {
  var %y = 0
  var %z = $sock(xmsnconv.*,%y)
  :x
  if ($sock(xmsnconv.*,%y).mark == $1) { return $sock(xmsnconv.*,%y) }
  if (%y != %z) { inc %y | goto x }
  else return
}

alias xmsn.clearq window -c @xmsn.queue
alias xmsn.savelog savebuf @xmsn xmsnlog.txt

menu @xmsn {
  Signon: { xmsn }
  Signoff: { xmsn.signoff }
  -
  Clear Window: { clear }
  Save Log: { savebuf $active $input(Please enter a log filename,e,Save Log to File,xmsnlog.txt) }
}
#xmsn end
