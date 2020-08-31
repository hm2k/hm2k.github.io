<HTML>
<HEAD>
<TITLE>Add your link</TITLE></HEAD>
<p><?php
$submit = "Add URL";
if ($action == "$submit") {
	function Stripn($name) 
	{ 
		$name = str_replace("'", "''", $name);
		return $name;
	}
	function Stripd($desc) 
	{ 
		$desc = str_replace("'", "''", $desc);
		return $desc;
	}
$name = htmlspecialchars(stripslashes(Stripn($name)));
$desc = htmlspecialchars(stripslashes(Stripd($desc)));

$link_file="../links.html";
$write = "<li> <a href=\"$url\">$name</a> - $desc<BR>\n";
$fp=fopen($link_file, "a");
fwrite($fp, $write);
fclose($fp);

echo "<b><font size=3>$name has been added!</font><BR>Thanks for your submission.</b>";
include $link_file;
?>
<?php
}
else {
print("
	Add Link:<BR>
	<FORM METHOD=POST ACTION=\"$PHP_SELF\">
	Site's Title: <input type=\"TEXT\" name=\"name\" size=20 maxlength=50><BR>
	Site's URL: <input type=\"TEXT\" name=\"url\" size=20 maxlength=70 value=\"http://\" target=\"_blank\"><BR>
	Site's Description: <input type=\"TEXT\" name=\"desc\" size=20 maxlength=200><BR>
	<center><input type=submit name=action value=\"$submit\"></center></form>
");
}
?>
</p>
