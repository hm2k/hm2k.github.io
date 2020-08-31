<?

/*

Domain Name Check - HM2K (www.hm2k.org)

Checks to see if a domain is registered or not.

*/

//a shortlist of tlds, their servers, and their no match string.
$tlds["com"]="whois.crsnic.net,no match";
$tlds["net"]="whois.crsnic.net,no match";
$tlds["org"]="whois.publicinterestregistry.net,not found";
$tlds["info"]="whois.afilias.net,not found";
$tlds["name"]="whois.nic.name,no match";
$tlds["biz"]="whois.neulevel.biz,not found";
$tlds["cc"]="whois.nic.cc,no match";
$tlds["co.uk"]="whois.nic.uk,no match";
$tlds["me.uk"]="whois.nic.uk,no match";
$tlds["org.uk"]="whois.nic.uk,no match";

//the function
function checkdomain($domain) {
	//since the list was made outside of the function, I made it global.
	global $tlds;
	//this will grab the extention or tld of the domain of your choice.
	$tld=substr(strrchr($domain, '.'), 1);
	//based on the tld, it will get the correct server for that tld.
	$server=str_replace(strrchr($tlds[$tld], ','), "", $tlds[$tld]);
	//based on the tld, it will then grab the correct no match string.
	$string=substr(strrchr($tlds[$tld], ','), 1);
	//then we open a socket on the whois server.
	$ns=fsockopen($server,43);
	//the domain name is looked up.
	fputs($ns,"$domain\r\n");
	//results are reset (just incase).
	$result="";
	//while there is a connection and data, results are gathered into a var.
	while(!feof($ns)) $result .= fgets($ns,128);
	//the socket is closed.
	fclose($ns);
	//if the no match string is found in the results, it will return nothing, ie: no match was found, you can register this domain.
	if (eregi("$string",$result)) { return; }
	//otherwise it will return 1, ie: there was a match, the domain is already registered.
	else { return 1; }
}

//example code
if (checkdomain($_GET['domain'])) { echo "This domain has already been registered."; }
else { die("This domain name is not registered."); }
?>