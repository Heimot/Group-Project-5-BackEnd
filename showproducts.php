<?php

require_once 'inc/headers.php';
require_once 'inc/functions.php';

try {
   $db = slDB();
   $sql = "select id,name,price,categoryID,subCategoryID,description,weight,stock from product"; 
   $query = $db->query($sql);
   $results = $query->fetchAll(PDO::FETCH_ASSOC);   
   echo header ('HTTP/1.1 200 OK');
   echo json_encode($results);
}

catch (PDOException $pdoex) {
   returnError($pdoex);
}

?>