;whatchans usage /whatchans <nick>
alias whatchans { ;v0.3
  if !$1 { echo $colour(info2) * Usage: /whatchans <nick> | return }
  var %i = $comchan($1,0)
  var %j = 0
  var %k
  if (%i == $null) { echo $colour(info2) * $1 isn't on any matching channels | return }
  :start
  inc %j
  var %k = %k $comchan($1,%j)
  if (%i == %j) { echo $colour(info2) * $1 matches %i channels: %k }
  else goto start
}