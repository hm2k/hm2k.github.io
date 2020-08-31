<?php if ($_SERVER['PHP_SELF'] != "/index.php") { header("Location: /?flash"); } ?>
<p><strong class="title">Flash</strong><br>
  <a href="?flash">Funny Flash</a>, <a href="?flash=games">Flash Games</a>, <a href="?flash=switch">Switch 
  to Mac/from Mac Flash</a>, etc...</p>
<?php
  	if ($flash == 'games') { include 'games/index.php'; }
  	if ($flash == 'switch') { include 'switch/index.html'; }
	elseif ($flash == '') {
	$uploadpath = "flash/";
	print "<FORM ENCTYPE=\"multipart/form-data\" ACTION=\"\" METHOD=\"POST\">\n";
	print "Image to upload: <INPUT TYPE=\"file\" NAME=\"userfile\">\n";
	print "Password: <INPUT TYPE=\"password\" NAME=\"pass\">\n";
	print "<INPUT TYPE=\"submit\" VALUE=\"Upload\">\n";
	print "</FORM>";
	$max_size = 1024*1024*1024;
	$pw = "flash2";
	if (is_uploaded_file($HTTP_POST_FILES['userfile']['tmp_name'])) {
		if (!isset($HTTP_POST_FILES['userfile'])) exit;
		if ($pass != $pw) { echo "Invalid Password"; exit; }
		if ($HTTP_POST_FILES['userfile']['size']>$max_size) { echo "The file is too big<br>\n"; exit; }
		if (($HTTP_POST_FILES['userfile']['type']=="application/x-shockwave-flash") || ($HTTP_POST_FILES['userfile']['type']=="application/x-director")) {
		if (file_exists($uploadpath . $HTTP_POST_FILES['userfile']['name'])) { echo "The file already exists<br>\n"; exit; }
		$res = copy($HTTP_POST_FILES['userfile']['tmp_name'], $uploadpath .
		$HTTP_POST_FILES['userfile']['name']);
		if (!$res) { echo "upload failed!<br>\n"; exit; } else { echo "upload sucessful<br>\n"; }
		echo "File Name: ".$HTTP_POST_FILES['userfile']['name']."<br>\n";
		echo "File Size: ".$HTTP_POST_FILES['userfile']['size']." bytes<br>\n";
		echo "File Type: ".$HTTP_POST_FILES['userfile']['type']."<br>\n";
	} else { echo "Wrong file type<br>\n"; exit; }
	}
	print "<hr>";
	chdir ($uploadpath);
	$uploaddir = dir(".");
	$i=0;
	while($datei = $uploaddir->read()) { 
	   if(substr($datei,-1) != "." && $datei!="index.php") { 
	                if(is_dir($datei)) {
	                        $dirs[]=$datei;
	                } else {
	                        $files[$i]['filename']=$datei;
	                        $files[$i]['timestamp']=filemtime($datei);
	                        $i++;
	                }
	 }
	} 
	$uploaddir->close(); 
	foreach($files as $file) $s[] = $file['timestamp']; array_multisort($s, SORT_DESC, SORT_NUMERIC, $files);
	echo '<table width="100%"><tr><td>Name<br><br></td><td>Type<br><br></td><td>Filesize<br><br></td><td>Last Modified<br><br></td></tr>';
	foreach($files as $file) {
  	      $fs=filesize($file['filename']);
  	      if($fs<1024) {
   	             $fs=$fs.' byes';
   	     } elseif($fs<1024*1024) {
        	        $fs=round($fs/1024,2);
	                $fs=$fs.' kb';
        	} elseif($fs<1024*1024*1024) {
                	$fs=round($fs/1024/1024,2);
	                $fs=$fs.' mb';
        	}
	        echo '<tr><td><a href="'.$uploadpath.''.$file['filename'].'">'.$file['filename'].'</a></td><td>'. strrchr($file['filename'],'.').'</td><td>'.$fs.'</td><td>'.date("d-M-Y H:i",$file['timestamp']).'</td></tr>';
	}
	echo '</table>';
	}
	?>