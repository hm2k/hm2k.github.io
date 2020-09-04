alias findstr { ; v0.1 by HM2K (Updated: 23/05/08)
  if (!$3) { echo -a Usage: /findstr <path> <file-match> <string-match> | halt }
  var %win = @findstr
  if (!$window(%win)) { window -de %win }
  var %files = $findfile($1,$2,0)
  var %i = 1
  while (%i < %files) {
    filter -fwn $findfile($1,$2,%i) %win $+(*,$3,*)
    if ($filtered) { aline %win $findfile($1,$2,%i) }
    inc %i
  }
  aline %win No More Results.
}
