<?php
	$datei = fopen("counter.dat","w");
	fwrite($datei, $REMOTE_ADDR);
	fclose($datei);
	$filelines = file("counter.dat");
	$i = count($filelines);
	echo "Visitors: $i" ;
?>