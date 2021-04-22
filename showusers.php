<?php

require_once 'inc/headers.php';
require_once 'inc/functions.php';

try {
   $db = slDB();
   $sql = "select id, email, firstname, lastname, address, postalcode, city, phone from customers"; 
   $query = $db->query($sql);
   $results = $query->fetchAll(PDO::FETCH_ASSOC);   
   echo header ('HTTP/1.1 200 OK');
   echo json_encode($results);
}

catch (PDOException $pdoex) {
   returnError($pdoex);
}

?>