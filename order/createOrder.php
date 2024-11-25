<?php
require '../includes/config/conn.php';

$db = connect();

$query_employee = "SELECT num, firstName FROM employee";
$employees = mysqli_query($db, $query_employee);

$query_rawMaterial = "SELECT code, name FROM raw_material";
$materials = mysqli_query($db, $query_rawMaterial);

session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $descrp = $_POST['descrp'];
    $rawMaterial = $_POST['rawMaterial'];
    $employee = $_SESSION['num'];
    $area = $_SESSION['role'];

    $insert_query = "INSERT INTO orders (description, employee, raw_material) 
                    VALUES ('$descrp', '$employee', '$rawMaterial')";

    if (mysqli_query($db, $insert_query)) {
        // Obtener el ID de la orden recién insertada
        $order_num = mysqli_insert_id($db);


        // Preparar consulta para insertar en la tabla intermedia
        $insert_query_2 = "INSERT INTO area_order (area, order_num) VALUES ('$area', '$order_num')";

        if (mysqli_query($db, $insert_query_2)) {
            echo "<script>
                    alert('Registro Exitoso');
                    window.location.href = 'createOrder.php';
                </script>";
        } else {
            echo "<script>
                    alert('Error al registrar en área-orden: " . mysqli_error($db) . "');
                    window.location.href = 'createOrder.php';
                </script>";
        }
    } else {
        echo "<script>
                alert('Error al registrar: " . mysqli_error($db) . "');
                window.location.href = 'createOrder.php';
            </script>";
    }
}
?>

<!DOCTYPE html>
<html lang="en"> 
<head>
    <link rel="stylesheet" href="../includes/css/Form3.css">
    <title>Human Resources</title>
</head>
<body>
<nav id="Return"><a href="../index.php"> Return </a></nav>
<section id="formCont">
    <div id="formCard">
        <form id="orderForm" method="POST" action="createOrder.php">
            <h2>Create an Order</h2>
            <div class="row">
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="descrp" id="descrp" placeholder="Enter order description" required></textarea>
                </div>
            </div>

            <div class="row">
                <div class="form-group">
                    <label>Raw Material</label>
                    <select name="rawMaterial" id="rawMaterial" required>
                        <option value="" disabled selected>Select raw material</option>
                        <?php while($material = mysqli_fetch_assoc($materials)): ?>
                            <option value="<?php echo $material['code']; ?>">
                                <?php echo $material['name']; ?>
                            </option>
                        <?php endwhile; ?>
                    </select>
                </div>
            </div>

            <div class="button-container">
                <button type="submit" class="button">ADD ORDER</button>
            </div>
        </form>
    </div>
</section>
</body>
</html>