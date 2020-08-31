<strong>quotes</strong>
<p> 
  <?php
	$filelines = file("quotes.txt");
	$i = count($filelines);
	srand((double)microtime()*1000000);
	$idx = rand(0,$i-1);
	$quote = $filelines[$idx];
	$quote = explode(" ",$quote,3);
	$nick = $quote[0];
	if ($quote[1] == 'N/A') { $date = 'N/A'; }
	else { $date = date('l dS of F Y h:i:s A',$quote[1]); }
	$quote = $quote[2];
	print ("[<strong>Random Quote</strong>] $quote ; added by $nick on $date ");
?>
</p>
