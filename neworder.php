<?php
require_once 'inc/functions.php';
require_once 'inc/headers.php';

$input = json_decode(file_get_contents('php://input'));

//$registered = false;

$customerid = filter_var($input->customerid, FILTER_SANITIZE_NUMBER_INT);
$price = filter_var($input->price, FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION | FILTER_FLAG_ALLOW_THOUSAND);
$shipping = filter_var($input->shipping, FILTER_SANITIZE_STRING);
$email = filter_var($input->email, FILTER_SANITIZE_STRING);
$firstname = filter_var($input->firstname, FILTER_SANITIZE_STRING);
$lastname = filter_var($input->lastname, FILTER_SANITIZE_STRING);
$address = filter_var($input->address, FILTER_SANITIZE_STRING);
$postalcode = filter_var($input->postalcode, FILTER_SANITIZE_STRING);
$city = filter_var($input->city, FILTER_SANITIZE_STRING);
$phone = filter_var($input->phone, FILTER_SANITIZE_STRING);
$orderComment = filter_var($input->orderComment, FILTER_SANITIZE_STRING);
$cart = $input->cart;

try {
    $db = slDB();
    $query = $db->prepare('insert into orders(customerid,price,shipping,email,firstname,lastname,address,postalcode,city,phone,orderComment) values (:customerid,:price,:shipping,:email,:firstname,:lastname,:address,:postalcode,:city,:phone,:orderComment)');
    /*if ($registered) {
        $query->bindValue(':customerid',$customerid,PDO::PARAM_STR);
    } else {
        $query->bindValue(':customerid',null,PDO::PARAM_STR);
    }*/
    
    $query->bindValue(':customerid',$customerid,PDO::PARAM_INT);
    $query->bindValue(':price',$price,PDO::PARAM_STR);
    $query->bindValue(':shipping',$shipping,PDO::PARAM_STR);    
    $query->bindValue(':email',$email,PDO::PARAM_STR);
    $query->bindValue(':firstname',$firstname,PDO::PARAM_STR);
    $query->bindValue(':lastname',$lastname,PDO::PARAM_STR);
    $query->bindValue(':address',$address,PDO::PARAM_STR);
    $query->bindValue(':postalcode',$postalcode,PDO::PARAM_STR);
    $query->bindValue(':city',$city,PDO::PARAM_STR);
    $query->bindValue(':phone',$phone,PDO::PARAM_STR);
    $query->bindValue(':orderComment',$orderComment,PDO::PARAM_STR);
    $query->execute();

    $lastinsertid = $db->lastInsertId();

    foreach($cart as $product) {
        $sql = "insert into orderdetails (`orderid`, `productid`, `amount`) values(" . $lastinsertid . "," . $product->id . "," . $product->amount . ")";
        $query = $db->query($sql);
        $db->lastInsertId();
    }

    echo header('HTTP/1.1 200 OK');
    echo json_encode($lastinsertid); 
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>