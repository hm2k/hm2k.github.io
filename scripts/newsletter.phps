<?php
$logfile="newsletter.RANDOM.txt"; //set this file as a random filename or put in a folder with access by AUTH only.

$sendemail=""; //set this to 1, to enable an email to be sent out when people signup
$subject="HM2K - Newsletter";
$emailfrom="HM2K <newsletter@hm2k.org>";
$emailbody='<p>Thank you for subscribing to the <a href="http://www.hm2k.org/">HM2K.org</a> newsletter.</p>';

function checkemail($email) {
 if(preg_match("/^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$/" , $email)){
  list($username,$domain)=split('@',$email);
  if(!getmxrr ($domain,$mxhosts)){ return false; }
  return true;
 }
 return false;
}

if ($_POST) {
		if (isset($_POST['email'])) { $email=$_POST['email']; }
		if (isset($_POST['action'])) { $check=$_POST['action']; }
		$emaillist=file($logfile);
		$log="$email\n";
		$subject="$subject\n";
		
		if (!file_exists($logfile)) { echo '<p>Error: Could not find email database, please contact the webmaster</p>'; return; }
		if (!is_writable($logfile)) { echo '<p>Error: email database is not writable, please contact the webmaster</p>'; return; }
		if ($check == "subscribe")
	   	{
	   		if (!checkemail($email)) { echo '<p>Error: You did not enter a valid email address, go <a href=javascript:history.back()>back</a> and try again</p>'; return; }
			if (in_array("$email\n", $emaillist)) { echo '<p>Your email address is already in our database. <a href=javascript:history.back()>Go back</a></p>'; }
			else {
			 	$fp=fopen($logfile,"a+");
	    	  		fputs($fp, $log);
			  	fclose($fp);
			  	if ($sendemail != "") {
					$headers = "X-Mailer: $REMOTE_ADDR - $HTTP_USER_AGENT\n";
					$headers .= "From: $emailfrom\r\n";
					$headers .= "Content-type: text/html;\r\n";
			        	$message = "$emailbody\n";
			        	$message .= "\n";
			        	if (mail($email, $subject, $message, $headers)) { echo '<p>Thank you for subscribing to our newsletter, an email has been sent.</p>'; return; }
					else { echo '<p>Error: mail could not be sent, go <a href=javascript:history.back()>back</a> and try again</p>'; return; }
				}
				else { echo '<p>Thank you for subscribing to our newsletter. <a href=javascript:history.back()>Go back</a></p>'; }
			}

		}
		if ($check == "unsubscribe")
	   	{
			if (in_array("$email\n", $emaillist)) {
				$emaillist=array_diff($emaillist, array("$email\n"));
				$fp=fopen($logfile,"w");
				foreach ($emaillist as $line) {
		    	  		fputs($fp, $line);
		    	  	}
				fclose($fp);
				echo "<p>You have successfully unsubscribed from our newsletter. <a href=javascript:history.back()>Go back</a></p>";
				return;
			}
			else { echo '<p>Your email address is not in our database. <a href=javascript:history.back()>Go back</a></p>'; }
		}
}
else {
	echo '<form action="" method="post" name="newsletter" id="newsletter">
	  <p>
	    <input name="email" type="text" id="email" maxlength="100">
	    <input name="action" type="radio" value="subscribe" checked> 
	    Subscribe 
	    <input name="action" type="radio" value="unsubscribe"> 
	    Unsubscribe
	    <input type="submit" name="Submit" value="Submit">
	  </p>
	</form>';
}
?>