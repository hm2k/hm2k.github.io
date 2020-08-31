#Dictionary by MORA@ready.dk
#Not much readme / docs at the time, msg me on efnet if you got probs.

set dictionary(ver) 4.67
#RLS date 06-09-2003
#Fixed some list, split, lindex, lrange bugs - Thx to help by SL/PPSlim@#Egghelp@EFNet  :D
#Fixed more of the list/join bugs.
#Changed sharesystem to look for a handle (with hosts) instead of a nick.
#Changed sharesystem to wait 1min before transfer.
#TODO : Update code line for line :)

#File should be located in your eggdrop folder, not the scripts folder.
set dictionary(file) "dictionary.dat"

#Send a notice back to users adding or deleteing stuff? 0=send notice/msg
set dictionary(quiret) 0
#Send where ? 1=chan 2=user (no effect if quiret=1)
set dictionary(where) 2

#Max number of definitions to show in chan (0=send all to pm, any high number = send all to chan)
set dictionary(maxinchan) 20

#Save as XML output ?
set dictionary(xml) 1
#Filename for XML?
set dictionary(xmlname) "$dictionary(file).xml"

#Run http server to show the added words?
set dictionary(http) 1
#Port for http server
set dictionary(httpport) 6213

#Set to 0 to disable, or a valid email address to get a copy of the dicmfile every week.
#Email option only on linux/unix systems. (Not windows) - File backup works on win though.
#now supports multiple emails, use space to delimit them.
set dictionary(emailbackup) "0"
#Set to 0 to disable, or a valid filename to have the dicmfile saved there once a day.
set dictionary(filebackup) "$dictionary(file).bak"

#How many commands to execute each min? (global owners cannot triger flood).
#Type any high integer to disable 
set dictionary(floodlimit) 20
#How many secs to stop executing commands, after being flooded ?
set dictionary(floodtime) 120

set dictionary(addtrigger) "!learn"
set dictionary(gettrigger) "??"
set dictionary(deltrigger) "!forget"
set dictionary(statustrigger) "status?"
set dictionary(searchtrigger) "!search"
set dictionary(inserttrigger) "!insert"

set dictionary(addflag) H|H
set dictionary(getflag) -|-
set dictionary(delflag) H|H
set dictionary(statusflag) -|-
set dictionary(searchflag) -|-

set dictionary(allowmsg) 1
set dictionary(dicmchanonly) 1

if {$dictionary(dicmchanonly)==1} { setudef flag dicm }

#ADVANCED SETTINGS - NO NEED TO EDIT FOR MOST USERS#
#Enable database share?
set dictionary(sharedb) 0
#Handle of the other bot (add hosts to this handle)
set dictionary(handle) ""
#Nick of the other sharebot ?
set dictionary(sharenick) ""
#Host of the other sharebot ?
set dictionary(sharehost) ""
#Port of the other bot ? (This port really should be the same un both bots)
#ITS not the port you listen on, the port you set here will be binded within this script.
set dictionary(shareport) ""
#Password for database share (Will be used by bots only)
set dictionary(sharepass) ""
#Am I the hub or the leaf ?
#if im leaf, I wont react on triggers if hub is on chan, if im hub I will react even if the leaf is on chan
set dictionary(sharehub) "0"
#dictionary file is sent to the bot that JOINS the chan, since it will(SHOULD?) have the oldest fileversion.
#dictionary file will be saved to filename.share.bak before transfer.

if {[file exists dictionary.[string tolower $nick].settings.tcl]} {
 source dictionary.[string tolower $nick].settings.tcl
}
#You can overwrite settings in this file, so they will stay the same when/if you update the tcl.

