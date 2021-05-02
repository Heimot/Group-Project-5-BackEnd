<?php

require_once 'inc/headers.php';
require_once 'inc/functions.php';

$input = json_decode(file_get_contents('php://input'));
$id = filter_var($input->id,FILTER_SANITIZE_NUMBER_INT);
$oldpassword = filter_var($input->oldpassword,FILTER_SANITIZE_STRING);
$newpassword = filter_var($input->newpassword,FILTER_SANITIZE_STRING);

try {
    $db = slDB();

    $query = 'select firstname from customers where id=:id and password =:oldpassword';
    $query = $db->prepare($query);
    $query->bindParam('id', $id, PDO::PARAM_STR);
    $query->bindValue('oldpassword', password_hash($oldpassword,PASSWORD_DEFAULT), PDO::PARAM_STR);
    $query->execute();

    $row = $query->fetch();
    if (!$row) { 
        echo header('HTTP/1.1 200 OK');
        echo "Wrong password!";
    } else {   
        $query2 = $db->prepare('update customers set password = :newpassword where id = :id ');
        $query2->bindValue(':id', $id, PDO::PARAM_STR);
        $query2->bindValue(':newpassword', password_hash($newpassword,PASSWORD_DEFAULT), PDO::PARAM_STR);
        $query2->execute();
        

        echo header('HTTP/1.1 200 OK');        
        echo "Success! Password was changed";
    }  
}
    catch (PDOException $pdoex) {
        returnError($pdoex);
     }
?>