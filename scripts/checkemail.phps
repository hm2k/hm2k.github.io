<?
/*

Valid Email Address Checker - HM2K (www.hm2k.org)

Checks if an email address is valid by checking if it has a valid mail server.

Example:
    if (checkemail("spam@hm2k.org")) { echo "This email address is valid."; }
    else { die("This email address is not valid."); }
*/
function checkemail($email) {
 if(preg_match("/^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$/" , $email)) {
  list($username,$domain)=split('@',$email);
  if(!getmxrr($domain,$mx)) { return; }
  return true;
 }
 return;
}
?>