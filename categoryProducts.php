<?php
// Haetaan yhteys ja luvat tiedon näyttämiseen
require_once 'inc/headers.php';
require_once 'inc/functions.php';

$name = filter_var($_GET['name'], FILTER_SANITIZE_STRING);
$type = filter_var($_GET['type'], FILTER_SANITIZE_NUMBER_INT);

if ($type < 2) {
   $method = "inner join subcategory on `subCategoryID` = subcategory.id where subcategory.name = '" . $name . "'";
} else {
   $method = "where category.name = '" . $name . "'";
}

// Noudetaan tietokannasta halutut tiedot
try {
   $db = slDB();

   $sql = "select product.name, product.price, product.id, product.stock, product.description from `product` inner join category on `categoryID` = category.id  " . $method . "";

   $query = $db->query($sql);

   $results = $query->fetchAll(PDO::FETCH_ASSOC);
   echo header('http1.1 200 OK');
   echo json_encode($results);
}
// Virheilmoitus
catch (PDOException $pdoex) {
   returnError($pdoex);
}
