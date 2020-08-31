<?
/*

Link Urls and/or Link Email Addresses - HM2K (www.hm2k.org)

This will create HTML hyperlinks from any URLs or Email Addresses in a peice of text.

*/

function linkurls($text) {
	$pattern = '/((http|https|ftp):\/\/|www)' . '[a-z0-9\-\._]+\/?[a-z0-9_\.\-\?\+\/~=&#;,]*' . '[a-z0-9\/]{1}/si';
	return preg_replace( $pattern, "<a href=\"$0\" target=\"_blank\">$0</a>", $text );
}

function linkemails($text) {
	$pattern = '/\b[\w\'.-]+@[\w\'.-]+\.[a-z]{2,8}\b/i';
	return preg_replace( $pattern, "<a href=\"mailto:$0\">$0</a>", $text );
}

//Example

$text="I am HM2K, my website is http://www.hm2k.org/";
$text=linkurls($text);
echo $text;

?>