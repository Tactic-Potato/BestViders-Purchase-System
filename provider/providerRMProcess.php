<?php
include "includes/config/conn.php";
$conn = connect();

$num = $_POST['num'];
$status = $_POST['status'];



$remove = "update provider SET status = '0' where num = $num";

if($conn->query($remove) === TRUE){
    echo '<script type="text/javascript"> alert("Removed succesfully"); window.location.href="WProvider.php" </script>';
}else{
    echo '<script type="text/javascript"> alert("Error removing that provider"); window.location.href="WProvider.php" </script>';
}


$conn ->close();
?>