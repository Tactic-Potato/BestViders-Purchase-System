<?php
include "../includes/config/conn.php";
$conn = connect();

$num = $_POST['num'];  
$reason = $_POST['reason'];  
$status = $_POST['status'];  



if (empty($reason)) {
    echo '<script type="text/javascript"> alert("Reason is required."); window.location.href="WProvider.php" </script>';
    exit();
}

    $remove = "UPDATE provider SET status = '$status', reason = '$reason' WHERE num = $num";


    if ($conn->query($remove) === TRUE) {
        echo '<script type="text/javascript"> alert("Provider removed successfully"); window.location.href="WProvider.php" </script>';
    } else {
        echo '<script type="text/javascript"> alert("Error removing provider: ' . $conn->error . '"); window.location.href="WProvider.php" </script>';
    }


$conn->close();
?>