#Share system code
proc dic:ishub {{chan ""}} {
 global dictionary
 if {$chan != ""} {
  if {$dictionary(sharehub) == 0 && $dictionary(imtemphub) == 0 && [hand2nick $dictionary(handle)]==""} { return 1 }
  if {$dictionary(sharehub) == 0 && $dictionary(imtemphub) == 0 && [hand2nick $dictionary(handle)]!=""} { return 0 }
}
 if {$dictionary(sharehub) == 1 || $dictionary(imtemphub) > 0} { return 1 }
 return 0
}

#In ?? status?   use this to abort the command  if {![dic:ishub ]} { return 0 }
#in forget learn search   use this to overwrite the quiret command

proc dic:getfile {host port} {
#Connect to host at port port
 putloglev 3 * "(GET)Starting dicm transfer"
 set idx [connect $host $port]
 control $idx dic:getfile:xfer
}

proc dic:file:lines {file} {
 set lines 0
 set fp [open $file r]
 while {![eof $fp]} {
  set txt [gets $fp]
  if {$txt != ""} { incr lines }
 }
 close $fp
 return $lines
}

proc dic:getfile:xfer {idx text} {
 global dictionary
 set text [split $text]
 set cmd [join [lindex $text 0]]
 set arg1 [join [lindex $text 1]]
 putloglev 7 * "(GET)XFER LINE : $idx : $cmd : $arg1 : $text"
 if {$cmd=="DSR"} { putdcc $idx "PASS $dictionary(sharepass)" }
 if {$cmd=="BADPASS"} { putlog "ERROR: remote bot dont like my pass" }
 if {$cmd=="MD5"} { set dictionary(tempmd5) $arg1 }
 if {$cmd=="BOF"} { 
  set dictionary(filestream) [open tempdicmfile w+]
  fconfigure $dictionary(filestream) -translation binary
 }
 if {$cmd=="FEED"} {
  set dat [join [lrange [split $text] 1 end]]
  if {$dat != ""} { puts $dictionary(filestream) $dat }
  #puts $dictionary(filestream) $dat
 }
 if {$cmd=="EOF"} {
  close $dictionary(filestream)
  putdcc $idx "QUIT"
  set mymd5 [dic:file:lines tempdicmfile]
  if {$mymd5 != $dictionary(tempmd5)} {
   putlog "Transfer dont match - trashing this version. ($mymd5 != $dictionary(tempmd5))"
  } else {
   putlog "Transfer successful - saving backup of my file and reloading new file."
   file copy -force $dictionary(file) $dictionary(file).share.bak
   file copy -force tempdicmfile $dictionary(file)
   dic:loaddb
   putlog "Database reloaded"
  }
 }
}

listen $dictionary(shareport) script dic:sendfile

proc dic:sendfile {idx} { 
 putloglev 3 * "(SEND)Starting dcc xfer"
 dic:save:list 00 00 00 00 00
 putdcc $idx "DSR"
 control $idx dic:sendfile:xfer
}

proc dic:sendfile:xfer {idx text} {
 global dictionary
 set text [split $text]
 set cmd [join [lindex $text 0]]
 set arg1 [join [lindex $text 1]]
 putloglev 7 * "(SEND)XFER LINE : $idx : $cmd : $arg1 : $text"
 if {$cmd=="QUIT"} { killdcc $idx }
 if {$cmd=="PASS"} {
  if {$arg1 == $dictionary(sharepass)} {
   putdcc $idx "MD5 [dic:file:lines $dictionary(file)]"
   putdcc $idx "BOF"

   set fp [open $dictionary(file) r]
   fconfigure $fp -translation binary
   set data [read $fp]
   close $fp
   foreach line [split $data "\n"] {
    putdcc $idx "FEED $line"
   }

   putdcc $idx "EOF"
  } else {
   putdcc $idx "BADPASS"
   killdcc $idx
  }
 }
}

bind join -|- * dic:got:join
proc dic:got:join {nick uhost handle chan} {
 global botnick dictionary
 if {$dictionary(sharedb) == 0} {
  #We dont use sharedb, skipping.
  return 0
 } 
 if {$nick == $botnick} { utimer 60 "dic:eval:join $nick $uhost $handle $chan" }
}

