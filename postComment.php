<?php
// Haetaan yhteys ja luvat tiedon näyttämiseen
require_once 'inc/headers.php';
require_once 'inc/functions.php';

$input = json_decode(file_get_contents('php://input'));
$productid = filter_var($input->productID, FILTER_SANITIZE_NUMBER_INT);
$comment = filter_var($input->text, FILTER_SANITIZE_STRING);

// Laitetaan tietokantaan kommentin valuet
try {
   $db = slDB();
   $query = $db->prepare("insert into comments(comments, productID) VALUES(:comment, :productid)");
   $query->bindValue(":productid", $productid, PDO::PARAM_INT);
   $query->bindValue(":comment", $comment, PDO::PARAM_STR);
   $query->execute();
   echo header ('HTTP/1.1 200 OK');
}
// Virheilmoitus
catch (PDOException $pdoex) {
   returnError($pdoex);
}
?>