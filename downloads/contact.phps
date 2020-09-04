<?php

/*

	PHP Contact Form by HM2K v1.0.1 (updated: 02/02/07)

*/

//we want to know if there are any problems!
error_reporting(E_ALL);

/* settings */

// email addresses we're sending to, comma seperated
$emailto				=	'your.name@example.com,spam@hm2k.org';
// prefix for the subject of each email sent out, default is the domain name
$subjectprefix	=	str_replace('www.','',$_SERVER['HTTP_HOST']).':';
// the CORE fields are required for this to work
$fields					=	'name,email,subject,message';
// additional input fields to append to the message (usually different to the core fields)
$extrafields		=	'';
// success message - display this when it did not fail
$successmsg			= '<p>Your message was successfully sent</p>';

// set the html form, feel free to edit this to suit
$form='<form action="" method="POST" name="contact">
	<table border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td nowrap></td>
			<td nowrap><p><strong>(all fields are required)</strong></p></td>
		</tr>
		<tr>
			<td nowrap><p>Your full name:</p></td>
			<td nowrap> <p>
			<input id="name" size="30" name="name" value="{name}" maxlength="64">
			</p></td>
		</tr>
		<tr>
			<td nowrap><p>Your email address:</p></td>
			<td nowrap> <p>
			<input id="email" size="20" name="email" value="{email}">(Must be a valid)</p></td>
		</tr>
		<tr>
			<td nowrap><p>Subject:</p></td>
			<td nowrap> <p>
			<input id="subject" size="20" name="subject" value="{subject}">
			</p></td>
		</tr>
		<tr>
			<td nowrap><p>Your message:</p></td>
			<td nowrap><p>
			<textarea name="message" cols="25" rows="6" id="message">{message}</textarea>
			</p></td>
		</tr>
		<tr>
			<td nowrap><p> </p></td>
			<td nowrap><p>
			<input type="submit" name="contactsubmit" value="Send">
			</p></td>
		</tr>
	</table>
</form>';

/* functions */

// postCleanup - cleans up each post field
function postCleanup($_POST) {
		$allowed_html_tags='<p>,<br>,<b>,<em>,<big>,<small>,<strong>,<pre>';
		foreach ($_POST as $key => $value) {
			$value=trim($value); //remove white space from left and right
			$value=strip_tags($value, $allowed_html_tags); //strip any unwanted tags
			$value=htmlspecialchars($value); //convert special chrs to html entities
			$_POST[$key]=$value;
		}
		return $_POST;
}

// emailValid - check the email address is valid using regex and mail server check
function emailValid($email) {
	$pattern='/^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$/';
	if(preg_match($pattern, $email)) {
	 	list($user,$domain)=split('@',$email);
	  if (getmxrr($domain,$mx='')) { return $email; }
 	}
}
// note: incase this is missing for the above function, we include this to keep it quite
if (!function_exists('getmxrr')) {
	function getmxrr ($domain,$mx) { return true; }
}

// displayErrors - format and return the errors from an array of errors
function displayErrors($errors) {
	$output='<p>The following errors occured:<br>';
	foreach ($errors as $error) {
		$output.="<b>Error:</b> $error<br>\n";
	}
	$output.='</p>';
	return $output;
}

// replaceHTMLvalues - this is the templating/value replacement used to fix the values in the form
function replaceHTMLvalues($html,$array=array()) {
	if (empty($array)) {
		preg_match_all('/\{(.+)\}/i',$html,$matches);
		foreach ($matches[1] as $match) {
			$array[$match]='';
		}
	}
	foreach ($array as $key => $value) { $html=preg_replace("/(\{$key\})/i",$value,$html); }
	return $html;
}

/* code */

//check if the user has been submitted via our form
if (isset($_POST['contactsubmit'])) {
		
		//cleanup the input fields
		$_POST=postCleanup($_POST);
		
		//check the required fields
		$fields=explode(',',$fields);
		foreach ($fields as $field) {
  		if ((!isset($_POST[$field])) || ($_POST[$field] == "")) { 
  			$errors[]=$field.' is a required field.';
  		}
  	}

  	//continue if there's no errors
  	if (!isset($errors)) {
		//check if the email address is valid
  	if (!emailValid($_POST['email'])) { $errors[]='email address is invalid.'; }
  		
  	//set the subject
  	$subject=$_POST['subject'];
  	//add the subject prefix
  	if (isset($subjectprefix)) { $subject=$subjectprefix.' '.$subject; }
  	
		//set message
		$message=$_POST['message'];
		
		//add any additional fields to the existing message
		$extrafields=explode(',',$extrafields);
		foreach ($_POST as $key => $val) {
			if (in_array($key,$extrafields)) { $additional .= "$key: $val<br>\n"; }
		}
		if (isset($additional)) { $message.=$message.'<br>'.$additional; }
		
		//set from
		$from=$_POST['name'].' <'.$_POST['email'].'>';
  	
  	//header management
  	$_headers[]='From: '.$from; //set where the mail is coming from
		$_headers[]='MIME-Version: 1.0'; //for HTML
		$_headers[]='Content-type: text/html; charset=iso-8859-1'; //for HTML
		$_headers[]='X-Originating-IP: '.$_SERVER['REMOTE_ADDR']; //get the IP of the user
		$_headers[]='X-Mailer: '.str_replace('www.','',$_SERVER['HTTP_HOST']).' - '.$_SERVER['HTTP_USER_AGENT']; //user/client details
		$headers='';
		//format the headers ready for sending
		foreach ($_headers as $header) { $headers.=$header."\r\n"; }
		}

		//if there are no errors we will continue
		if (!isset($errors)) {
			//send the mail for each email address we want to send it to
			$emailto=explode(',',$emailto);
			foreach ($emailto as $to) {
	   		if (!mail(emailValid($to), $subject, $message, $headers, '-f'.$from)) {
	   			//if mail fails, there was a problem, report the error...
	   			$errors[]='There was an error sending the email. Please try again later.';
	   		}
			}
		}
		
		//if there are errors, display them
		if (isset($errors)) {
			echo displayErrors($errors);
			echo replaceHTMLvalues($form,$_POST);
		}
		else { 
			//there was no errors, during the post, so it all worked!
			echo $successmsg;
		}
}
//default output
else { echo replaceHTMLvalues($form); }

?>