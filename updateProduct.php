<?php
require_once 'inc/functions.php';
require_once 'inc/headers.php';


$input = json_decode(file_get_contents('php://input'));
$id = filter_var($input->id, FILTER_SANITIZE_NUMBER_INT);
$name = filter_var($input->name, FILTER_SANITIZE_STRING);
$price = filter_var($input->price, FILTER_SANITIZE_NUMBER_INT);
$categoryID = filter_var($input->categoryID, FILTER_SANITIZE_NUMBER_INT);
$subcategoryID = filter_var($input->subcategoryID, FILTER_SANITIZE_NUMBER_INT);
$description = filter_var($input->description, FILTER_SANITIZE_STRING);
$weight = filter_var($input->weight, FILTER_SANITIZE_NUMBER_INT);
$stock = filter_var($input->stock, FILTER_SANITIZE_NUMBER_INT);

try {
    $db = slDB();
    $query = $db->prepare('update product SET name = :name, price = :price, categoryID = :categoryID, subcategoryID = :subcategoryID, description = :description, weight = :weight, stock = :stock WHERE id = :id');
    $query->bindValue(':id',$id,PDO::PARAM_INT);
    $query->bindValue(':name',$name,PDO::PARAM_STR);
    $query->bindValue(':price',$price,PDO::PARAM_INT);
    $query->bindValue(':categoryID',$categoryID,PDO::PARAM_INT);
    $query->bindValue(':subcategoryID',$subcategoryID,PDO::PARAM_INT);
    $query->bindValue(':description',$description,PDO::PARAM_STR);
    $query->bindValue(':weight',$weight,PDO::PARAM_INT);
    $query->bindValue(':stock',$stock,PDO::PARAM_INT);
    $query->execute();
    echo header('HTTP/1.1 200 OK');
    $data = array( 'id' => $id, 'name' => $name, 'price' => $price, 'categoryID' => $categoryID, 'subcategoryID' => $subcategoryID, 'description' => $description, 'weight' => $weight, 'stock' => $stock);
    echo json_encode($data);
}
catch (PDOException $pdoex) {
    returnError($pdoex);
}
?>