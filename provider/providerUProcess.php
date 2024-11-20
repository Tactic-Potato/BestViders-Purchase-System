<?php
include "includes/config/conn.php";
$conn = connect();

$num = $_POST['num'];
$numTel = $_POST['numTel'];
$email = $_POST['email'];



$update = "update provider SET numTel = '$numTel', email = '$email' where num = $num";

if($conn->query($update) === TRUE){
    echo '<script type="text/javascript"> alert("Registro Exitoso"); window.location.href="createOrder.php" </script>';
}else{
    echo '<script type="text/javascript"> alert("Error al registrar"); window.location.href="createOrder.php" </script>';
}


$conn ->close();
?>