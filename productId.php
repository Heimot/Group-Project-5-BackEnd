<?php
require_once 'inc/functions.php';
require_once 'inc/headers.php';

$input = json_decode(file_get_contents('php://input'));
$id = filter_var($input->id, FILTER_SANITIZE_NUMBER_INT);


try {
    $db = slDB();
    $query_check = 'select id from product where id=:id';
    $query_check = $db->prepare($query_check);
    $query_check->bindParam('id', $id, PDO::PARAM_INT);
    $query_check->execute();

    $row = $query_check->fetch();
    if (!$row) { 
        echo header('HTTP/1.1 200 OK');
        echo "Success!";
    } else {         
        echo header('HTTP/1.1 200 OK');        
    }  

 
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>