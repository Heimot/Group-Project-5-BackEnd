<?php
require_once 'inc/headers.php';
require_once 'inc/functions.php';

$input = json_decode(file_get_contents('php://input'));
$email = filter_var($input->email, FILTER_SANITIZE_STRING);
$password = filter_var($input->password, FILTER_SANITIZE_STRING);

try {
    $db = slDB();

    $query = 'select firstname from customers where email=:email and password =:password';
    $query = $db->prepare($query);
    $query->bindParam('email', $email, PDO::PARAM_STR);
    $query->bindValue('password', md5($password), PDO::PARAM_STR);
    $query->execute();
    $results = $query->fetchAll(PDO::FETCH_ASSOC);
    echo header('HTTP/1.1 200 OK');
    echo json_encode($results);
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>