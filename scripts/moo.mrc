;.oO{ moo script v3.12 *beta* by HM2K }Oo. - IRC@HM2K.ORG

;description:
;no more moo.dll! -- this script uses $com to lookup the WMI functions to return specified system information.
;moo script was originally created to display your system information via IRC, including: operating system, uptime, cpu, memory usage, graphics card, resolution, network details and hard drive details.

;installation:
;NOTICE: please unload and remove any old moo scripts, else this script may not work.
;make sure moo.mrc is in your $mircdir then type: /load -rs moo.mrc

;Please make sure you have the latest windows updates or the latest WMI core (http://www.microsoft.com/downloads/details.aspx?FamilyID=98a4c5ba-337b-4e92-8c18-a63847760ea5&DisplayLang=en)
;Also, please use the latest version of mIRC, ideally mIRC v6.16 and above...

;usage:
;for moo type: /moo or !moo (if enabled)
;for uptime only type: /up or !uptime (if enabled)

;history:
;moo script v3.12	- Minor tweaks, a few code changes, added /moo echo and a few more functions.
;moo script v3.11	- Added some new features and made it easier to style the output, added some additional notes
;moo script v3.1	- Added the long awaited flood protection, simple lookup error checking, more/better functions, quicker script
;moo script v3.0	- The whole script was changed, no more moo.dll, it now uses WMI however this version MUST be run on mIRC v6.16 or above.
;[moo] script v2.27	- !moo trigger fix, now turned off by default to stop abuse
;[moo] script v2.26	- Lots of little changes made up till this version, including getmoo.
;[moo] script v2.23	- changed some alias' to alias -l, fixed small bugs, added new featuers
;[moo] script v2.22	- minor bug fixes, bold added etc.
;[moo] script v2.21	- added a feature to turn the !moo get and !getmoo on or off, and fixed a few bugs.
;[moo] script v2.2	- name change, completly changed the /moo and !moo system, should work better now, no mistakes.
;moo script v2.13	- still a few mistakes, changes made, mbm5 isn't functioning correctly...
;moo script v2.12	- many small changes and fixes made, mbm5 was fixed also.
;moo script v2.11	- simple bug fixes.
;moo script v2.1	- minor modifications, final public release.
;moo script v2.0	- New name, new style, new script, same idea.
;MooDll Script v1.21	- Many bug fixes, first public release
;MooDll Script v1.0	- Original private release, very simple, buggy.

;thanks to...
;Mark (from influenced.net) for the original concept and for letting me know that he was not creating a new moo.dll
;HndlWCare who inspired me to write this for saying: "moo.dll was written by a college student roommate of one of our ops who has admitted inserting a backdoor into it" -- none of this is true, there IS NO backdoor in moo.dll and just like there is NO backdoor in this script. HndlWCare you are an idiot.
;Moondawn for listening to me rant.
;and also the beta testers... square, ryguy, Petersen, OutCast3k and PRO1.

;settings

;moo banned channels - these are channels you don't want the triggers to function in
alias -l moo.banchans return #php

;moo style - use this to style the titles of the output
alias -l moos return $+(,$1,:)

;NOTICE: DO NOT edit below unless you know what you're doing. If you do make any changes, please let me know! :)

alias -l moover return moo script v3.12 *beta*

;usage: /moo <moof (see below)>
alias moo {
  if (!$1) { $iif($chan,msg $chan,say) $moor | return }
  if ($1 == echo) { echo -a $moor | return }
  if ($moof($1)) { var %moo.var $ifmatch | $iif($chan,msg $chan,say) moo: %moo.var }
}

;moo return - use this to change the outputs
alias -l moor return moo: $iif($mooi(name), $moof(os) $moof(up) $moof(cpu) $moof(gfx) $moof(res) $moof(ram) $moof(hdd) $moof(net),lookup error)

;this section was created so you can easily change the options for what is returned

;moo functions - you can add or change the functions that the script can handle
alias -l moof {
  if ($1 == os) { return $moos($1) $mooi(ostitle) - $mooi(ossp) $brak($mooi(osver)) }
  if ($1 == up) { return $moos($1) $duration($mooi(up)) }
  if ($1 == cpu) { return $moos($1) $mooi(cpuname) at $mooi(cpuspeed) $brak($mooi(cpuload)) }
  if ($1 == gfx) { return $moos($1) $mooi(gfxmake) $mooi(gfxproc) $mooi(gfxram) }
  if ($1 == res) { return $moos($1) $mooi($1) $mooi(resbit) $mooi(resrate) }
  if ($1 == ram) { var %moo.rammax = $mooi(rammax) | var %moo.ramuse = $mooi(ramuse) | return $moos($1) $+($round($calc(%moo.rammax - %moo.ramuse),0),/,%moo.rammax,MB) $+($chr(40),$round($calc((%moo.rammax - %moo.ramuse) / %moo.rammax * 100),2),%,$chr(41)) $moorambar($round($calc((%moo.rammax - %moo.ramuse) / %moo.rammax * 100),2)) }
  if ($1 == hdd) { return $moos($1) $mooi(hdd) }
  if ($1 == net) { return $moos($1) $iif($mooi(netname),$ifmatch - $mooi(netspeed) $mooi(netin) In $mooi(netout) Out, ) }
  elseif ($mooi($1)) { return $moos($1) $ifmatch }
}

;moo info - below are the useful or interesting wmi functions to use with the script
alias -l mooi {
  if ($1 == name) { return $wmiget(Win32_ComputerSystem).Name }
  if ($1 == ostitle) { return $wmiget(Win32_OperatingSystem).Caption }
  if ($1 == ossp) { return $wmiget(Win32_OperatingSystem).CSDVersion }
  if ($1 == osver) { return $wmiget(Win32_OperatingSystem).Version }
  if ($1 == osinstall) { return $asctime($ctime($iif($wmiget(Win32_OperatingSystem).InstallDate,$+($mid($ifmatch,7,2),/,$mid($ifmatch,5,2),/,$mid($ifmatch,1,4)) $+($mid($ifmatch,9,2),:,$mid($ifmatch,11,2),:,$mid($ifmatch,13,2))))) }
  if ($1 == up) { return $uptime(system,3) }
  if ($1 == cpuname) { return $wmiget(Win32_Processor).Name }
  if ($1 == cpuspeed) { return $+($wmiget(Win32_Processor).CurrentClockSpeed,MHz) }
  if ($1 == cpuload) { return $+($wmiget(Win32_Processor).LoadPercentage,% Load) }
  if ($1 == cputotal) { return $wmiget(Win32_ComputerSystem).NumberOfProcessors }
  if ($1 == gfxmake) { return $wmiget(Win32_VideoController).AdapterCompatibility }
  if ($1 == gfxproc) { return $wmiget(Win32_VideoController).VideoProcessor }
  if ($1 == gfxram) { return $bytes($wmiget(Win32_VideoController).AdapterRam).3 $+ MB }
  if ($1 == res) { return $+($wmiget(Win32_VideoController).currenthorizontalresolution,x,$wmiget(Win32_VideoController).currentverticalresolution) }
  if ($1 == resbit) { return $wmiget(Win32_VideoController).currentbitsperpixel $+ bit }
  if ($1 == resrate) { return $wmiget(Win32_VideoController).currentrefreshrate $+ Hz }
  if ($1 == rammax) { return $round($calc($wmiget(Win32_LogicalMemoryConfiguration).TotalPhysicalMemory / 1024),2) }
  if ($1 == ramuse) { return $bytes($wmiget(Win32_PerfRawData_PerfOS_Memory).AvailableBytes).3 }
  if ($1 == netname) { return $wmiget(Win32_PerfRawData_Tcpip_NetworkInterface).Name }
  if ($1 == netspeed) { return $calc($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface).CurrentBandwidth / 1000000) $+ MB/s }
  if ($1 == netin) { return $bytes($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface).BytesReceivedPersec).suf }
  if ($1 == netout) { return $bytes($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface).BytesSentPersec).suf }
  if ($1 == hdd) { var %i 1 | while (%i <= $disk(0)) { if ($disk(%i).type == fixed) var %var %var $disk(%i).path $+($bytes($disk(%i).free).suf,/,$bytes($disk(%i).size).suf Free) | inc %i } | return %var }
  if ($1 == sound) { return $wmiget(Win32_SoundDevice).Name }
  if ($1 == mobo) { return $wmiget(Win32_BaseBoard).Manufacturer $wmiget(Win32_BaseBoard).Product }
}