proc dic:eval:join {nick uhost handle chan} {
 global botnick dictionary
 if {$nick == $botnick} {
  #I joined $chan
  if {[lsearch -exact [channel info $chan] +dicm] != -1} {
   #Chan is a dicm chan.
   set n [hand2nick $dictionary(handle)]
   if {[onchan $n $chan] && $n!=""} {
    #My sharebot is on chan, lets ask for a update.
    putlog "Joined DICM chan $chan, asking $dictionary(sharenick) for new file"
    dic:getfile $dictionary(sharehost) $dictionary(shareport)
   } else {
    putlog "Joined DICM chan $chan, $dictionary(sharenick) aint here, keeping my own file"
    #Should implement some TS system, to see who got the most correct file upon rejoin.
   }
  }
 }
}

#Share code done.

#DCC commands
bind dcc -|- dicm dic:temphub
bind dcc -|- reloaddic dic:reload
bind dcc -|- getdic dic:getdic

proc dic:getdic {h idx a} {
 global dictionary
 if {$dictionary(sharedb) == 0} {
  putdcc $idx "Command not avaliable when you dont share dicmfile"
  #We dont use sharedb, skipping.
  return 0
 }
 putdcc $idx "Downloading file from sharebot"
 dic:getfile $dictionary(sharehost) $dictionary(shareport)
}
proc dic:temphub {h idx a} {
set a [split $a]
global dictionary
 if {$dictionary(sharedb) == 0} {
  #We dont use sharedb, skipping.
  putdcc $idx "Command not avaliable when you dont share dicmfile"
  return 0
 }
 set min [join [lindex $a 0]]
 if {$min == "off"} {
  set dictionary(imtemphub) 0
  putdcc $idx "Ok, I wont respond to triggers until hub is gone"
  return 0
 }
 if {$min == ""} {
  putdcc $idx "Syntax : .dicm mins"
  putdcc $idx "This will make me respond to dicm commands even if hub is there for <mins>"
  return 0
 }
 set dictionary(imtemphub) $min
 putdcc $idx "Ok, I will respond to dicmrequests for $min mins.  -  To stop me use .dicm off"
}
proc dic:reload {h idx a} {
global dictionary
 putcmdlog "#$h# dicreload"
 putdcc $idx "Reloading database from file, trashing mem version"
 dic:loaddb
}
#DCC commands done

# Binds done - Making main procs #
proc dic:loaddb {} {
 global dictionary
 set dictionary(changed) 0
 if {[info exists dictionary(db)]} { unset dictionary(db) }
 set fp [open $dictionary(file) r]
 while {![eof $fp]} {
  set line [gets $fp]
  if {$line!=""} { lappend dictionary(db) $line }
 }
 close $fp
}

proc dic:check:flood {hand} {
 global dictionary
 if {[matchattr $hand n]} { return 0 }
 
 if {![info exists dictionary(flood)]} { set dictionary(flood) 0 } else { incr dictionary(flood) }
 
 if {$dictionary(flood) == $dictionary(floodlimit)} { putlog "Dictionary.tcl getting flooded, halting further commands" ; utimer $dictionary(floodtime) "set dictionary(flood) 0" ; return 1 }
 
 if {$dictionary(flood) > $dictionary(floodlimit)} { return 1 }
 
 return 0
}

proc dic:find {word} {
 #Word is a string, can be multiple words.
 #Return a list (lappend)
 global dictionary
 foreach line $dictionary(db) {
#  set line [split $line]
  set author [join [lindex $line 0]]
  set time [join [lindex $line 1]]
  set found [join [lindex $line 2]]
  set meaning [join [lrange $line 3 end]]
  #Look for $word in $found
  #NOT PERFECT
  set b [string equal -nocase $word $found]
  if {$b} {
   lappend res "$author $time $meaning"
  }
 }

 if {[info exists res]} { return $res } else { return "" }
}

