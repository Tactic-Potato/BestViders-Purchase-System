<?php
include "includes/config/conn.php";
$conn = connect();

$num = $_POST['num'];
$fiscalName = $_POST['fiscalName'];
$email = $_POST['email'];
$numTel = $_POST['numTel'];

$insert = "INSERT INTO PROVIDER (num, fiscalName, email, numTel) VALUES ('$num','$fiscalName', '$email','$numTel')";

if($conn->query($insert) === TRUE){
    echo '
        <link rel="stylesheet" href="includes/css/forms.css">
        <script type="text/javascript">
            document.addEventListener("DOMContentLoaded", function() {
                document.getElementById("customModal").style.display = "block";
            });
        </script>
        
        <!-- Modal HTML -->
        <div id="customModal" class="modal">
            <div class="modal-content">
                <p>Registro Exitoso. ¿Desea registrar de nuevo?</p>
                <button onclick="window.location.href=\'createProvider.php\'" class="modal-button">Sí</button>
                <button onclick="window.location.href=\'index.php\'" class="modal-button">No</button>
            </div>
        </div>
    ';
} else {
    echo '<script type="text/javascript">
            alert("Error al registrar");
            window.location.href = "createProvider.php";
          </script>';
}

$conn->close();
?>
