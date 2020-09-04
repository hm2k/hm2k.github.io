<?php
/*
Plugin Name: Digg This
Plugin URI: http://www.hm2k.com/projects/wp-digg-this/
Description: A simple plugin for <a href="http://digg.com/tools/integrate">digg.com integration</a> using an iframe, mimicing the "digg this" as seen on wordpress.com blogs. Also see: <a href="http://wordpress.org/support/topic/139124">digg this</a>.
Author: HM2K
Version: 0.2
Author URI: http://www.hm2k.com/
*/

//core function
function digg_this($input) {
	//these variables are editable
	$style='float: right; margin-left: 5px; margin-bottom: 5px; padding: 2px 0 2px 2px; background: #fff;';
	$pattern='#\[digg=(http://(.*?|www\.)digg.com/.+?)\]#is';
	$replace='<iframe src="http://digg.com/api/diggthis.php?u=%s" height="82" width="55" frameborder="0" scrolling="no" style="%s"></iframe>';
	
	//do not edit the below
	if (preg_match($pattern,$input,$matches)) {
		$url=urlencode(trim($matches[1]));
		$replace=sprintf($replace,$url,$style);
		$input=preg_replace($pattern,$replace,$input);
	}
	return $input;
}

//passes the_content through the above function
add_action('the_content', 'digg_this');

?>