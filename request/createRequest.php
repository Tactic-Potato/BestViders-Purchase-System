<?php
require '../includes/config/conn.php';
$db = connect();
// Consulta de proveedores
$provider_query = "SELECT num, fiscal_name FROM provider";
$providers = mysqli_query($db, $provider_query);

// Consulta de órdenes
$order_query = "SELECT num, description FROM orders";
$orders = mysqli_query($db, $order_query);

// Consulta de materiales
$material_query = "SELECT code, name, price FROM raw_material ";
$materials = mysqli_query($db, $material_query);

session_start();
$employee = $_SESSION['num'];

// Consulta de empleados para asignación
$employee_query = "SELECT num, firstName FROM employee WHERE num = $employee";
$employee_result = mysqli_query($db, $employee_query);
$employee_data = mysqli_fetch_assoc($employee_result);
$employee_name = $employee_data['firstName'];  // Nombre del empleado

// Procesar el formulario
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $provider = $_POST['provider'];
    $order = $_POST['order'];  // Obtener el valor del campo order

    // Comprobar que se haya seleccionado una orden
    if (!empty($order)) {
        // Si se seleccionó una orden, realiza la consulta para obtener los materiales relacionados con esa orden
        $materialCode_query = "SELECT rawMaterial FROM vw_order WHERE num = $order";
        $materialCode = mysqli_query($db, $materialCode_query);
        if (!$materialCode) {
            echo "Error en la consulta de materiales: " . mysqli_error($db);
        }
    } else {
        // Si no se seleccionó una orden, maneja el caso adecuadamente
        echo "Error: No order selected.";
    }

    // Insertar la solicitud en la tabla REQUEST
    $insert_query = "INSERT INTO request (status, employee, provider, `order`, requestDate)
                     VALUES ('In Progress', '$employee', '$provider', NULLIF('$order', ''), CURDATE())";

    if (mysqli_query($db, $insert_query)) {
        $request_id = mysqli_insert_id($db);

        // Insertar los materiales de la solicitud en la tabla REQUEST_MATERIAL
        foreach ($_POST['materials'] as $material) {
            $product = $material['product'];
            $cant = $material['cant'];
            $amount = $material['amount'];

            $material_insert = "INSERT INTO request_material (request, product, cant, amount)
                                VALUES ('$request_id', '$product', '$cant', '$amount')";
            mysqli_query($db, $material_insert);
        }

        echo "<script>
                alert('Request created successfully.');
                if (confirm('Would you like to create another request?')) {
                    document.getElementById('requestForm').reset();
                } else {
                    window.location.href = 'index.php';
                }
              </script>";
    } else {
        echo "Error: " . mysqli_error($db);
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="../includes/css/Form.css">
    <title>Create Request</title>
</head>
<body>
<nav id="Return"><a href="../index.php">Return</a></nav>
<section id="formCont">
    <div id="formCard">
        <form id="requestForm" method="POST">
            <h2>Employee Information</h2>
            <div class="row">
                <div class="form-group">
                    <label>Employee</label>
                    <!-- Mostrar nombre del empleado en un campo readonly -->
                    <input type="text" name="employee" id="employee" value="<?=$employee_name?>" readonly>
                </div>
            </div>

            <h2>Request Information</h2>
            <div class="row">
                <div class="form-group">
                    <label>Order</label>
                    <select name="order" id="order">
                        <option value="">None</option>
                        <?php while($order = mysqli_fetch_assoc($orders)): ?>
                            <option value="<?php echo $order['num']; ?>">
                                <?php echo $order['description']; ?>
                            </option>
                        <?php endwhile; ?>
                    </select>
                </div>
                <div class="form-group">
                    <label>Provider</label>
                    <select name="provider" id="provider" required>
                        <option value="" disabled selected>Select a provider</option>
                        <?php while($provider = mysqli_fetch_assoc($providers)): ?>
                            <option value="<?php echo $provider['num']; ?>">
                                <?php echo $provider['fiscal_name']; ?>
                            </option>
                        <?php endwhile; ?>
                    </select>
                </div>
            </div>

            <h2>Request Materials</h2>
            <div id="materialContainer">
                <div class="row">
                    <div class="form-group">
                        <label>Material</label>
                        <select name="materials[0][product]" required>
                            <option value="" disabled selected>Select a material</option>
                            <?php while($material = mysqli_fetch_assoc($materials)): ?>
                                <option value="<?php echo $material['code']; ?>" data-price="<?php echo $material['price']; ?>">
                                    <?php echo $material['name']; ?>
                                </option>
                            <?php endwhile; ?>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Quantity</label>
                        <input type="number" name="materials[0][cant]" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Amount</label>
                        <input type="text" name="materials[0][amount]" readonly>
                    </div>
                </div>
            </div>

            <div class="button-container">
                <button type="submit" class="button">Create Request</button>
            </div>
        </form>
    </div>
</section>

<script>
    let materialIndex = 1;

    function addMaterial() {
        const container = document.getElementById('materialContainer');
        const newRow = document.createElement('div');
        newRow.classList.add('row');
        newRow.innerHTML = `
            <div class="form-group">
                <label>Material</label>
                <select name="materials[${materialIndex}][product]" required>
                    <option value="" disabled selected>Select a material</option>
                    <?php 
                    $materials = mysqli_query($db, $material_query);
                    while($material = mysqli_fetch_assoc($materials)): ?>
                        <option value="<?php echo $material['code']; ?>" data-price="<?php echo $material['price']; ?>">
                            <?php echo $material['name']; ?>
                        </option>
                    <?php endwhile; ?>
                </select>
            </div>
            <div class="form-group">
                <label>Quantity</label>
                <input type="number" name="materials[${materialIndex}][cant]" min="1" required>
            </div>
            <div class="form-group">
                <label>Amount</label>
                <input type="text" name="materials[${materialIndex}][amount]" readonly>
            </div>
        `;
        container.appendChild(newRow);
        materialIndex++;
    }

    document.getElementById('requestForm').addEventListener('change', function(event) {
        if (event.target.matches('select[name*="[product]"], input[name*="[cant]"]')) {
            const row = event.target.closest('.row');
            const productSelect = row.querySelector('select[name*="[product]"]');
            const quantityInput = row.querySelector('input[name*="[cant]"]');
            const amountInput = row.querySelector('input[name*="[amount]"]');
            const price = parseFloat(productSelect
.options[productSelect.selectedIndex].getAttribute('data-price') || 0);
            const quantity = parseInt(quantityInput.value || 0);
            amountInput.value = (price * quantity).toFixed(2);
        }
    });
</script>
