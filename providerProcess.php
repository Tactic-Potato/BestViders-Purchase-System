<?php
include "includes/config/conn.php";
$conn = connect();

$num = $_POST['num'];
$fiscalName = $_POST['fiscalName'];
$email = $_POST['email'];
$numTel = $_POST['numTel'];

$insert = "INSERT INTO provider (num, fiscalName, email, numTel) VALUES ('$num','$fiscalName', '$email','$numTel')";

if($conn->query($insert) === TRUE){
    echo '<script type="text/javascript"> alert("Registro Exitoso"); window.location.href="createProvider.php" </script>';
}else{
    echo '<script type="text/javascript"> alert("Error al registrar"); window.location.href="createProvider.php" </script>';
}


$conn ->close();
?>