;moo rambar - the famous rambar from the original script with a couple of changes
alias -l moorambar {
  if ($len($1) < 990) {
    var %moo.rb.size = 10
    var %moo.rb.used = $round($calc($1 / 100 * %moo.rb.size),0)
    var %moo.rb.unused = $round($calc(%moo.rb.size - %moo.rb.used),0)
    var %moo.rb.usedstr = $str(|,%moo.rb.used)
    var %moo.rb.unusedstr = $str(-,%moo.rb.unused)
    if ((%moo.rb.usedstr) && (%moo.rb.unusedstr)) return $+([,%moo.rb.usedstr,%moo.rb.unusedstr,])
  }
}

;Get WMI data - this is the most useful function here, this only works if mIRC has the $COM function, its very useful, but a little slow.
alias -l wmiget {
  var %com = cominfo, %com2 = cominfo2, %com3 = cominfo3
  if ($com(%com)) { .comclose %com }
  if ($com(%com2)) { .comclose %com2 }
  if ($com(%com3)) { .comclose %com3 }
  .comopen %com WbemScripting.SWbemLocator
  var %x = $com(%com,ConnectServer,3,dispatch* %com2), %x = $com(%com2,ExecQuery,3,bstr*,select $prop from $1,dispatch* %com3), %x = $comval(%com3,$iif($2,$2,1),$prop)
  if ($com(%com)) { .comclose %com }
  if ($com(%com2)) { .comclose %com2 }
  if ($com(%com3)) { .comclose %com3 }
  return %x
}

