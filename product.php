<?php
// Haetaan yhteys ja luvat tiedon näyttämiseen
require_once 'inc/headers.php';
require_once 'inc/functions.php';


// Noudetaan tietokannasta halutut tiedot
try {
      $db = slDB();
      $sql = 'select product.id, product.name, product.price, product.description, product.weight, product.stock, productpictures.picture, productpictures.productId from product left join productpictures on product.id = productpictures.productId GROUP BY product.id';
      $query = $db->query($sql);
      $results = $query->fetchAll(PDO::FETCH_ASSOC);
      echo header('http1.1 200 OK');
      echo json_encode($results);
}
// Virheilmoitus
catch (PDOException $pdoex) {
   returnError($pdoex);
}
