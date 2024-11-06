<?php
include "../../includes/config/conn.php";
$conn = connect();

$num = $_POST['num'];
$firstName = $_POST['firstName'];
$lastName = $_POST['lastName'];
$surname = $_POST['surname'];
$numTel = $_POST['numTel'];
$email = $_POST['email'];
$manager = $_POST['manager'];
$charge = $_POST['charge'];
$area = $_POST['area'];

$insert = "INSERT INTO employee (num, firstName, lastName, surname,numTel ,email, manager, charge, area) VALUES ('$num','$firstlName', '$lastName','$surname','$numTel', '$email', '$manager','$charge','$area')";


if($conn->query($insert) === TRUE){
    echo '<script type="text/javascript"> alert("Registro Exitoso"); window.location.href="createEmployee.php" </script>';
}else{
    echo '<script type="text/javascript"> alert("Error al registrar"); window.location.href="createEmployee.php" </script>';
}

$conn ->close();
?>