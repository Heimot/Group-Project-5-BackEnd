<?php
// Haetaan yhteys ja luvat tiedon näyttämiseen
require_once 'inc/headers.php';
require_once 'inc/functions.php';

$id = filter_var($_GET['id'], FILTER_SANITIZE_NUMBER_INT);

// Noudetaan tietokannasta halutut tiedot
try {
   $db = slDB();
   $sql = 'select * from comments WHERE productID='. $id;
   $query = $db->query($sql);
   $results = $query->fetchAll(PDO::FETCH_ASSOC);
   echo header ('http1.1 200 OK');
   echo json_encode($results);
}
// Virheilmoitus
catch (PDOException $pdoex) {
   returnError($pdoex);
}
?>