proc dic:add {author word def} {
 #Both word and def are lists when we get em.
 global dictionary
 set dictionary(changed) 1
 set temp [split $word]
 if {[llength $temp]>1} { set word "\"$word\"" }
 set def $def
 set time [strftime %m-%d-%Y@%H:%M]
 lappend dictionary(db) "$author $time $word $def"
}

proc dic:del {word id} {
 #Input : word and id, if id=0 delete all def for that word.
 #returns nothing
 global dictionary
 set dictionary(changed) 1
 set word [join $word]
 set bgdb $dictionary(db)
 if {![info exists dictionary(db)]} { rehash ; return 0 }
 unset dictionary(db)
 set oid 0
 foreach line $bgdb {
  set line [split $line]
  set found [lindex $line 2]
  if {[string equal -nocase $found $word]} {
   incr oid
   if {$oid==$id || $id==0} { continue }
  }
 #We should only get here if the word is not matched or it is not the number we want.
 lappend dictionary(db) $line
 }
}

# Add / find / del procs done

#HTTP server
proc dic:start:http {} {
 global dictionary
 catch { listen $dictionary(httpport) off }
 listen $dictionary(httpport) script dic:http:serve
}
if {$dictionary(http)==1} { dic:start:http }
proc dic:http:serve {idx} { control $idx dic:http:control }
proc dic:http:control {idx text} {
 global dictionary
 set cmd [lindex $text 0]
 if {$cmd=="GET"} {
   putdcc $idx "HTTP/1.1 202 Ok"
   putdcc $idx "Content-Length: 56497864"
   putdcc $idx "Server: Eggdrop dictionary $dictionary(ver) server by MORA"
   putdcc $idx "Content-Type: text/html"
   set dat [clock format [clock seconds] -format "%a, %d %b %Y %H:%M:%S" -gmt true]
   putdcc $idx "Date: $dat GMT"
   putdcc $idx "\n\r"
   putdcc $idx "<table border=1><tr><td>Author</td><td>Time</td><td>Word</td><td>Definition</td></tr>"   
   foreach line $dictionary(db) {
    putdcc $idx "<tr><td>[join [lindex $line 0]]</td><td>[join [lindex $line 1]]</td><td>[join [lindex $line 2]]</td><td>[join [lrange $line 3 end]]</td></tr>\n\r"
   }
   putdcc $idx "</table>"
 }
# return 1
}
#DONE HTTP server

### GLOBAL INTERFACE ###
proc dic:intr:add {line} {
 #input a string, as the user typed it.
 #output a list with 2 parts, word, def
  if {[string range $line 0 0]=="\""} {
   set found [join [lindex [split $line "\""] 1]]
   set meaning [join [lrange [split $line "\""] 2 end]]
  } else {
   set found [join [lindex [split $line] 0]]
   set meaning [join [lrange [split $line] 1 end]]
  }
  lappend res $found
  lappend res $meaning
  return $res
} 

proc dic:intr:search {chan text} {
# set text [join $text]
# set chan [join $chan]
 global dictionary
 set res ""
 foreach line $dictionary(db) {
  set w [lindex $line 2]
  if {[string match -nocase "*$text*" $line] && ![string match -nocase "*$w*" $res]} {
   if {[string match "* *" $w]} {
   set res "$res \"$w\"" 
   } else {
   set res "$res $w"
   }
  }
 }
 if {$res==""} { putserv "PRIVMSG $chan :No results" } else { putserv "PRIVMSG $chan :$res" }
}

