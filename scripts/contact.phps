<table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td valign="top"> 
      <?php
if ($Submit == 'Submit') {
        $headers = "From: $email\r\n";
        $message .= "\n";
        $message .= "Name:              $name\n";
        $message .= "Email:                     $email\n";
        $message .= "Query:                     $query\n";
        $message .= "\n";
        $message .= "Remote Address:            $REMOTE_ADDR\n";
        $message .= "Remote Host:               $REMOTE_HOST\n";
        $message .= "User Agent:                $HTTP_USER_AGENT\n";
        if (mail("$emails", $subject, $message, $headers)) {
                echo '<p>Your enquiry was succesfully sent, You should recieve a reply in the next 24 hours<p>';
        } else {
                echo '<p>There was an error, go <a href=javascript:history.back()>back</a> and try again</p>';
        }
}
?>
      <form action=?nav=contact method=POST>
        <input name=subject type=hidden id=subject value=Contact Form>
        <table width="50%" border="0" cellpadding="5" cellspacing="0">
          <tr> 
            <td nowrap><p>Who to email:</p></td>
            <td nowrap><p> 
                <select name="emails" id="emails">
                  <option value="test@hm2k.org">Test1</option>
                  <option value="test@hm2k.org">Test2</option>
                  <option value="webmaster@hm2k.org">Webmaster</option>
                </select>
              </p></td>
          </tr>
          <tr> 
            <td nowrap><p>Name:</p></td>
            <td nowrap> <p> 
                <input id=name size=30 name=name maxlength=30>
              </p></td>
          </tr>
          <tr> 
            <td nowrap><p>Email:</p></td>
            <td nowrap> <p> 
                <input id="email" size="20" name="email">
              </p></td>
          </tr>
          <tr> 
            <td nowrap><p>Query:</p></td>
            <td nowrap><p> 
                <textarea name="query" cols="35" rows="6" id="query"></textarea>
              </p></td>
          </tr>
          <tr> 
            <td nowrap><p>&nbsp;</p></td>
            <td nowrap><p> 
                <input type="submit" name="Submit" value="Submit">
              </p></td>
          </tr>
        </table>
      </form>
      </td>
  </tr>
</table>
