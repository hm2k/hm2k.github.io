;.oO{ lnks v0.1 *BETA* by HM2K }Oo. - IRC@HM2K.ORG

;Installation: Make sure smlnk.mrc is in your $mircdir then type: /load -rs lnks.mrc

;lnks v0.1   - Changed the script from the smLNK project to lnks.us, now uses POST instead of GET.
;lnks.us by netmunky will be used instead of smLNK, as it works in a very similar way.

;the smLNK project is no more, so no more script.
;smLNK v0.3	- Completly new system since smLNK.com has completly changed *NOT WORKING*
;smLNK v0.21	- A couple of bugs ironed out, nothing major, uses POST instead of GET
;smLNK v0.2	- No longer uses the EFnet smlnk bot for lookups, better error checking, still buggy.
;smLNK v0.11	- Bugs fixed, menu added, extra options, more error checking, and triggers
;smLNK v0.1	- Original release, used the EFnet smlnk bot to do lookups

alias lnks.ver return lnks v0.1
alias lnks {
  if (!$1) { echo $colour(info2) * lnks usage: /lnks <url|key> | return }
  if ($left($1,7) == http://) { 
    if ($len($1) < 18) { echo $colour(info2) * lnks: urls must be more than 18 characters | return }
    else { set %lnks $1 }
  }
  else { echo $colour(info2) * lnks: Invalid URL | return }
  var %lnks.i 0
  :i
  inc %lnks.i 1
  var %lnks.x lnks_ $+ %lnks.i
  if ($sock(%lnks.x) != $null) { goto i }
  sockopen %lnks.x lnks.us 80
  sockmark %lnks.x URL= $+ %lnks $+ &submit=
}
on *:sockopen:lnks_*: {
  if ($sockerr > 0) { return }
  sockwrite -tn $sockname POST / HTTP/1.1
  sockwrite -tn $sockname Content-Type: application/x-www-form-urlencoded
  sockwrite -tn $sockname Host: lnks.us
  sockwrite -tn $sockname Content-Length: $len($sock($sockname).mark)
  sockwrite -tn $sockname Connection: Close
  sockwrite -tn $sockname 
  sockwrite -tn $sockname $sock($sockname).mark
}
on *:sockread:lnks_*: {
  if ($sockerr > 0) { return }
  :i
  if ($sock($sockname) != $null) { sockread -f %lnks.y }
  if ($sockbr == 0) { return }
  ;This is for debug mode only
  ;if ($window(@lnks) == $null) { window @lnks }
  ;if (%lnks.y) { aline @lnks %lnks.y }
  if (*Your link is: <a href="http://lnks.us/*">http://lnks.us/*</a>* iswm %lnks.y) { set %lnks.out $gettok(%lnks.y,2,34) }
  goto i
}
on *:sockclose:lnks_*: { echo -gat Your link is: %lnks.out | unset %lnks.* }
