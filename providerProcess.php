<?php
include "includes/config/conn.php"
$conn = conn();

$num = $_POST['num'];
$fiscalName = $_POST['fiscalName'];
$email = $_POST['email'];
$numTel = $_POST['numTel'];

$insert = "INSERT INTO provider (num, fiscalName, email, numTel) VALUES ('$num','$fiscalName', '$email','$numTel')";

if()



$conn ->close();
?>