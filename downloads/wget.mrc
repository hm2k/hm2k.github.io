;.oO{ wget for mIRC v0.8 *beta* by HM2K }Oo. - IRC@HM2K.ORG

;download dir - change to your download directory.
alias -l wgetdir { return $mircdirdownloads $+ \ }
;user agent - i figured this may come in handy if the server has checks
alias -l wgetua { return Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.7.12) Gecko/20050919 Firefox/1.0 }
alias wget {
  if !$1 { echo Usage: /wget <url> | return }
  :x
  var %x wget_ $+ $rand(100000,999999)
  if $sock(%x) { goto x }
  if !$hget(wget) { hmake wget }
  hadd3d wget %x url $1
  hadd3d wget %x host $gettok($gettok($remove($1-,http://),1,47),1,58)
  var %y $gettok($gettok($remove($1-,http://),1,47),2,58)
  hadd3d wget %x port $iif(%y,%y,80)
  hadd3d wget %x path $replace($+(/,$gettok($remove($1-,http://),2-,47)),$chr(32),$chr(37) $+ 20)
  hadd3d wget %x file $wgetdir $+ $iif($remove($nopath($hget3d(wget,%x,path)),$chr(034),$chr(042),$chr(047),$chr(058),$chr(060),$chr(062),$chr(063),$chr(092),$chr(124)),$ifmatch,$hget3d(wget,%x,host) $+ .html)
  sockopen %x $hget3d(wget,%x,host) $hget3d(wget,%x,port)
}
alias wgetstop { sockclose wget_* }
on *:sockopen:wget_* {
  if $sockerr { halt }
  echo wget(open): $+($hget3d(wget,$sockname,host),:,$hget3d(wget,$sockname,port),$hget3d(wget,$sockname,path))
  sockwrite -n $sockname GET $hget3d(wget,$sockname,path) HTTP/1.1
  sockwrite -n $sockname Host: $+($hget3d(wget,$sockname,host),:,$hget3d(wget,$sockname,port))
  sockwrite -n $sockname User-Agent: $wgetua
  sockwrite -n $sockname Accept: */*
  sockwrite -n $sockname Pragma: no-cache
  sockwrite -n $sockname Proxy-Connection: keep-alive
  sockwrite -n $sockname Keep-Alive: 300
  sockwrite -n $sockname Connection: keep-alive
  sockwrite -n $sockname $crlf
}
on *:sockread:wget_* {
  if $sockerr { halt }
  if (!$sock($sockname).mark) {
    sockread %wget.header
    tokenize 32 %wget.header
    if (($1 == HTTP/1.1) && ($2 == 404)) { echo wget(error): file not found | sockclose $sockname | halt }
    if (Location: * iswm $1-) { 
      echo wget(moved): wget $gettok(%wget.header,2-,32)
      if ($gettok(%wget.header,2-,32) != $hget3d(wget,$sockname,url)) { wget $gettok(%wget.header,2-,32) } 
      else { echo wget(error): this move causes a loop. halted. }
      sockclose $sockname 
      halt
    }
    if (Content-Disposition: * iswm $1-) { echo wget(file): $gettok(%wget.header,2,61) | hrep3d wget $sockname file $wgetdir $+ $gettok(%wget.header,2,61) }
    if (Content-length: * iswm $1-) { hrep3d wget $sockname size $gettok(%wget.header,2,32) }
    if (!$1) { sockmark $sockname 1 | write -c $hget3d(wget,$sockname,file) | break }
    ;debug - uncomment the line below to view headers
    else { echo wget(header): %wget.header | unset %wget.header }
  }
  else {
    :sockread
    sockread &x
    if (!$sockbr) { return }
    bwrite $hget3d(wget,$sockname,file) -1 -1 &x
    if ($file($hget3d(wget,$sockname,file)).size < $hget3d(wget,$sockname,size)) { goto sockread }
    else { halt }
  }
}
on *:sockclose:wget_* {
  if ($exists($hget3d(wget,$sockname,file))) { echo wget(close): $hget3d(wget,$sockname,file) $sock($sockname).rcvd bytes }
  else { echo wget(close): no file was written. }
}

alias encodeurlpath { ;v0.1 - added to ensure urls are formatted correctly
  var %i = 0, %r | while (%i < $len($1-)) {
    inc %i
    %c = $mid($1-,%i,1)
    if ((%c isalnum) || ($istok(/ . -,%c,32))) { %r = %r $+ %c }
    else { %r = %r $+ $chr(37) $+ $base($asc(%c),10,16,2) }
  }
  return %r
}

;$hget3d(<name>,<item>,<subitem>)
alias -l hget3d return $hget($1,$+($2,-,$3))
;/hadd3d <name> <item> <subitem> <data>
alias -l hadd3d hadd $1 $+($2,-,$3) $4-
;/hdel3d <name> <item> <subitem>
alias -l hdel3d hdel $1 $+($2,-,$3)
;/hrep3d <name> <item> <subitem> <data>
alias -l hrep3d { hdel $1 $+($2,-,$3) | hadd $1 $+($2,-,$3) $4- }
