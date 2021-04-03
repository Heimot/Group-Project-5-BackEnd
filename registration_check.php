<?php
require_once 'inc/functions.php';
require_once 'inc/headers.php';

$input = json_decode(file_get_contents('php://input'));
$email = filter_var($input->email, FILTER_SANITIZE_STRING);
$password = filter_var($input->password, FILTER_SANITIZE_STRING);
$firstname = filter_var($input->firstname, FILTER_SANITIZE_STRING);
$lastname = filter_var($input->lastname, FILTER_SANITIZE_STRING);
$address = filter_var($input->address, FILTER_SANITIZE_STRING);
$postalcode = filter_var($input->postalcode, FILTER_SANITIZE_STRING);
$city = filter_var($input->city, FILTER_SANITIZE_STRING);
$phone = filter_var($input->phone, FILTER_SANITIZE_STRING);

try {
    $db = slDB();
    $query_check = 'select email from customers where email=:email';
    $query_check = $db->prepare($query_check);
    $query_check->bindParam('email', $email, PDO::PARAM_STR);
    $query_check->execute();
    $res = $db->query($query_check);
    $count = $res->fetchColumn();
    if ($count > 0) {
        echo header('HTTP/1.1 200 OK');
        echo "Already registered!";
    } else {         
        echo header('HTTP/1.1 200 OK');
        echo "Success!";
    }     
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>