proc dic:intr:status {chan} {
 global dictionary
 set cache ""
 set uni 0
 foreach line $dictionary(db) {
  set word [join [lindex $line 2]]
  if {![string match -nocase "*$word*" $cache]} { append cache "$word " ; incr uni }
 }
 if {[validchan $chan]} {
  set users [llength [userlist $dictionary(addflag) $chan]]
 } else {
  set users [llength [userlist $dictionary(addflag)]]
 }
 putserv "PRIVMSG $chan :I have [llength $dictionary(db)] lines and $uni unique definitions, $users users can add to my list."
}

proc dic:intr:insert {author word id def} {
 global dictionary
 #There shouldnt be any need to lock the database since the call aint async. -MORA-
 set temp ""
 set inserted 0
 set i 0
 foreach line $dictionary(db) {
  set found [join [lindex $line 2]]
  if {[string tolower $word] == [string tolower $found]} {
   incr i
   if {$i == $id} {
    set inserted 1
    set time [strftime %m-%d-%Y@%H:%M]
    lappend temp "$author $time $word $def"
   }
  }
   lappend temp $line
 }
 if {$inserted==0} {
  lappend dictionary(db) "$author $time $word $def"
 } else {
  set dictionary(db) $temp
 }
}

### CHAN INTERFACE ###
bind pub $dictionary(addflag) $dictionary(inserttrigger) dic:pub:insert
bind pub $dictionary(addflag) $dictionary(addtrigger) dic:pub:add
bind pub $dictionary(delflag) $dictionary(deltrigger) dic:pub:del
bind pub $dictionary(getflag) $dictionary(gettrigger) dic:pub:get
bind pub $dictionary(statusflag) $dictionary(statustrigger) dic:pub:status
bind pub $dictionary(searchflag) $dictionary(searchtrigger) dic:pub:search

proc dic:pub:insert {nick uhost handle chan line} {
 global dictionary 
 if {$dictionary(dicmchanonly)==1 && [lsearch -exact [channel info $chan] +dicm]==-1} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 #!insert <word> <id> <def>
 if {[string range $line 0 0]=="\""} {
  set word [join [lindex [split $line "\""] 1]]
  set id [join [lindex [split $line] 2]]
  set def [join [lrange [split $line "\""] 3 end]]
 } else {
  set word [join [lindex [split $line] 0]]
  set id [join [lindex [split $line] 1]]
  set def [join [lrange [split $line] 2 end]]
 }
 if {$def=="" && $dictionary(quiret) == 0 && [dic:ishub $chan]} { putserv "PRIVMSG $chan :Error, no definition given." ; return 0 }
 dic:intr:insert $nick $word $id $def
 putlog "$nick@$chan $dictionary(inserttrigger) $line"
 if {$dictionary(quiret) == 0 && [dic:ishub $chan]} {
  if {$dictionary(where)==1} { putserv "PRIVMSG $chan :Inserted $word=$def as pos $id" }
  if {$dictionary(where)==2} { putserv "NOTICE $nick :Inserted $word=$def as pos $id" }
 }
}

proc dic:pub:add {nick uhost handle chan text} {
 global dictionary 
 if {$dictionary(dicmchanonly)==1 && [lsearch -exact [channel info $chan] +dicm]==-1} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 set str [dic:intr:add $text]
 set word [lindex $str 0]
 set def [lindex $str 1]
 if {$def==""} { putserv "PRIVMSG $chan :Error, no definition given." ; return 0 }
 dic:add $nick $word $def
 putlog "$nick@$chan $dictionary(addtrigger) $text"
 if {$dictionary(quiret) == 0 && [dic:ishub $chan]} {
  if {$dictionary(where)==1} { putserv "PRIVMSG $chan :Added $word=$def" }
  if {$dictionary(where)==2} { putserv "NOTICE $nick :Added $word=$def" }
 }
} 

