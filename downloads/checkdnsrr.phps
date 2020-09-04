<?php

// checkdnsrr() support for Windows by HM2K <php [spat] hm2k.org>
function win_checkdnsrr($host, $type='MX') {
	if (strtoupper(substr(PHP_OS, 0, 3)) != 'WIN') { return; }
	if (empty($host)) { return; }
	$types=array('A', 'MX', 'NS', 'SOA', 'PTR', 'CNAME', 'AAAA', 'A6', 'SRV', 'NAPTR', 'TXT', 'ANY');
	if (!in_array($type,$types)) {
        user_error("checkdnsrr() Type '$type' not supported", E_USER_WARNING);
        return;
	}
	@exec('nslookup -type='.$type.' '.escapeshellcmd($host), $output);
	foreach($output as $line){
		if (preg_match('/^'.$host.'/',$line)) { return true; }
	}
}

// Define
if (!function_exists('checkdnsrr')) {
    function checkdnsrr($host, $type='MX') {
        return win_checkdnsrr($host, $type);
    }
}

/* example */

echo "<pre>";
$domains=array('example.com','php.net');
foreach ($domains as $domain) {
	$result=checkdnsrr($domain);
	echo $domain.':';
	echo $result?"true\n":"false\n";
}

?>
