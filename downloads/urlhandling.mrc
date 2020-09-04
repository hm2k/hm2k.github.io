;A collection of functions for URL handling for mIRC (similar to the ones found in PHP) by HM2K
;$parse_url,$pathinfo,$realpath,$getservbyname,$getservbyport,$urlencode,$urldecode,$rawurlencode,$rawurldecode

alias parse_url { ;url parser v0.01 by HM2K (Updated: 24/04/08)
  ;Example Usage: $parse_url(http://user:pass@www.example.org:80/path/file?query=string#frag).auth

  ; Based on: parse_url() by PHP && $urlget() by myggan && $parse_url() by Dark_Sun
  ; Usage: $parse_url(<url>).<scheme|user|pass|host|port|path|query|fragment|bitmask>
  ; Features:
  ;  * Short and simple yet easy to read and understand
  ;  * No defaults or validation (not the job of a parser)
  ;  * RFC 3986 compliant
  ;  * Use of regex means if a component is missing, it will parse the rest anyway
  ;  * Uses properties ($prop) instead of tokens ($2) as "," (commas) contained in URLs are valid
  ;  * Matches components (1:scheme,2:user,3:pass,4:host,5:port,6:path,7:query,8:fragment)
  ;  * Supports bitmasks (1:scheme,2:user,4:pass,8:host,16:port,32:path,64:query,128:fragment)

  if (!$1 && !$prop) { return }
  var %regex = $parse_url_regex
  if ($regex(url,$1,%regex)) {
    if ($prop isnum) {
      ;return $regml(url,$prop)
      var %out = ""
      if ($isbit($prop,1) && $regml(url,1)) { var %out = %out $+ $regml(url,1) }
      if ($isbit($prop,2) && $regml(url,2)) { var %out = %out $+ $regml(url,2) }
      if ($isbit($prop,3) && $regml(url,3)) { var %out = %out $+ $regml(url,3) }
      if ($isbit($prop,4) && $regml(url,4)) { var %out = %out $+ $iif($regml(url,2) || $regml(url,3),@) $+ $regml(url,4) }
      if ($isbit($prop,5) && $regml(url,5)) { var %out = %out $+ $regml(url,5) }
      if ($isbit($prop,6) && $regml(url,6)) { var %out = %out $+ $regml(url,6) }
      if ($isbit($prop,7) && $regml(url,7)) { var %out = %out $+ $regml(url,7) }
      if ($isbit($prop,8) && $regml(url,8)) { var %out = %out $+ $regml(url,8) }
      return %out
    }
    if ($prop == scheme) return $gettok($regml(url,1),1,58)
    if ($prop == user) return $regml(url,2)
    if ($prop == pass) return $replace($regml(url,3),:,)
    if ($prop == host) return $replace($regml(url,4),@,)
    if ($prop == port) return $replace($regml(url,5),:,)
    if ($prop == path) return $regml(url,6)
    if ($prop == query) return $regml(url,7)
    if ($prop == fragment) return $regml(url,8)
  }
}

;parse url regex by HM2K (Updated: 06/05/08)
alias parse_url_regex {
  ; Note: the |() is required otherwise it won't return null results in the correct places
  var %1 = (?:(?:\w+):?(?:\x2F\x2F)?|())
  var %2 = (?:([^@:]+)|()())
  var %3 = (?:(:[^@]*)|())
  var %4 = (?:([^:\x2F]+)|())
  var %5 = (?::([^\x2F]+)|())
  var %6 = (?:([^?#]+)|())
  var %7 = (?:(\?[^#]*)|())
  var %8 = (?:(\#.*)|())
  var %regex = /^( $+ $+(%1,%2,%3,%4,%5,%6,%7,%8) $+ )/i
  return %regex
}

;path parser v0.01 by HM2K (Updated: 24/04/08)
alias pathinfo {
  if (!$1 && !$prop) { return }
  if ($prop == dirname) { return $nofile($1-) }
  if ($prop == basename) { return $nopath($1-) }
  if ($prop == extension) { return $gettok($nopath($1-),$numtok($nopath($1-),46),46) }
  if ($prop == filename) { return $gettok($nopath($1-),1- $+ $calc($numtok($nopath($1-),46) -1),46) }
}

;realpath - returns canonicalized/normalized absolute pathname
;Based on a script by sat @ #mirc (EFnet)
alias realpath {
  var %t = $iif($right($1-,1) == /,/), %r = "", %i = 0
  while (%i < $numtok($1-,47)) {
    inc %i
    if ($gettok($1-,%i,47) == .) %r = %r $+ $iif($right(%r,1) != /,/)
    elseif ($gettok($1-,%i,47) != ..) %r = $instok(%r,$ifmatch,0,47)
    else {
      if (!$numtok(%r,47)) return $null
      %r = $deltok(%r,-1,47) $+ /
    }
  }
  return $iif(%r != /,/) $+ %r $+ $iif((%r != $null) && ($right(%r,1) != /),%t)
}

;getservbyname / getservbyport based on functions by PHP
alias getservfile { return c:\windows\system32\drivers\etc\services }
alias getserv {
  if ($1 isnum) { return $gettok($read($getservfile, nw, $+(*,$1,/,$iif($2,$2,tcp),*)),1,32) }
  else { return $gettok($gettok($read($getservfile, nw, $+($1,$chr(32),*,/,$iif($2,$2,tcp),*)),2,32),1,47) }
}
alias getservbyname { return $getserv($1) }
alias getservbyport { return $getserv($1) }

;(raw)url(en/de)code v0.03 by HM2K (Updated: 24/04/08)
;Based on (raw)url(en/de)code by PHP and a script by sat @ #mirc (EFnet)
;Description: Encodes a string which are non-alphanumeric characters (except -_), spaces encoded as plus (+) symbols

alias urlencode {
  var %t = $len($1-),%r = "",%c
  while (%t) {
    %c = $asc($right($1,%t))
    ;if (%c == 32) { %c = + }
    ;do not encode if %c is 48-57,65-90,97-122,45,95,46
    if (((%c < 48) || (%c > 57)) && ((%c < 65) || (%c > 90)) && ((%c < 97) || (%c > 122)) && (%c != 45) && (%c != 95) && (%c != 46)) { %c = % $+ $base($ifmatch,10,16,2) }
    else { %c = $chr(%c) }
    %r = %r $+ %c
    dec %t
  }
  return %r
}

alias phpurlencode {
  var %t = $len($1-),%r = "",%c
  while (%t) {
    %c = $asc($right($1,%t))
    if (%c == 32) { %c = + }
    ;do not encode if %c is 48-57,65-90,97-122,45,95,46
    elseif (((%c < 48) || (%c > 57)) && ((%c < 65) || (%c > 90)) && ((%c < 97) || (%c > 122)) && (%c != 45) && (%c != 95) && (%c != 46)) { %c = % $+ $base($ifmatch,10,16,2) }
    else { %c = $chr(%c) }
    %r = %r $+ %c
    dec %t
  }
  return %r
}
alias urldecode {
  var %t = $replace($1-,+,$chr(32),% $+ 20,$chr(32)), %r = ""
  while ($regex(%t,/%([0-9A-F]{2})/i)) {
    .echo -q $regsub(%t,/(.*?)%([0-9A-F]{2})/i,,%t) 
    %r = %r $+ $regml(1) $+ $chr($base($regml(2),16,10)))
  }
  return %r $+ %t
}
alias rawurlencode { ;rawurlencode v0.02 by HM2K (Updated: 24/04/08)
  ;Based on: rawurlencode() by PHP
  ;Description: Encodes a string according to RFC 1738
  var %t = $len($1-),%r = "",%c
  while (%t) {
    %c = $asc($right($1,%t))
    %c = % $+ $base(%c,10,16,2)
    %r = %r $+ %c
    dec %t
  }
  return %r
}
alias rawurldecode {
  var %t = $replace($1-,% $+ 20,$chr(32)),%r = ""
  while ($regex(%t,/%([0-9A-F]{2})/i)) {
    .echo -q $regsub(%t,/(.*?)%([0-9A-F]{2})/i,,%t) 
    %r = %r $+ $regml(1) $+ $chr($base($regml(2),16,10)))
  }
  return %r $+ %t
}

;EOF
