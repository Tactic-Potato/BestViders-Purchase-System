
<?php
include "includes/config/conn.php";
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

// comprueba que el campo este vacio y lo transforma en NULL
$manager = empty($_POST['manager']) ? NULL : $_POST['manager'];

$insert = "INSERT INTO EMPLOYEE (num, firstName, lastName, surname, numTel, email, manager, charge, area) 
           VALUES ('$num', '$firstName', '$lastName', '$surname', '$numTel', '$email', " . ($manager === NULL ? 'NULL' : "'$manager'") . ", '$charge', '$area')"; //en caso de ser NULL comprueba y lo inserta como NULL



if($conn->query($insert) === TRUE){
    echo '<script type="text/javascript">
            if (confirm("Registro Exitoso. ¿Desea registrar de nuevo?")) {
                window.location.href = "createEmployee.php"; // Redirige a la página de registro
            } else {
                window.location.href = "index.php"; // Redirige al menú principal
            }
          </script>';
} else {
    echo '<script type="text/javascript">
            alert("Error al registrar");
            window.location.href = "createEmployee.php";
          </script>';
}

$conn->close();
?>

 