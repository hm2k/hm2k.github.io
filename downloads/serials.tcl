##
## serial list search v0.2 by HM2K (based on a script by [DrN])
##

#Change the prefix for the channel/msg commands - if not already set
if {![info exists cmdchar_]} {set cmdchar_ "!"}

# Which channels shall the commands work on?
set sz(chans) "#!serialz #newserialz #serialz"

# Set this to the maximum number of results to return
# This number can't be exceeded with the --l search switch.
set sz(maxsearch) 50

# Set this to the default number of results to return
set sz(defaultmaxsearch) 1

# [0/1] Set this to a 1 to highlight the first match in the line
set sz(highlight) 1

# Ignore any lookup requests when the queue list exceeds this number
# Set this to 0 to disable it.
set sz(maxqueue) 200

# The full path to the location of your list files
set sz(path) "/home/serialz/public_html/serials/"

# Set this to the path/filename.ext of the file you wish to store data
# submitted to the script by the users. You can point this to the main
# serial datafile, but just in case they submit crap/flood it, it'd be
# easier to store them in a seperate file so you can verify them.

set sz(addserials) "$sz(path)!addserials.txt"

 proc strip-html {html} {
     regsub -all -- {<[^>]*>} $html "" html
     return $html
 }

proc cmdchar { } {
 global cmdchar_
 return $cmdchar_
}

proc chncheck {chan check} {
  foreach c $check {
    if {$chan == $c} {
      return 1
    }
  }
  return 0
}

bind msg - [cmdchar]help sz:msg_help
proc sz:msg_help {nick uhost handle args} {
  global sz botnick
    sz:privmsg $nick "Serial Search Usage: [cmdchar]serial <search string> (eg: [cmdchar]serial winrar)"
    sz:privmsg $nick "You can exclude words with a - (eg: [cmdchar]serial adobe -photoshop)"
    sz:privmsg $nick "You can return more/less results using --l <num> (eg: [cmdchar]serial --l 5 <search string>)"
    sz:privmsg $nick "To add an entry: /msg $botnick [cmdchar]addserial Program Name : Registration Data"
    if {$sz(maxsearch) != 0} { sz:privmsg $nick "There is a limit of $sz(maxsearch) results in effect."}
  return 1
}

bind dcc - serial sz:dcc_serialsearch
proc sz:dcc_serialsearch {hand idx args} {
  if {[lindex $args 0] != ""} {
      set a [lindex $args 0]
      doserialsearch $idx $a
  } else {
    putidx $idx "Usage: .serial <search string>"
         }
  return 1
}


bind pub - [cmdchar]serial sz:pub_serialsearch
proc sz:pub_serialsearch {nick uhost handle chan args} {
  global sz
  if {[chncheck $chan $sz(chans)]} {

	  if {($sz(maxqueue) > 0) && 
	      ([queuesize help] > $sz(maxqueue))} {
	   putserv "NOTICE $nick :Sorry, our queue is near full. Please wait a few minutes and make your request again."
	   return 0
	     }
	  if {[lindex $args 0] != ""} {

	  set a [lindex $args 0]
	  doserialsearch $nick $a
	  } else {
	    puthelp "NOTICE $nick :Usage: [cmdchar]serial <search string>"
	  }
	  return 1
  }
}

bind msg - [cmdchar]serial sz:msg_serialsearch
proc sz:msg_serialsearch {nick uhost handle args} {
  global sz botnick
  if {($sz(maxqueue) > 0) && ([queuesize help] > $sz(maxqueue))} {
   putserv "NOTICE $nick :Sorry, our queue is near full. Please wait a few minutes and make your request again."
   return 0
  }
  if {[lindex $args 0] != ""} {
  set a [lindex $args 0]
  doserialsearch $nick $a
  } else {
    puthelp "NOTICE $nick :Usage: /msg $botnick [cmdchar]serial <search string>"
  }
  return 1
}

