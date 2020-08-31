;.oO{ IPNG Updater v0.2 by HM2K }Oo. - IRC@HM2K.ORG

;Installation: Make sure ipng.mrc are in your $mircdir then type: /load -rs ipng.mrc

alias ipng.ver return ipng Updater v0.2
alias ipng.out return echo $color(info2 text) -at * IPNG
alias ipng {
  if (%ipng_username == $null) { set %ipng_username $?="IPNG Username" }
  if (%ipng_password == $null) { set %ipng_password $encode($?*="IPNG Password",m) }
  set %ipng.ipurl $1
  if ((. !isin %ipng.ipurl) || (%ipng.ipurl == $null)) { $ipng.out Error: Usage: /ipng <url or ip> | ipng.ip | halt }
  if ((%ipng_username == $null) || (%ipng_password == $null)) { $ipng.out Error: Username or Password Mismatch/Error | halt }
  set %ipng.sock /cgi-bin/update.cgi?username= $+ %ipng_username $+ &password= $+ $decode(%ipng_password,m) $+ &ip= $+ %ipng.ipurl
  $ipng.out Account: %ipng_username updating to: %ipng.ipurl
  var %ipng.i 0
  :i
  inc %ipng.i 1
  var %ipng.x ipng_ $+ %ipng.i
  if ($sock(%ipng.x) != $null) { goto i }
  sockopen %ipng.x www.ipng.org.uk 80
  sockmark %ipng.x %ipng_username
}
on *:sockopen:ipng_*: {
  if ($sockerr > 0) { return }
  sockwrite -tn $sockname GET %ipng.sock HTTP/1.0
  sockwrite -tn $sockname Host: ipng.org.uk
  sockwrite -tn $sockname $crlf
}
on *:sockread:ipng_*: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname) != $null) { sockread -f %ipng.y }
  if ($sockbr == 0) { return }
  var %ipng.y $remove(%ipng.y,<,>,/)
  if (not updating without authorisation isin %ipng.y) { $ipng.out Error: The specified username/password is incorrect! }
  if (Do you know what you are doing isin %ipng.y) { $ipng.out Error: Unknown... }
  goto i
}
on *:sockclose:ipng_*: { unset %ipng.* }
menu * {
  $ipng.ver
  .Read Documentation: run ipng.txt
  .Change Username: { set %ipng_username $?="IPNG Username" | $ipng.out Settings: Username is: %ipng_username }
  .Change Password: { set %ipng_password $encode($?="IPNG Password",m) | $ipng.out Settings: Password is: $str($chr(42),$len($decode(%ipng_password,m))) }
  .Change to an IP: ipng $input(IP (eg 127.0.0.1),1,- IP,.)
  .Change to my IP: ipng.ip
  .Auto update to my IP on connect [ON/OFF] $+ %ipng_autoip : {
    if ((%ipng_autoip == off) || (%ipng_autoip == $null)) { set %ipng_autoip on | $ipng.out Settings: To auto update to my IP now type: /ipng.ip }
    else { set %ipng_autoip off }
    $ipng.out Settings: Auto update to my IP on connect: %ipng_autoip
  }
}
on *:connect: if (%ipng_autoip == on) { ipng.ip }
alias ipng.ip { .sockopen ipipng www.whatismyip.com 80 }
on *:SOCKOPEN:ipipng:{
  if (!$sockerr) {
    .sockwrite -nt $sockname $1- GET / HTTP/1.0
    .sockwrite -nt $sockname $1- Host: www.whatismyip.com
    .sockwrite -nt $sockname $1- Connection: Close
    .sockwrite -nt $sockname $1- $crlf
  }
}
on *:SOCKREAD:ipipng:{
  if (!$sockerr) {
    .sockread %x
    if (*<title>* iswm %x) { .enable #ip_ipng | .dns $gettok(%x,4,32) }
  }
}
#ip_ipng on
on *:DNS:localinfo $iif($naddress,$ifmatch,$iaddress) $iaddress | ipng $ip | .disable #ip_ipng
#ip_ipng end