proc dic:pub:get {nick uhost handle chan text} {
 global dictionary
 if {![dic:ishub $chan]} { return 0 }
 if {$dictionary(dicmchanonly)==1 && [lsearch -exact [channel info $chan] +dicm]==-1} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 set cmd [join [lindex [split $text] 0]]
 set text [join [lrange [split $text] 0 end]]
 set target $chan
 switch -exact -- $cmd {
  "-t" {
   set target [join [lindex [split $text] 1]]
   set text [join [lrange [split $text] 2 end]]
   putserv "PRIVMSG $nick :Told $target about $text"
  }
  "-i" {
   set text [join [lrange [split $text] 1 end]]
  }
 }
 if {$text == "" && $dictionary(quiret) == 1} { return 0 }
 if {$text == ""} {
  if {$dictionary(where)==1} { putserv "PRIVMSG $chan :Syntax is ?? \[-i|t\] <word>" }
  if {$dictionary(where)==2} { putserv "NOTICE $nick :Syntax is ?? \[-i|t\] <word>" }
  return 0
 }
 set str [dic:find $text]
 if {[llength $str]==0} { putserv "PRIVMSG $target :No such record" } else {
  set id 1
  if {[llength $str]>$dictionary(maxinchan) && $cmd!="-t"} { set target $nick }
  foreach line $str {
   if {[llength $str]>9 && $id<10} {
    set vid "0$id"
   } else {
    set vid $id
   }
   if {$cmd=="-i"} {
    putquick "PRIVMSG $target :\[$vid\] [join [lrange $line 2 end]] ([join [lindex $line 0]]@[join [lindex $line 1]])"
   } else { putquick "PRIVMSG $target :\[$vid\] [join [lrange $line 2 end]]" }
   incr id
  }
  putlog "$nick@$chan $dictionary(gettrigger) $text"
 }
}

proc dic:pub:del {nick uhost handle chan line} {
 global dictionary
 if {$dictionary(dicmchanonly)==1 && [lsearch -exact [channel info $chan] +dicm]==-1} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 if {[string range $line 0 0]=="\""} {
  set found [join [lindex [split $line "\""] 1]]
  set id [join [lindex [split $line "\""] 2]]
 } else {
  set found [join [lindex [split $line] 0]]
  set id [join [lindex [split $line] 1]]
 }
 #check if id is a integer.
 dic:del $found $id
 putlog "$nick@$chan $dictionary(deltrigger) $line"
 if {$dictionary(quiret) == 0 && [dic:ishub $chan]} {
  if {$dictionary(where)==1} { putserv "PRIVMSG $chan :Deleted $found \[$id\]" }
  if {$dictionary(where)==2} { putserv "NOTICE $nick :Deleted $found \[$id\]" }
 }
}

proc dic:pub:status {nick uhost handle chan line} {
 global dictionary
 if {![dic:ishub $chan]} { return 0 }
 if {$dictionary(dicmchanonly)==1 && [lsearch -exact [channel info $chan] +dicm]==-1} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 dic:intr:status $chan
 putlog "$nick@$chan $dictionary(statustrigger)"
}

proc dic:pub:search {nick uhost handle chan line} {
 global dictionary
 if {![dic:ishub $chan]} { return 0 }
 if {$dictionary(dicmchanonly)==1 && [lsearch -exact [channel info $chan] +dicm]==-1} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 if {$line == "" && $dictionary(quiret) == 1} { return 0 }
 if {$line == ""} {
  if {$dictionary(where)==1} { putserv "PRIVMSG $chan :Syntax is !search <word>" }
  if {$dictionary(where)==2} { putserv "NOTICE $nick :Syntax is !search <word>" }
  return 0
 }
 dic:intr:search $chan $line
 putlog "$nick@$chan $dictionary(searchtrigger) $line"
}

### MSG INTERFACE ###
bind msg $dictionary(addflag) $dictionary(addtrigger) dic:msg:add
bind msg $dictionary(delflag) $dictionary(deltrigger) dic:msg:del
bind msg $dictionary(getflag) $dictionary(gettrigger) dic:msg:get
bind msg $dictionary(statusflag) $dictionary(statustrigger) dic:msg:status
bind msg $dictionary(searchflag) $dictionary(searchtrigger) dic:msg:search
bind msg $dictionary(addflag) $dictionary(inserttrigger) dic:msg:insert

