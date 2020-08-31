<?php
$datei = fopen("counter.dat","r");
$counter = fgets($datei,1000);
fclose($datei);
$counter=$counter + 1;
echo "<font size=\"1\">Hits: $counter";
$datei = fopen("counter.dat","w");
fwrite($datei, $counter);
fclose($datei);
?>