alias badword { ;badword v0.3 by HM2K Usage: $badword($1-)
  var %x = bitch asshole fuck nigger shit bastard whore slut wanker cunt slag dick prick arse nigger cock faggot niggah pussy penis vagina
  var %y = 0
  var %z = $numtok(%x,32)
  while (%y < %z) {
    inc %y
    if ($gettok(%x,%y,32) isin $1-) { return $true }
  }
  return $false
}