proc dic:msg:insert {nick uhost handle line} {
 global dictionary 
 if {$dictionary(dicmchanonly)==1 && [lsearch -exact [channel info $chan] +dicm]==-1} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 if {![dic:ishub] && $dictionary(sharedb) == 1} { return 0 } 
 #Cant allow msg adds on linked bots.
 #!insert <word> <id> <def>
 if {[string range $line 0 0]=="\""} {
  set word [join [lindex [split $line "\""] 1]]
  set id [join [lindex [split $line] 2]]
  set def [join [lrange [split $line "\""] 3 end]]
 } else {
  set word [join [lindex [split $line] 0]]
  set id [join [lindex [split $line] 1]]
  set def [join [lrange [split $line] 2 end]]
 }
 if {$def==""} { putserv "NOTICE $nick :Error, no definition given." ; return 0 }
 dic:intr:insert $nick $word $id $def
 putlog "$nick@$chan $dictionary(inserttrigger) $line"
 if {$dictionary(quiret) == 0} {
  putserv "NOTICE $nick :Inserted $word=$def as pos $id"
 }
}

proc dic:msg:add {nick uhost handle text} {
 global dictionary 
 if {$dictionary(allowmsg)==0} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 if {![dic:ishub] && $dictionary(sharedb) == 1} { return 0 } 
 set str [dic:intr:add $text]
 set word [join [lindex $str 0]]
 set def [join [lindex $str 1]]
 if {$def==""} { putserv "PRIVMSG $nick :Error, no definition given." ; return 0 }
 dic:add $nick $word $def
 putlog "$nick@PrivMsg $dictionary(addtrigger) $text"
 if {$dictionary(quiret) == 0 && $dictionary(where)==2} {
  putserv "NOTICE $nick :Added $word=$def"
 }
}

proc dic:msg:get {nick uhost handle text} {
 global dictionary
 if {$dictionary(allowmsg)==0} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 set cmd [join [lindex [split $text] 0]]
 set target $nick
 switch -exact -- $cmd {
  "-t" {
   set target [join [lindex [split $text] 1]]
   set text [join [lrange [split $text] 2 end]]
   putserv "PRIVMSG $nick :Told $target about $text"
  }
  "-i" {
   set text [join [lrange [split $text] 1 end]]
  }
 }
  if {$text == "" && $dictionary(quiret) == 1} { return 0 }
 if {$text == ""} {
  if {$dictionary(where)==1} { putserv "PRIVMSG $chan :Syntax is ?? \[-i|t\] <word>" }
  if {$dictionary(where)==2} { putserv "NOTICE $nick :Syntax is ?? \[-i|t\] <word>" }
  return 0
 }
 set str [dic:find $text]
 if {[llength $str]==0} { putserv "PRIVMSG $target :No such record" } else {
  set id 1
  foreach line $str {
   if {[llength $str]>9 && $id<10} {
    set vid "0$id"
   } else {
    set vid $id
   }
   if {$cmd=="-i"} {
    putquick "PRIVMSG $target :\[$vid\] [join [lrange $line 2 end]] ([join [lindex $line 0]]@[join [lindex $line 1]])"
   } else { putquick "PRIVMSG $target :\[$vid\] [join [lrange $line 2 end]]" }
   incr id
  }
  putlog "$nick@PrivMsg $dictionary(gettrigger) $text"
 }
}