;backets - I got fed up of repeating the same thing
alias -l brak return $+($chr(40),$1-,$chr(41))

;uptime script - this is the short uptime script created to return your current update and retain your best uptime
on *:connect: up x
alias up { ;uptime v0.4
  $iif($timer(up) == $null,.timerup 0 30 up x) 
  if (($uptime(system,3) >= %up) || (%up == $null)) set %up $uptime(system,3) 
  $iif($1 == x,halt,$iif($chan,msg $chan,$iif($active == Status Window,echo,say)) $+(Windows,$OS) Uptime: $uptime(system,1) Best: $duration(%up))
}

#!uptime on
on *:text:!uptime:#: if (!$istok($moo.banchans,$chan,32)) { up | $repeatcheck($1-) }
#!uptime end

;moo triggers - public display, sharing the script and ctcp moo

#!moo on
on *:text:!moo*:#: if (!$istok($moo.banchans,$chan,32)) { moo $2 | $repeatcheck($1-) }
#!moo end
#!getmoo on
on *:text:!getmoo:*: {
  if ($chan) { .notice $nick moo: To get $moover type: "/msg $me !getmoo" (set "/dccignore off" first) | $repeatcheck($1) | halt }
  else { .close -m $nick | .dcc send $nick $script | .notice $nick moo: Once you receive the script issue: "/load -rs $nopath($script) $+ ", and don't forget to do "/dccignore on" | $repeatcheck($1) | halt }
}
#!getmoo end
#ctcpmoo on
ctcp *:*:*: if (($1 == MOO) || ($1 == VERSION)) { .ctcpreply $nick $1 $moover by HM2K | $repeatcheck(ctcpmoo) }
#ctcpmoo end

;repeat checker - will disable the appropriate group if its flooded
alias -l repeatcheck { ;v0.11
  var %rep.lim = 3
  var %rep.t.lim = 25
  if (%rep.lockusr- [ $+ [ $nick ] ]) { haltdef }
  inc $+(-u,%rep.t.lim,$chr(32),%,rep-,$nick,.,$len($strip($1-)),.,$hash($strip($1-),32)) 1
  if (%rep- [ $+ [ $nick ] $+ . $+ [ $len($strip($1-)) ] $+ . $+ [ $hash($strip($1-),32) ] ] == %rep.lim) {
    ;ignore -u60 $address($nick,5)
    if ($group($chr(35) $+ $1) == on) { .disable $chr(35) $+ $1 | .echo -gat moo: $1 is $group($chr(35) $+ $1) due to a repeat flood from $nick }
    .set -u10 $+(%rep.lockusr-,$nick) 1
  }
}

;onload and onunload checks - making sure everything is as it should be
on *:load: { up x | if ($version < 6.16) { echo -a moo: you need mIRC v6.16 or greater to run this script, get the latest version from www.mirc.com/get.html | unload -rs $script | halt } }
on *:unload: { .timerup off | $iif($input(Do you want to remove the best uptime data,y,unset %up),unset %up,) | .echo $colour(info2) -gat $moover was unloaded, to reload type: /load -rs $script }

;the menus - only simple at the moment, however this script is designed to utilise the /moo and !moo triggers
menu channel,query {
  $moover
  .moo all (/moo): moo
  .moo uptime (/up): up
  .-
  .!moo trigger ( $+ $group(#!moo) $+ ):{
    if ($group(#!moo) != on) { .enable #!moo }
    else { .disable #!moo }
    .echo -ga moo: !moo is $group(#!moo)
  }
  .!uptime trigger ( $+ $group(#!uptime) $+ ):{
    if ($group(#!uptime) != on) { .enable #!uptime }
    else { .disable #!uptime }
    .echo -ga moo: !uptime is $group(#!uptime)
  }
  .!getmoo trigger ( $+ $group(#!getmoo) $+ ):{
    if ($group(#!getmoo) != on) { .enable #!getmoo }
    else { .disable #!getmoo }
    .echo -ga moo: !getmoo is $group(#!getmoo)
  }
  .ctcp moo trigger ( $+ $group(#ctcpmoo) $+ ):{
    if ($group(#ctcpmoo) != on) { .enable #ctcpmoo }
    else { .disable #ctcpmoo }
    .echo -ga moo: ctcpmoo is $group(#ctcpmoo)
  }
  .-
  .unload $remove($script,$scriptdir)
  ..are you sure?
  ...yes: { .unload -rs $script }
  ...no: { .echo $colour(info2) -gat $remove($script,$scriptdir) was NOT unloaded. }
}
;EOF
