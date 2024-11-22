<?php
include "includes/config/conn.php";
$conn = connect();

$num = $_POST['num'];




$update = "update provider SET status = '$status' where num = $num";

if($conn->query($update) === TRUE){
    echo '<script type="text/javascript"> alert("Registro Exitoso"); window.location.href="createOrder.php" </script>';
}else{
    echo '<script type="text/javascript"> alert("Error al registrar"); window.location.href="createOrder.php" </script>';
}


$conn ->close();
?>