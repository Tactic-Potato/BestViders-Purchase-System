
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

$insert = "INSERT INTO employee (num, firstName, lastName, surname, numTel, email, manager, charge, area) 
           VALUES ('$num', '$firstName', '$lastName', '$surname', '$numTel', '$email', " . ($manager === NULL ? 'NULL' : "'$manager'") . ", '$charge', '$area')"; //en caso de ser NULL comprueba y lo inserta como NULL



if ($conn->query($insert) === TRUE) {
    echo '<script type="text/javascript"> alert("Registro Exitoso"); window.location.href="createEmployee.php" </script>';
} else {
    echo '<script type="text/javascript"> alert("Error al registrar"); window.location.href="createEmployee.php" </script>';
}

$conn->close();
?>

