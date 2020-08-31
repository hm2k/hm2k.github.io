<form action="<?PHP echo $PHP_SELF; ?>" method="POST">
  <table border="0" cellspacing="0" cellpadding="2">
    <tr>
      <td>Day:</td>
      <td>Month:</td>
      <td>Year:</td>
    </tr>
    <tr>
      <td><input name="day" type="text" id="day" value="20"></td>
      <td><input name="month" type="text" id="month" value="04"></td>
      <td><input name="year" type="text" id="year" value="1985"></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><input name="Submit" type="Submit" value="Submit"></td>
    </tr>
  </table>
  </form>
<?php
function day_counter($countdown_day, $countdown_month, $countdown_year) {
        $dc_date = mktime(0,0,0,$countdown_month,$countdown_day,$countdown_year);

        if ( $dc_date > mktime(0,0,0,date("m"),date("d"),date("Y"))) {
        // Days until the given date
        echo (int)(($dc_date - time(void))/86400) . " days until";
        } else {
        // Days since the given date
        echo (int)((time(void) - $dc_date)/86400) . " days since";
        }
}
if ($_REQUEST['Submit']) {
	$day = $_REQUEST['day'];
	$month = $_REQUEST['month'];
	$year = $_REQUEST['year'];
	day_counter($day,$month,$year);
	echo ' '.$day.'/'.$month.'/'.$year;
}
?>