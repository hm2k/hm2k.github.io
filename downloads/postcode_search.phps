<?php

/**
 * How to search by nearest postcode
 *
 * @license     LGPL - http://www.gnu.org/licenses/lgpl.html
 * @copyright   2008 HM2K <php [spat] hm2k.org>
 * @link        http://www.hm2k.com/posts/how-to-search-by-nearest-uk-postcode-in-php
 * @author      HM2K <php [spat] hm2k.org>
 * @version     $Revision: 1.1 $
 */

define('POSTCODE','/[A-Z]{1,2}[0-9R][0-9A-Z]?/');

function postcode_closest ($needle,$haystack) {
	if (!$needle || !$haystack) { return; }
	if (!is_array($haystack)) { return; }

	foreach ($haystack as $postcode) {
		$results[$postcode]=postcode_distance($needle,$postcode);
	}
	return closest($needle,$results);
}

function postcode_distance ($from,$to) {
	// Setting for if you have a different database structure
	$sql = "SELECT `lat`, `lon` FROM `postcodes_uk` WHERE `postcode`='%s'";
	
	// This is a check to ensure we have a database connection
	if (!@mysql_query('SELECT 0')) { return; }

	// Simple regex to grab the first part of the postcode
	preg_match(POSTCODE,strtoupper($from),$match);
	$one=$match[0];
	preg_match(POSTCODE,strtoupper($to),$match);
	$two=$match[0];

	$mysql = sprintf($sql,$one);
	$query = mysql_query($sql);
	$one = mysql_fetch_row($query);

	$mysql = sprintf($sql,$two);
	$query = mysql_query($sql);
	$two = mysql_fetch_row($query);

	$distance = distance($one[0], $one[1], $two[0], $two[1]);
	
	// For debug only...
	//echo "The distance between postcode: $from and postcode: $to is $distance miles\n";
	
	return $distance;
}

function distance($lat1, $lon1, $lat2, $lon2, $u='1') {
	//based on http://www.zipcodeworld.com/samples/distance.php.html

	$u=strtolower($u);
	if ($u == 'k') { $u=1.609344; }		// kilometers
	elseif ($u == 'n') { $u=0.8684; }	// nautical miles
	elseif ($u == 'm') { $u=1; }		// statute miles (default)

	$d=sin(deg2rad($lat1))*sin(deg2rad($lat2))+cos(deg2rad($lat1))*cos(deg2rad($lat2))*cos(deg2rad($lon1-$lon2)); 
	$d=rad2deg(acos($d)); 
	$d=$d*60*1.1515;

	$d=($d*$u); // apply unit
	$d=round($d); // optional
	return $d;
}

function closest ($needle,$haystack) {
	if (!$needle || !$haystack) { return; }
	if (!is_array($haystack)) { return; }

	$smallest=min($haystack); //smallest value

	foreach ($haystack as $key => $val) {
		if ($val == $smallest) { return $key; }
	}
}

/***

//Test Case

if ($_POST) {
	include_once('db.php');
	$postcodes=array('TF9 9BA','ST4 3NP');
	$input=strtoupper($_POST['postcode']);
	$closest=postcode_closest($input,$postcodes);
}

if (isset($closest)) {
	echo "The closest postcode is: $closest";
}

echo '
<form action="" method="post">
Postcode: <input name="postcode" maxlength="9?><br>
<input type="submit">
</form>
';

***/

?>