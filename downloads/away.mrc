;.o0{ Away v0.3 by HM2K }0o. - IRC@HM2K.ORG

;Installation: Make sure away.mrc is in your $mircdir then type: /load -rs away.mrc

;Tips: In IRC Options enable: Cancel away on activity

alias F6 a
alias a {
  if (!$away) {    
    if ($1 == bbl) { var %awaymsg = be back later }
    if ($1 == brb) { var %awaymsg = be right back }
    if ($1 == bbs) { var %awaymsg = be back soon }
    if ($1 == sleep) { var %awaymsg =  gone to sleep }
    if ($1 == food) { var %awaymsg =  eating  }
    if ($1 == out) { var %awaymsg = gone out }
    if ($1 == work) { var %awaymsg = working }
    if ($1 == sch) { var %awaymsg =  at school }
    if ($1 == col) { var %awaymsg =  at college }
    if ($1 == afk) { var %awaymsg =  away from keyboard }
    if ($1 == bnc) { var %awaymsg =  detached from bnc }
    if ($1 == auto) { var %awaymsg = auto away after $duration($idle)) }
    elseif ($1) { var  %awaymsg = $1- }

    if (!%awaymsg) { var %awaymsg = not here }
    away %awaymsg
    if ($group(#awayame) == on) awayame

  }
  else {
    away
    if ($group(#awayame) == on) { awayame }
    if ($group(#autoaway) == on) { autoaway }
  }
}

alias -l awaywin {
  var %win @away
  if (!$window(%win)) { window -e %win }
  if ($1-) { aline %win $timestamp $1- }
}
on *:text:*:*: { awayrelay $1- }
on *:action:*:*: { awayrelay $1- }
on *:notice:*:*: { awayrelay $1- }
alias awayrelay {
  if (($me isin $1-) && ($away) && ($idle > 3600)) {
    awaywin $+(<,$iif($chan,$nick @ $chan,$nick),>) $1-
    ;notice $nick $me has been away for $duration($awaytime) $iif($awaymsg,$awaymsg,)
  }
}


raw *:* {
  if ($numeric == 305) { haltdef | echo -gat You are no longer marked as away $iif($network,$+([,$network,]),) }
  if ($numeric == 306) { haltdef | echo -gat You have been marked as away $iif($network,$+([,$network,]),) }
}

#awayame off
alias -l awayame {
  if ($away) {
    if ($1) { ame is away $+([,$1,]) }
    elseif ($awaymsg) { ame is away $+([,$awaymsg,]) }
    else { ame is away }
  }
  else {
    ame is back after $duration($awaytime)
  }
}
#awayame end

;how long (in seconds) our idle time should be until we set as away
alias -l autoawaytime return 1200
;how often (in seconds) we should check to see if we're idle
alias -l autoawaycheck return 120

#autoaway on
on *:connect: autoaway
alias autoaway {
  if ($away) { return }
  if ($idle > $autoawaytime) { a auto | return }
  if (!$timer(autoaway)) { .timerautoaway $+ $network 0 $autoawaycheck autoaway }
}
#autoaway end
