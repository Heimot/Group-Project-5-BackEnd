<?php
session_start();
require_once 'inc/headers.php';
require_once 'inc/functions.php';


function getUserAccessRoleByID() {
    //$db = slDB();
   // $sql = 'select role from customers where id = '.$_SESSION['user']['id'];
    //$query = $db->query($sql);
    //$results = $query->fetchAll(PDO::FETCH_ASSOC);
    //echo header ('http1.1 200 OK');
    return $_SESSION['user'];
}


?>