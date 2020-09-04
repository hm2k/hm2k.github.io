;.o0{ Quotes v2.33 *beta* by HM2K }0o. - IRC@HM2K.ORG

;based on scripts by mutilator and tonix
;thanks to L-n and the rest of nemesisforce for helping me beta test it

;Description:
;Do you ever find that while your on mIRC, that there are just quotes that you should log,
;or should store somewhere, maybe because they are funny, or embarrassing or similar, well now you can,
;with this quotes script, you can either add/find/remove/total quotes remotely, or locally, without any hassle.
;Never miss a quote again!

;Installation: Make sure quotes.mrc is in your $mircdir then type: /load -rs quotes.mrc

;Useage: Use the "Quotes" menu to control the script, the main function is the triggers and the timer.
;Remember to turn these on from the menu if you want others to beable to use it
;Channel triggers are: !quote (random) !fquote (find) !aquote (add) !rquote (remove) !tquote (total)

;History:
;Quotes v2.33 - Added repeatcheck, fixed some code, removed timer
;Quotes v2.32 - Fixed a missing echo and removed my nick from the default admin nicklist
;Quotes v2.31 - Fixed the apparent "Make aliases the end user does not use local" problem (changed 'alias' to 'alias -l')
;Quotes v2.3 - Fixed a few bugs, changed a few things, completed the 'todo' of the previous version.
;Quotes v2.2 - The outputs no longer evaluate the line read and treat it as plain text; Therefore you're quotes.txt is no longer changed on the input.
;Quotes v2.1 - Most scripts have bugs in their initail releases, so did mine, fixed in this version
;Quotes v2.0 - Rewritten: Added made the script smaller and quicker, added more features, and popups; Features now include: Timer: on/off Triggers: on/off Total Quotes, Add Quote, Remove Quote and Find Quote
;Quotes v1.0 - Initial Public Release - Simple Code

;Settings:
alias -l quotes.txt return quotes.txt

;Core - No further editing
alias -l quote.ver return Quotes v2.33

alias -l quote.msg {
  var %y $read($quotes.txt, n, $1)
  return $+($chr(35),$1) ; $gettok(%y,3-,32) ; added by $gettok(%y,1,32) on $asctime($gettok(%y,2,32))
}
alias -l quote.rand return [Random Quote] $quote.msg($rand(1,$lines($quotes.txt)))
alias -l quote.get return [Quote] $quote.msg($remove($1,$chr(35)))
alias -l quote.find return [Find Quote] $iif($read($quotes.txt, n, w, $+($chr(42),$1,$chr(42))),$quote.msg($readn),Not Found)
alias -l quote.call {
  if (!$2) return $quote.rand
  if ($chr(35) isin $2) return $quote.get($2)
  return $quote.find($2-))
}
alias -l quote.add {
  if (!$2) return [Quote Add] You must supply text
  write $quotes.txt $1 $ctime $2
  return [Quote Added] Quote $chr(35) $+ $lines($quotes.txt) was added successfully!
}
alias -l quote.rem {
  if (!$2) return [Quote Remove] You must supply a number
  if ($numtok($2,32) > 0) { write -dl $+ $2 $quotes.txt | return [Quote Removed] Quote # $+ $2 was removed. }
  return [Quote Remove] Invalid quote number
}
alias -l quote.total { return [Total Quotes] $lines($quotes.txt) Quotes }

#quote.triggers off
on *:text:!quote*:*: { $quote.relay $quote.call($2) | $repeatcheck(!quote) }
on *:text:!fquote *:*: { $quote.relay $quote.find($2) | $repeatcheck(!findquote) }
on *:text:!aquote*:*: { $quote.relay $quote.add($nick,$2-) | $repeatcheck(!addquote) }
;for !rquote to work use see /help User List
on 10:text:!rquote*:*: { $quote.relay $quote.rem($nick,$2) | $repeatcheck(!removequote) }
on *:text:!tquote:*: { $quote.relay $quote.total | $repeatcheck(!totalquote) }
#quote.triggers end

alias -l quote.relay {
  var %out echo $color(info2) -gat
  if ($modespl) {
    if ($1) {
      if (($ifmatch != Status Window) && ($ifmatch != -)) {
        if ($left($1,1) != $chr(35)) { var %out msg $1 }
        elseif ($chan($1)) { var %out msg $1 }
      }
    }
    elseif (($nick) && ($nick != $me)) var %out notice $nick
  }
  return %out
}

alias -l repeatcheck { ;v0.12 by HM2K - will disable the appropriate group if its flooded
  var %rep.lim = 3
  var %rep.t.lim = 25
  var %rep.t.expr = 10
  if (%rep.lockusr- [ $+ [ $nick ] ]) { echo $ifmatch | haltdef }
  inc $+(-u,%rep.t.lim,$chr(32),%,rep-,$nick,.,$len($strip($1-)),.,$hash($strip($1-),32)) 1
  if (%rep- [ $+ [ $nick ] $+ . $+ [ $len($strip($1-)) ] $+ . $+ [ $hash($strip($1-),32) ] ] == %rep.lim) {
    ;ignore -u60 $address($nick,5)
    if ($group($chr(35) $+ $1) == on) { .disable $chr(35) $+ $1 | .echo -gat $1 is $group($chr(35) $+ $1) due to a repeat flood from $iif($chan,$nick in $chan,$nick) $+ , to re-enable: /enable $chr(35) $+ $1 }
    .set $+(-u,%rep.t.expr,$chr(32),%,rep.lockusr-,$nick) 1
  }
}

menu channel,menubar,query { 
  $quote.ver
  .Quote Triggers ( $+ $group(#quote.triggers) $+ ): {
    if ($group(#quote.triggers) == off) { .enable #quote.triggers }
    else { .disable #quote.triggers }
    .echo $colour(info2) -ta [Quote Triggers] $group(#quote.triggers)
  }
  .-
  .Say Random Quote: { say $quote.rand }
  .Say Find Quote: { say $quote.call($input(Find A Quote,1,- Quotes,$chr(32))) }
  .Say Total Quotes: { say $quote.total }
  .Echo Random Quote: { echo $quote.rand }
  .Echo Find Quote: { echo $quote.call($input(Find A Quote,1,- Quotes,$chr(32))) }
  .Echo Total Quotes: { echo $quote.total }
  .-
  .Add Quote: { $quote.add($me,$input(Add a quote,1,- Quotes,)) }
  .Remove Quote: { $quote.rem($me,$input(Enter The Quote Number to remove,1,- Quotes,1)) }
  .-
  .Clear Quotes Database
  ..Are you sure
  ...Yes: .write -c $quotes.txt | echo $colour(info2) -ta [Clear Quotes Database] Successful!
  ...No: echo $colour(info2) -ta [Clear Quotes Database] Failed!
}
