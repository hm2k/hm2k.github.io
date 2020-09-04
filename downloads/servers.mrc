;Server v0.1 - Writes the current servers to servers.txt useful for EFnet
alias servers { .enable #servers | .write -c servers.txt | .raw links }
#servers off
raw 364:*: {
  haltdef
  if ((services !isin $2) && (hub !isin $2) && (stats !isin $2) && (ircd !isin $2)) {
    if ($chr(42) isin $2) { .write servers.txt $replace($2,*.,irc.) }
    else { .write servers.txt $+($chr(32),$2) }
  }
}
raw 365:*: { haltdef | .disable #servers | run servers.txt }
#servers end