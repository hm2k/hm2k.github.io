;.oO{ Oper Commands v0.4 by HM2K }Oo. - IRC@HM2K.ORG

menu nicklist {
  -
  Oper Commands
  .KILL: { .QUOTE KILL $?="Time:" $$* $?="Nick/HOST:" :$?="Reason:" }
  .KLINE: { .QUOTE KLINE $?="Time:" $$* $?="Nick/HOST:"  :$?="Reason:" }
  .UNKLINE: { .QUOTE UNKLINE $$* }
  .-  
  .OPs:.samode $chan +o $$*
  .Force Join:.sajoin $$* $?="Chan:"
  .Force Part:.sapart $$* $?="Chan:"
  .Change Host:.QUOTE CHGHOST $$* $?="Host:"
  .Change Ident:.QUOTE CHGIDENT $$* $?="Ident:"
  .Change Name:.QUOTE CHGNAME $$* $?="Name:"
}
menu status,channel {
  -
  Server Commands
  .LUSERS:.QUOTE LUSERS
  .LINKS:.QUOTE LINKS
  .LIST:.QUOTE LIST
  .MOTD:.QUOTE MOTD
  .VERSION:.QUOTE VERSION
  .-
  .WHO:.QUOTE WHO $?="Host:"
  .WHOWAS:.QUOTE WHOWAS $?="Nick:"
  .DNS:.QUOTE DNS $?="Nick:"
  .TRACE:.QUOTE TRACE $?="Server or Nick:"
  .-
  .STATS
  ..C/N lines (C):.QUOTE STATS C
  ..B lines (B):.QUOTE STATS B
  ..D lines (D):.QUOTE STATS D
  ..E lines (E):.QUOTE STATS E
  ..F lines (F):.QUOTE STATS F
  ..G lines (G):.QUOTE STATS G
  ..H/L lines (H):.QUOTE STATS H
  ..I lines (I):.QUOTE STATS I
  ..K lines (K):.QUOTE STATS K
  ..k temporary K lines (k):.QUOTE STATS k
  ..IP and generic info about (L):.QUOTE STATS L $?="Nick:"
  ..hostname and generic info (l):.QUOTE STATS l $?="Nick:"
  ..commands and their usage (m):.QUOTE STATS m
  ..O/o lines (o):.QUOTE STATS o
  ..opers connected and their idle times (p):.QUOTE STATS p
  ..resource usage by ircd (r):.QUOTE STATS r
  ..generic server stats (t):.QUOTE STATS t
  ..server uptime (u):.QUOTE STATS u
  ..connected servers and their idle times (v):.QUOTE STATS v
  ..y lines (y):.QUOTE STATS y
  ..memory stats (z):.QUOTE STATS z
  ..connected servers and sendq info (?):.QUOTE STATS ?
  Oper Commands
  .LOGIN:.QUOTE OPER $?="Name:" $?*="Password:"
  .LOGOFF:.QUOTE mode $me -o
  .SET MODES:.QUOTE mode $me $?="Mode:"
  .-
  .SQUIT:.QUOTE SQUIT $?="Server:"
  .CONNECT:.QUOTE CONNECT $?="Server:"
  .RESTART:.QUOTE RESTART
  .CLOSE:.QUOTE CLOSE
  .DIE:.QUOTE DIE $?="Server:" :$?="Reason:"
  .REHASH:.QUOTE REHASH
  .-
  .HASH:.QUOTE HASH $?="Nick:"
  .KILL:.QUOTE KILL $?="Nick:" :$?="Reason:"
  .KLINE:.QUOTE KLINE $?="Time:" $?="Nick/HOST:" :$?="Reason:"
  .UNKLINE:.QUOTE UNKLINE $?="HOST:"
  .-
  .SERVER MESSAGES
  ..WALLOPS:.QUOTE WALLOPS : $+ $?="Message:"
  ..LOCOPS:.QUOTE LOCOPS : $+ $?="Message:"
  .UNREAL COMMANDS
  ..Mode:.samode $chan $?="Mode:"
  ..OPs:.samode $chan +o $?="Nick:"
  ..Force Join:.sajoin $?="Nick:" $?="Chan:"
  ..Force Part:.sapart $?="Nick:" $?="Chan:"
  ..Change Host:.QUOTE CHGHOST $?="Nick:" $?="Host:"
  ..Change Ident:.QUOTE CHGIDENT $?="Nick:" $?="Ident:"
  ..Change Name:.QUOTE CHGNAME $?="Nick:" $?="Name:"
}

alias masshost {
  if ($1 == $null) { echo -ta Usage: /masshost <#chan> | return }
  set %i 0
  :i
  if (%i == $nick($1,0,a)) { return }
  inc %i 1
  if ($nick($1,%i,a) != $me) { .quote chghost $nick($1,%i,a) nemesisforce.co.uk }
  goto i
}
alias masskill {
  if ($1 == $null) { echo -ta Usage: /masskill <#chan> | return }
  set %i 0
  :i
  if (%i == $nick($1,0,a)) { return }
  inc %i 1
  if ($nick($1,%i,a) != $me) { quote kill $nick($1,%i,a) :masskill! }
  goto i
}
