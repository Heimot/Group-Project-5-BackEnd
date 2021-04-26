<?php
// Haetaan yhteys ja luvat tiedon näyttämiseen
require_once 'inc/headers.php';
require_once 'inc/functions.php';

$id = filter_var($_GET['id'], FILTER_SANITIZE_NUMBER_INT);
$img = filter_var($_GET['img'], FILTER_SANITIZE_NUMBER_INT);

if($img > 0) {
   $method = " group by product.id";
} else {
   $method = "";
}

// Noudetaan tietokannasta halutut tiedot
try {
   $db = slDB();
   $sql = 'select product.id, product.name, product.price, product.description, product.weight, product.stock, productpictures.picture from product left join productpictures on product.id = productpictures.productId WHERE product.id='. $id;
   $query = $db->query($sql);
   $results = $query->fetchAll(PDO::FETCH_ASSOC);
   echo header ('http1.1 200 OK');
   echo json_encode($results);
}
// Virheilmoitus
catch (PDOException $pdoex) {
   returnError($pdoex);
}
