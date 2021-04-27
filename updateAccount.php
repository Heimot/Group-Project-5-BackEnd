<?php
require_once 'inc/functions.php';
require_once 'inc/headers.php';

$id = filter_input(INPUT_POST, "id", FILTER_SANITIZE_NUMBER_INT);
$email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
$firstname = filter_input(INPUT_POST, "firstname", FILTER_SANITIZE_STRING);
$lastname = filter_input(INPUT_POST, "lastname", FILTER_SANITIZE_STRING);
$address = filter_input(INPUT_POST, "address", FILTER_SANITIZE_STRING);
$postalcode = filter_input(INPUT_POST, "postalcode", FILTER_SANITIZE_STRING);
$city = filter_input(INPUT_POST, "city", FILTER_SANITIZE_STRING);
$phone = filter_input(INPUT_POST, "phone", FILTER_SANITIZE_STRING);

try {
    $db = slDB();
    $query = $db->prepare('update customers SET firstname = :firstname, lastname = :lastname, address = :address, postalcode = :postalcode, city = :city, phone = :phone WHERE id = :id');
    $query->bindValue(':id',$id,PDO::PARAM_INT);
    $query->bindValue(':firstname',$firstname,PDO::PARAM_STR);
    $query->bindValue(':lastname',$lastname,PDO::PARAM_STR);
    $query->bindValue(':address',$address,PDO::PARAM_STR);
    $query->bindValue(':postalcode',$postalcode,PDO::PARAM_STR);
    $query->bindValue(':city',$city,PDO::PARAM_STR);
    $query->bindValue(':phone',$phone,PDO::PARAM_STR);
    $query->execute();
    echo header('HTTP/1.1 200 OK');
    echo "Päivittäminen onnistui";
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>