proc doserialsearch {nick data} {
	global sz botnick
	set maxsearch $sz(defaultmaxsearch)

	set wpos [lsearch [string tolower $data] "--l"]
	if {$wpos >-1} {
	 if {[isnum [lindex $data [expr $wpos +1]]]} {
	  set data "[lrange $data 0 [expr $wpos -1]] [lrange $data [expr $wpos + 1] end]"
	  set newmaxsearch [lindex $data $wpos]
	  set data "[lrange $data 0 [expr $wpos -1]] [lrange $data [expr $wpos + 1] end]"
	  while {[string index $data [expr [string length $data]-1]]==" "} {
	   set data [string range $data 0 [expr [string length $data] - 2]]}
	  if {$newmaxsearch > $sz(maxsearch)} {sz:privmsg $nick "You can not exceed $sz(maxsearch) search results."
                                            return 0
                                           } else {set maxsearch $newmaxsearch}
                                     }
               }
    #if {$sz(maxsearch) != 0} {sz:privmsg $nick "There is a limit of $maxsearch results in effect."}
    #sz:privmsg $nick "Searching for \"$data\""
    set data [string tolower $data]

    set serialdata [serialfiles $sz(path)]

    if {$serialdata != ""} {

	foreach sdb $serialdata {
	 set sdbfile $sdb

	 if {![file exists $sdbfile]} {
	  putlog "SZ: (error) Can't find $sdbfile"
	  sz:notice $nick "Can't find Database file $sdbfile"
	  } else {
	    #searchserials $nick $maxsearch $sdbfile $data
	   #puthelp "NOTICE $nick :searchserials $nick $maxsearch $sdbfile $data"

	   ##NOTICE: searchserials proc was moved into this proc to ensure limits work correctly across many files
		set database $sdbfile
	    #start serialsearch
	    set in [open $database r]
	    set totfound 0
	    set linenum 0

	while {![eof $in]} {
	      set line [gets $in]
	      incr linenum 1
	      set found 0
	set _line [string tolower $line]
	set tplus 0
	for {set l 0} {$l < [llength $data]} {incr l} {
	 set w [lindex $data $l]
	 if {[string index $w 0]=="-"} {
	     set w [string range $w 1 end]
	     if {[string match "*$w*" $_line]} {set found [expr $found - 1]}
	  } else {
		if {[string match "*$w*" $_line]} {incr found}
		incr tplus
	  }
	}
	 if {$tplus == $found} {
	if {$sz(highlight)} {
	    for {set l 0} {$l < [llength $data]} {incr l} {
	     set w [lindex $data $l]
	      if {[string index $w 0]!="-"} {
	     set spos [string first $w [string tolower $line] 0]
	     set fpos [expr $spos + [string length $w]]
	     set line "[string range $line 0 [expr $spos - 1]]\002[string range $line $spos $fpos]\002[string range $line [expr $fpos + 1] end]"
					     }
							  }
				  }
	     #clean up those nasty serials 2000 lists
	     set line [strip-html $line]
	     set line [string map {"\x09" " "} $line]

       set totfound [expr $totfound + 1]

       if {$totfound == 1 && $wpos < 0} {
		sz:notice $nick "$line"
		return 1
        } else {
		sz:privmsg $nick "$line"
		 if {$totfound >= $maxsearch} {
		  sz:privmsg $nick "There is more than $maxsearch results. (for help issue !help)"
		  close $in
		  return 0
		 }
	   }
     }
    }
    close $in
    #sz:notice $nick "There was a total of $totfound out of $linenum entries matching your query."

	   ##end searchserial proc

	  }
	}
    }
}

proc serialfiles {dir} {
  if {[string range $dir end end] != "/"} {
    append dir "/"
  }
  set r ""
  set l [glob -nocomplain $dir*]
  foreach f $l {
    if {[file isdirectory $f]} {
      set r [concat $r [serialfiles $f]]
    } elseif {[file isfile $f]} {
        lappend r $f
    }
  }
  return $r
}

bind msg - [cmdchar]addserial sz:msg_addserial
proc sz:msg_addserial {nick uhost hand text} {
	global sz

	if {![file exists $sz(addserials)]} {
		     set out [open $sz(addserials) "w"]
		     puts $out ""
		     close $out
	}
	 
	 if {$text == ""} {sz:notice $nick "Usage: [cmdchar]addserial Program name : Registration Data"
			   return 0}
	 set out [open $sz(addserials) "a+"]
	 puts $out "[ctime [unixtime]] -$nick- $text"
	 close $out
	 sz:privmsg $nick "Entry submitted: $text"
}



proc sz:privmsg {nick text} {
	if {[isnum $nick]} {putidx $nick $text} else {puthelp "PRIVMSG $nick :$text"}
}

proc sz:notice {nick text} {
	if {[isnum $nick]} {putidx $nick $text} else {puthelp "NOTICE $nick :$text"}
}

# isnumber taken from alltools.tcl
proc isnum {string} {
  if {([string compare $string ""]) && (![regexp \[^0-9\] $string])} then {
    return 1
  }
  return 0
}

putlog "Loaded \002serial list search v0.2\002 by HM2K"
