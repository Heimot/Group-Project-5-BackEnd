<?php
session_start();
require_once 'inc/headers.php';
require_once 'inc/functions.php';

$email = filter_input(INPUT_POST,'email',FILTER_SANITIZE_STRING);
$password = filter_input(INPUT_POST,'password',FILTER_SANITIZE_STRING);

$sql = "select * from customers where email='$email'";

try {
  $db = SlDb();
  $query = $db->query($sql);
  $user = $query->fetch(PDO::FETCH_OBJ);
  if ($user) {
    $passwordFromDb = $user->password;
    if (password_verify($password,$passwordFromDb)) {
        http_response_code(200);
      $data = array(
        'id' => $user->id,
        'firstName' => $user->firstName,
        'lastName' => $user->lastName,
        'address' => $user->address,
        'postalcode' => $user->postalcode,
        'city' => $user->city,
        'phone' => $user->phone,
        'email' => $user->email
      );
      $_SESSION['user'] = $user;
    } else {
        http_response_code(401);
      $data = array('message' => "Unsuccessfull login.");
    }
  } else {
    http_response_code(401);
    $data = array('message' => "Unsuccessfull login.");
  }

  echo json_encode($data);
} catch (PDOException $pdoex) {
  returnError($pdoex); 
}