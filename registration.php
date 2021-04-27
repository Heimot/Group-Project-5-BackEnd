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
    $query = $db->prepare('insert into customers(email,password,firstname,lastname,address,postalcode,city,phone) values (:email,:password,:firstname,:lastname,:address,:postalcode,:city,:phone)');
    $query->bindValue(':email',$email,PDO::PARAM_STR);
    $query->bindValue(':password',password_hash($password,PASSWORD_DEFAULT),PDO::PARAM_STR);
    $query->bindValue(':firstname',$firstname,PDO::PARAM_STR);
    $query->bindValue(':lastname',$lastname,PDO::PARAM_STR);
    $query->bindValue(':address',$address,PDO::PARAM_STR);
    $query->bindValue(':postalcode',$postalcode,PDO::PARAM_STR);
    $query->bindValue(':city',$city,PDO::PARAM_STR);
    $query->bindValue(':phone',$phone,PDO::PARAM_STR);
    $query->execute();
    echo header('HTTP/1.1 200 OK');
    echo "Rekisteröityminen onnistui sähköpostilla {$email}";
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>