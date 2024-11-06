<?php
include "includes/config/conn.php";
$conn = connect();

$num = $_POST['num'];
$fiscalName = $_POST['fiscalName'];
$email = $_POST['email'];
$numTel = $_POST['numTel'];

$insert = "INSERT INTO PROVIDER (num, fiscalName, email, numTel) VALUES ('$num','$fiscalName', '$email','$numTel')";

if($conn->query($insert) === TRUE){
    echo '<script type="text/javascript">
            if (confirm("Registro Exitoso. ¿Desea registrar de nuevo?")) {
                window.location.href = "createProvider.php"; // Redirige a la página de registro
            } else {
                window.location.href = "index.php"; // Redirige al menú principal
            }
          </script>';
} else {
    echo '<script type="text/javascript">
            alert("Error al registrar");
            window.location.href = "createProvider.php";
          </script>';
}

$conn->close();
?>