proc dic:msg:del {nick uhost handle line} {
 global dictionary
 if {$dictionary(allowmsg)==0} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 if {![dic:ishub] && $dictionary(sharedb) == 1} { return 0 } 
 if {[string range $line 0 0]=="\""} {
  set found [join [lindex [split $line "\""] 1]]
  set id [join [lindex [split $line "\""] 2]]
 } else {
  set found [join [lindex [split $text] 0]]
  set id [join [lindex [split $text] 1]]
 }
 #check if id is a integer.
 dic:del "$found" $id
 putlog "$nick@PrivMsg $dictionary(deltrigger) $line"
 if {$dictionary(quiret) == 0 && $dictionary(where)==2} {
  putserv "NOTICE $nick :Deleted $found \[$id\]"
 }
}

proc dic:msg:status {nick uhost handle line} {
 global dictionary
 if {$dictionary(allowmsg)==0} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 dic:intr:status $nick
 putlog "$nick@PrivMsg $dictionary(statustrigger)"
}

proc dic:msg:search {nick uhost handle line} {
 global dictionary
 if {$dictionary(allowmsg)==0} { return 0 }
 if {[dic:check:flood $handle]} { return 0 }
 if {$line == "" && $dictionary(quiret) == 1} { return 0 }
 if {$line == ""} {
  if {$dictionary(where)==1} { putserv "PRIVMSG $chan :Syntax is !search <word>" }
  if {$dictionary(where)==2} { putserv "NOTICE $nick :Syntax is !search <word>" }
  return 0
 }
 dic:intr:search $nick $line
 putlog "$nick@PrivMsg $dictionary(searchtrigger) $line"
}

### INIT ###
if {![file exists $dictionary(file)]} {
 set dictionary(db) ""
 putlog "No database found - Creating new."
 set fp [open $dictionary(file) w+]
 puts $fp ""
 close $fp
} else { dic:loaddb }

set dictionary(changed) 0
set dictionary(flood) 0
if {![info exists dictionary(imtemphub)]} { set dictionary(imtemphub) 0 }

bind time - "10 10 * * *" dic:backup
proc dic:backup {m h d mm y} {
 global dictionary
 if {[expr $d % 7]==0 && $dictionary(emailbackup)!=0} {
  #Mail backup (only works on linux/unix/etc.
  foreach i [split $dictionary(emailbackup) " "] {
   catch { exec cat $dictionary(file) | mail -s "Dictionary backup" $i }
  }
 }
 #File backup (Once a day at 10:10am)
 if {$dictionary(filebackup) != 0} { file copy -force $dictionary(file) $dictionary(filebackup) }
}

bind time - "* * * * *" dic:save:list
proc dic:save:list {m h d mm y} {
 global dictionary
 if {$dictionary(imtemphub) > 0} { set dictionary(imtemphub) [expr $dictionary(imtemphub) - 1] }

 if {$dictionary(flood)<$dictionary(floodlimit)} { set dictionary(flood) 0 }

 if {$dictionary(changed)==1} {
  set fp [open $dictionary(file) w+]
  foreach line $dictionary(db) { puts $fp [join [lrange $line 0 end]] }
  close $fp
  set dictionary(changed) 0

 if {$dictionary(xml) == 1} {
  set fp [open $dictionary(xmlname) w+]
  puts $fp "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"
  puts $fp "<Dictionary>"

  foreach line $dictionary(db) {
   puts $fp "<entry>"
   puts $fp "<author>[join [lindex $line 0]]</author>"
   puts $fp "<word>[join [lindex $line 2]]</word>"
   puts $fp "<time>[join [lindex $line 1]]</time>"
   puts $fp "<def>[join [lrange $line 3 end]]</def>"
   puts $fp "</entry>"
  }
  puts $fp "</Dictionary>"
  close $fp
 }
 }
}

bind evnt - PREREHASH dic:prerehash
proc dic:prerehash {type} {
 global dictionary
 set fp [open $dictionary(file) w+]
 foreach line $dictionary(db) { puts $fp $line }
 close $fp
}

if {![info exists dictionary(db)]} { set dictionary(db) "" }

putlog "Dictionary $dictionary(ver) loaded!"

