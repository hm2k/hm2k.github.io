;scripts for use with psyBNC

#psybnc on
on *:text:*:?: {
  if (($nick == -psyBNC) && ($1 != BHELP)) {
    if (PLAYPRIVATELOG isin $1-) { .QUOTE PLAYPRIVATELOG }
    if (DCCANSWER isin $1-) { .QUOTE DCCANSWER $1 }
    if (DCCGET isin $1-) { .QUOTE DCCGET $13 $14 }
  }
}
on *:notice:*:?: {
  if (($nick == -psyBNC) && ($1 != BHELP)) {
    if (PLAYPRIVATELOG isin $1-) { .QUOTE PLAYPRIVATELOG }
    if (DCCANSWER isin $1-) { .QUOTE DCCANSWER $1 }
    if (DCCGET isin $1-) { .QUOTE DCCGET $13 $14 }
  }
}
alias elog .QUOTE ERASEPRIVATELOG
alias psyservers {
  %i = 1
  %t = $numtok($1-,32)
  while (%i <= %t) {
    addserver $gettok($1-,%i,32) :6667
    inc %i
  }
}
#psybnc end
