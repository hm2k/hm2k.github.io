;.oO{ CJB Updater v0.17 by HM2K }Oo. - IRC@HM2K.ORG

;Description:
;This is an mIRC frontend of CJB.Netter for Windows.
;This script allows you using mIRC sockets to connect to CJB.NET
;and change your IP or URL assigned to your account,
;and you can even make it update to your own IP automaticly when you connect to IRC.
;Enjoy!

;Please sign up for a CJB.NET account before loading at: http://www.cjb.net/register.html

;Installation: Make sure cjb.mrc is in your $mircdir then type: /load -rs cjb.mrc

;When you load up the script it should automaticly ask you for your account details.
;If not use "Change Username" and "Change Password" to change your account details.

;Usage: /CJB <url or ip> (Note if a url or ip is not provided, it will use your own ip by default)

;CJB Updater v0.17	- Simplified, and more reliable.
;CJB Updater v0.16	- Ip lookup fix
;CJB Updater v0.15	- Now unsets username and password on unload, Menu is now only status,menubar,channel,query
;			- You now have the option to store your password, or simply enter it each time, input changed also.
;CJB Updater v0.14	- Added external ip lookup, instead of the unreliable local lookup
;CJB Updater v0.13	- Outputs changed to be more like mIRC 6.02, error checking fixed
;CJB Updater v0.12	- More updates/chages bug fixes etc
;CJB Updater v0.11	- Released to CJB.NET, fixes, error checking, and more user friendly
;CJB Updater v0.1	- Original release, a few bugs, not very user friendly

alias cjb.ver return CJB Updater v0.17

alias -l cjb.prefix return * CJB.NET:
alias -l cjb.out return $cjb.relay($1-) $cjb.prefix
alias -l cjb.relay {
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
  return %out
}
on *:load: cjb.auth
alias cjb {
  if (!%cjb_name) { $cjb.out Error: Username or Password Mismatch/Error | cjb.auth | halt }
  set %cjb.sock /cgi-bin/dynip.cgi?username= $+ $cjb.name $+ &password= $+ $cjb.pass
  if ($1) {
    if (*.*.*.* iswm $1) { set %cjb.sock $+(%cjb.sock,&url=,$1) }
    else { set %cjb.sock $+(%cjb.sock,&url=,$1) }
  }
  $cjb.out Account: http:// $+ %cjb_name $+ .cjb.net is updating...
  var %cjb.sockid = $cjb.sockid
  sockopen %cjb.sockid www.cjb.net 80
  sockmark %cjb.sockid %cjb_name
}
alias cjb.sockid {
  var %i 0
  :i
  inc %i
  var %x cjb. $+ %i
  if ($sock(%x) != $null) { goto i }
  return %x
}
alias cjb.name return $iif(%cjb_name,%cjb_name,$?="CJB.NET Username")
alias cjb.pass return $iif(%cjb_pass,$decode(%cjb_pass,m),$?*="CJB.NET Password")
alias cjb.auth {
  if (!%cjb_name) { set %cjb_name $?="CJB.NET Username" }
  if (!%cjb_pass) { set %cjb_pass $encode($?*="CJB.NET Password",m) }
}
on *:sockopen:cjb.*: {
  if ($sockerr > 0) { return }
  .sockwrite -nt $sockname GET %cjb.sock HTTP/1.0
  .sockwrite -nt $sockname $crlf
}
on *:sockread:cjb.*: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname) != $null) { sockread -f %y }
  if ($sockbr == 0) { return }
  if (password is incorrect isin %y) { $cjb.out Error: The specified password is incorrect! }
  if (updated isin %y) {
    .!echo -q $regex($sockname,%y,/<body>(.+?)</body/gi)
    if ($regml($sockname,0)) { $cjb.out $striphtml($regml($sockname,1)) }
  }
  goto i
}
on *:sockclose:cjb.*: { unset %cjb.* }
menu status,menubar,channel,query {
  $cjb.ver
  .Change to my IP: cjb.ip
  .Change to a URL: CJB $input(URL of your site (eg http://www.hm2k.com/),1,- URL,http://)
  .Change to an IP: CJB $input(IP of your site or domain (eg 127.0.0.1),1,- URL,.)
  .-
  .Change Username: { set %cjb_name $?="CJB.NET Username" | $cjb.out Settings: Username is: %cjb_name }
  .Change Stored Password: { set %cjb_pass $encode($?="CJB.NET Password",m) | $cjb.out Settings: Password is: $str($chr(42),$len($decode(%cjb_pass,m))) }
  .Read Documentation: run cjb.txt
  .-
  .Auto update to my IP on connect $+([,$group(#cjb_ip),]) : {
    if ($group(#cjb_ip) == off) { .enable #cjb_ip | $cjb.out Settings: To auto update to my IP now type: /cjb.ip }
    else { .disable #cjb_ip }
    $cjb.out Settings: Auto update to my IP on connect is $group(#cjb_ip)
  }
}

on *:unload: { .unset %cjb_* }

alias -l striphtml { !.echo -q $regsub(< $+ $1- $+ <>,/<[^>]*>/g,$chr(32),%x) | return %x }

#cjb.sockdebug off
alias -l sockdebug { ;v0.03 by HM2K (updated: 16/09/08)
  var %win @cjb
  if (!$window(%win)) { window -e %win }
  if ($1-) { aline -p %win $timestamp $1- }
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
#cjb.sockdebug end

;EOF
