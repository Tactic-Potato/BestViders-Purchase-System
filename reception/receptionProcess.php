<?php
include "../includes/config/conn.php";
$conn = connect();


$receptionDate = $_POST['receptionDate'];
$observations = $_POST['observations'];
$missings = $_POST['missings'];
$employee = $_POST['employee'];
$requestNum = $_POST['requestNum'];



$insert = "insert into reception  (num,receptionDate,observations,missings,employee,request) values '$receptionDate', '$observations', '$missings', '$employee', '$requestNum'" ;

if($conn->query($insert) === TRUE){
    echo '<script type="text/javascript"> alert("Updated Succesfully"); window.location.href="WProvider.php" </script>';
}else{
    echo '<script type="text/javascript"> alert("Error Updating the provider"); window.location.href="WProvider.php" </script>';
}


$conn ->close();
?>