<?php
require_once 'inc/functions.php';
require_once 'inc/headers.php';

$input = json_decode(file_get_contents('php://input'));
$id = filter_var($input->id, FILTER_SANITIZE_NUMBER_INT);
$firstname = filter_var($input->firstname, FILTER_SANITIZE_STRING);
$lastname = filter_var($input->lastname, FILTER_SANITIZE_STRING);
$address = filter_var($input->address, FILTER_SANITIZE_STRING);
$postalcode = filter_var($input->postalcode, FILTER_SANITIZE_STRING);
$city = filter_var($input->city, FILTER_SANITIZE_STRING);
$phone = filter_var($input->phone, FILTER_SANITIZE_STRING);

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
    $data = array('firstName' => $firstname, 'id' => $id, 'lastName' => $lastname, 'address' => $address, 'postalcode' => $postalcode, 'city' => $city, 'phone' => $phone);
    echo json_encode($data);
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>