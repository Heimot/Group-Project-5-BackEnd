<?php

require_once 'inc/headers.php';
require_once 'inc/functions.php';


$input = json_decode(file_get_contents('php://input'));
$customerid = filter_var($input->customerid, FILTER_SANITIZE_NUMBER_INT);

try {
   $db = slDB();
   $sql = "select * from orders where customerid = {$customerid}"; 
   $query = $db->query($sql);
   $results = $query->fetchAll(PDO::FETCH_ASSOC);   
   echo header ('HTTP/1.1 200 OK');
   echo json_encode($results);
}

catch (PDOException $pdoex) {
   returnError($pdoex);
}