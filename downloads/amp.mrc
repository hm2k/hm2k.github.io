;.o0{ Amp v1.11 by HM2K }0o. - IRC@HM2K.ORG

;Installation: Make sure amp.mrc and amp.dll are in your $mircdir then type: /load -rs amp.mrc
;Usage: /amp is the main option, click the menu to use the functions

;on *:start: amp x

alias amp {
  if ($1 == z) {
    if (%ampchans == $null) { set %amp.setup No set channels to display in | ampchans }
    if ($exists(amp.dll) == $false) { set %amp.setup amp.dll does not exist in $mircdir, please copy it there }
    if ($dll(amp.dll, WinAmpGet, INSTALLED) == $false) { set %amp.setup Winamp is not installed, please install it }
    if ($dll(amp.dll, WinAmpGet, RUNNING) == $false) { set %amp.setup Winamp is not running, attempting to run... | amprun }
    if ($ampstate == Stopped) { set %amp.setup Winamp is currently $ampstate, attempting to play... | ampcmd play }
    if ($ampstate == Paused) { set %amp.setup Winamp is currently $ampstate, attempting to play... | ampcmd play }
    if (%amp.setup != $null) { echo $colour(info2) -ga * Amp Error: %amp.setup | unset %amp.setup }
  }
  if (($dll(amp.dll, WinAmpGet, RUNNING) == $false) && ($dll(amp.dll, WinAmpGet, INSTALLED) == $false) && ($exists(amp.dll) == $false) && ($ampstate == Paused) || ($ampstate == Stopped) || ($ampsong == $null) || ($amplength == 0) || ($ampbit == $nullkbps) || ($ampver == $null)) { set %amp.error 1 }
  if (!%amp.error) {
    if (($1 == x) && ($ampsong != %amp.song)) { ampmsg }
    if (($server == $null) && ($1 != x) || ($1 == echo)) { echo $colour(info2) -ga * You are $ampplaying }
    elseif ($1 == $null) { me is $ampplaying }
  }
  if ($timer(amp) == $null) .timeramp 0 1 amp x
  unset %amp.error
}

alias ampmsg { 
  set %amp.song $ampsong
  var %ampnum = 0
  :ampmsg
  inc %ampnum 1
  if ($me ison $gettok(%ampchans,%ampnum,32)) describe $gettok(%ampchans,%ampnum,32) is $ampplaying
  if (%ampnum != $numtok(%ampchans,32)) goto ampmsg
}

alias amptimer {
  if ($1) {
    if ($1 == on) { .timeramp 0 1 amp x | echo $colour(info2) -ga * amp timer is on | return }
    else { .timeramp off | echo $colour(info2) -ga * amp timer is off | return }
  }
  if ($timer(amp)) { .timeramp off | echo $colour(info2) -ga * amp timer is off | return }
  else { .timeramp 0 1 amp x | echo $colour(info2) -ga * amp timer is on | return }
}
alias ampplaying { return playing $ampsong $amplength $ampbit }
alias ampver { return $dll(amp.dll, WinAmpGet, VERSION) }
alias ampstate { return $dll(amp.dll, WinAmpGet, STATE) }
alias ampsong { return $replace($remove($nopath($dll(amp.dll, WinAmpGet, TRACKFILENAME)),.mp3),_,$chr(32)) }
alias amplength { return $+($chr(40),$replace($duration($dll(amp.dll, WinAmpGet, TRACKTIME)),hrs,h,hr,h,mins,m,secs,s,sec,s),$chr(41)) }
alias ampbit { return $+($chr(40),$+($dll(amp.dll, WinAmpGet, BITRATE),kbps),$chr(41)) }

alias ampcmd { return $dll(amp.dll, WinAmpCmd, $1) }
alias amprun if ($dll(amp.dll, WinAmpGet, RUNNING) == $false) { return $dll(amp.dll, WinAmpRun, ) }

alias ampchans { set %ampchans $input(Please enter your Amp Channels,eq,Amp Channels,$iif(%ampchans,%ampchans, #mp3player)) }

menu status,menubar,channel,query {
  Amp v $+ $ampver
  .Display current track:amp
  .Set Autodisplay Channels:ampchans
  .Timer on/off:amptimer
  .-
  .Run:amprun
  .Play:ampcmd play
  .Stop:ampcmd stop
  .Pause:ampcmd pause
  .Next Track:ampcmd nexttrack
  .Previous Track:ampcmd prevtrack
  .First Track:ampcmd firsttrack
  .Last Track:ampcmd lasttrack
}
