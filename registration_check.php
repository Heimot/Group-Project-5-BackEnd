<?php
require_once 'inc/functions.php';
require_once 'inc/headers.php';

$input = json_decode(file_get_contents('php://input'));
$email = filter_var($input->email, FILTER_SANITIZE_STRING);


try {
    $db = slDB();
    $query_check = 'select email from customers where email=:email';
    $query_check = $db->prepare($query_check);
    $query_check->bindParam('email', $email, PDO::PARAM_STR);
    $query_check->execute();

    $row = $query_check->fetch();
    if (!$row) { 
        echo header('HTTP/1.1 200 OK');
        echo "Success!";
    } else {         
        echo header('HTTP/1.1 200 OK');        
        echo "Already registered!";
    }  

    /* $res = $db->query($query_check);
    $count = $res->fetchColumn();
    if ($count > 0) {
        echo header('HTTP/1.1 200 OK');
        echo "Already registered!";
    } else {         
        echo header('HTTP/1.1 200 OK');
        echo "Success!";
    }    */  
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>