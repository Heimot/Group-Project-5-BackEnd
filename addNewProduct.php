<?php
require_once 'inc/functions.php';
require_once 'inc/headers.php';

$input = json_decode(file_get_contents('php://input'));
$name = filter_var($input->name, FILTER_SANITIZE_STRING);
$price = filter_var($input->price, FILTER_SANITIZE_NUMBER_INT);
$categoryID = filter_var($input->categoryID, FILTER_SANITIZE_NUMBER_INT);
$subCategoryID = filter_var($input->subCategoryID, FILTER_SANITIZE_NUMBER_INT);
$description = filter_var($input->description, FILTER_SANITIZE_STRING);
$weight = filter_var($input->weight, FILTER_SANITIZE_NUMBER_FLOAT);
$stock = filter_var($input->stock, FILTER_SANITIZE_NUMBER_INT);

try {
    $db = slDB();
    $query = $db->prepare('insert into product(name,price,categoryID,subCategoryID,description,weight,stock) values (:name,:price,:categoryID,:subCategoryID,:description,:weight,:stock)');
    $query->bindValue(':name',$name,PDO::PARAM_STR);
    $query->bindValue(':price',$price,PDO::PARAM_INT);
    $query->bindValue(':categoryID',$categoryID,PDO::PARAM_INT);
    $query->bindValue(':subCategoryID',$subCategoryID,PDO::PARAM_INT);
    $query->bindValue(':description',$description,PDO::PARAM_STR);
    $query->bindValue(':weight',$weight,PDO::PARAM_INT);
    $query->bindValue(':stock',$stock,PDO::PARAM_INT);
    $query->execute();
    $last_id = $db->lastInsertId();

    echo header('HTTP/1.1 200 OK');
    $data = array('id' => $last_id, 'data' => "Lisäsit uuden tuotteen nimeltä: {$name}");
    echo json_encode($data);   
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
