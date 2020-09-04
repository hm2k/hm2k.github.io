##
## total files and lines of text in all files in a directory
##

## SETTINGS #####################################

# Where is your file directory?
set total_file_dir "/home/serialz/public_html/cracks/"

# Where is your lists directory?
set total_lines_dir "/home/serialz/public_html/serials/"

###############################################################
## Do not edit below here unless you know what you are doing ##
###############################################################

bind pub - !total pub_total

#only does files atm
proc pub_total {nick host hand chan text} {
  global total_file_dir total_lines_dir

  #check to make sure this is only to be used by ops
  if {![isop $nick $chan]} {return 0}
  set total_files [total:files $total_file_dir]
  set total_lines [total:lines $total_lines_dir]
  if {[expr $total_files + $total_lines] != 0} { 
  	puthelp "PRIVMSG $chan :\001ACTION has a total of $total_lines lines and $total_files files\001"
  } else { 
  	puthelp "NOTICE $nick :nothing found"
  }
  return 1
}

proc total:files {dir} {
  if {[string range $dir end end] != "/"} {
    append dir "/"
  }
  set r 0
  set l [glob -nocomplain $dir*]
  foreach f $l {
    if {![file isdirectory $f]} {
    	incr r
    }
  }
  return $r
}

proc total:lines {dir} {
 set data [listfiles $dir]

 set lines 0
 foreach sdb $data {
	set fp [open $sdb "r"]
	set data [read -nonewline $fp]
	close $fp
	set lines [expr $lines + [llength [split $data "\n"]]]
 }
 return $lines
}

proc listfiles {dir} {
  if {[string range $dir end end] != "/"} {
    append dir "/"
  }
  set r ""
  set l [glob -nocomplain $dir*]
  foreach f $l {
    if {[file isdirectory $f]} {
      set r [concat $r [listfiles $f]]
    } elseif {[file isfile $f]} {
        lappend r $f
    }
  }
  return $r
}

putlog "Loaded \002total addon v0.1\002 by HM2K"
