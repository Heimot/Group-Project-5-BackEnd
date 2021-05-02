<?php
// Haetaan yhteys ja luvat tiedon näyttämiseen
require_once 'inc/headers.php';
require_once 'inc/functions.php';

$commentid = filter_var($_GET['commentid'], FILTER_SANITIZE_NUMBER_INT);

// Poistetaan tietokannasta id:n avulla kommentti
try {
   $db = slDB();
   $query = $db->prepare("delete from comments where id= :id");
   $query->bindValue(":id", $commentid, PDO::PARAM_INT);
   $query->execute();
   echo header ('HTTP/1.1 200 OK');
   
   if(isset($_SERVER['HTTP_REFERER'])) {
      $previous = $_SERVER['HTTP_REFERER'];
  }
}
// Virheilmoitus
catch (PDOException $pdoex) {
   returnError($pdoex);
}
?>