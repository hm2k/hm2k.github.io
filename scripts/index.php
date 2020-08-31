<?
	//config settings
	
	//the path to upload to, default is "./", which means current directory.
	$uploadpath = "./";
	//an md5 hash for password matching.
	$pw = '75ab729cd6cbe35f170e1973348551c7';
	//the max file size.
	$max_size = 1024*1024*1024;

	echo "<FORM ENCTYPE=\"multipart/form-data\" ACTION=\"\" METHOD=\"POST\">\n";
	echo "File to upload: <INPUT TYPE=\"file\" NAME=\"userfile\">\n";
	echo "Password: <INPUT TYPE=\"password\" NAME=\"pass\">\n";
	echo "<INPUT TYPE=\"submit\" VALUE=\"Upload\">\n";
	echo "</FORM>";
	if ($_POST) {
		$pass=md5($_POST['pass']);
		if ($pass === $pw) {
			if (!isset($HTTP_POST_FILES['userfile'])) { die("no file was uploaded."); }
			if (is_uploaded_file($HTTP_POST_FILES['userfile']['tmp_name'])) {
				if ($HTTP_POST_FILES['userfile']['size']>$max_size) { die("The file is too big<br>\n"); }
				if (file_exists($uploadpath . $HTTP_POST_FILES['userfile']['name'])) { die("The file already exists<br>\n"); }
				if (!copy($HTTP_POST_FILES['userfile']['tmp_name'], $uploadpath . $HTTP_POST_FILES['userfile']['name'])) { die("upload failed!<br>\n"); }
				else { echo "upload sucessful.<br>\n"; }
				echo "File Name: ".$HTTP_POST_FILES['userfile']['name']."<br>\n";
				echo "File Size: ".$HTTP_POST_FILES['userfile']['size']." bytes<br>\n";
				echo "File Type: ".$HTTP_POST_FILES['userfile']['type']."<br>\n";
			}
		}
		else { die("Invalid Password"); }
	}
	echo "<hr>";
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
	echo '</font></html>';
?>