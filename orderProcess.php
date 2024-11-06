<?php
include "includes/config/conn.php";
$conn = connect();

$descrp = $_POST['descrp'];
$employee = $_POST['employee'];
$request = $_POST['request'];
$rawMaterial = $_POST['rawMaterial'];

$insert = "INSERT INTO order (descrp,employee,request,rawMaterial) VALUES ('$descrp','$employee', '$request','$rawMaterial')";

if($conn->query($insert) === TRUE){
    echo '<script type="text/javascript"> alert("Registro Exitoso"); window.location.href="createOrder.php" </script>';
}else{
    echo '<script type="text/javascript"> alert("Error al registrar"); window.location.href="createOrder.php" </script>';
}


$conn ->close();
?>