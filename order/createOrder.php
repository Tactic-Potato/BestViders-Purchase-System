<?php
require '../includes/config/conn.php';

$db = connect();

$query_materials = "SELECT code, name FROM raw_material";
$materials = mysqli_query($db, $query_materials);

session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $descrp = $_POST['descrp'];
    $selectedMaterials = $_POST['selectedMaterials']; // Materiales seleccionados (array)
    $quantity = $_POST['quantity']; // Cantidad ingresada
    $employee = $_SESSION['num'];
    $area = $_SESSION['role'];

    // Inserta la orden principal
    $insert_query = "INSERT INTO orders (description, employee) VALUES ('$descrp', '$employee')";
    if (mysqli_query($db, $insert_query)) {
        $order_num = mysqli_insert_id($db); // ID de la orden recién creada

        // Inserta los materiales seleccionados y sus cantidades
        foreach ($selectedMaterials as $materialCode) {
            $insert_material_query = "INSERT INTO order_material (order_num, material, quantity) 
                                      VALUES ('$order_num', '$materialCode', '$quantity')";
            if (!mysqli_query($db, $insert_material_query)) {
                echo "<script>
                        alert('Error al registrar material: " . mysqli_error($db) . "');
                        window.location.href = 'createOrder.php';
                      </script>";
                exit;
            }
        }

        // Inserta en la tabla área-orden
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
                alert('Error al registrar la orden: " . mysqli_error($db) . "');
                window.location.href = 'createOrder.php';
              </script>";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Create an Order</title>
</head>
<body>
<nav id="Return"><a href="../index.php">Return</a></nav>
<section id="formCont" class="container mt-5">
    <div class="card">
        <div class="card-body">
            <form id="orderForm" method="POST" action="createOrder.php">
                <h2>Create an Order</h2>
                <div class="mb-3">
                    <label for="descrp" class="form-label">Description</label>
                    <textarea class="form-control" name="descrp" id="descrp" placeholder="Enter order description" required></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Raw Materials</label>
                    <div>
                        <?php while($material = mysqli_fetch_assoc($materials)): ?>
                            <div class="form-check">
                                <input 
                                    class="form-check-input" 
                                    type="checkbox" 
                                    name="selectedMaterials[]" 
                                    id="material-<?php echo $material['code']; ?>" 
                                    value="<?php echo $material['code']; ?>" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#quantityModal" />
                                <label class="form-check-label" for="material-<?php echo $material['code']; ?>">
                                    <?php echo $material['name']; ?>
                                </label>
                            </div>
                        <?php endwhile; ?>
                    </div>
                </div>

                <input type="hidden" name="quantity" id="hiddenQuantity" />

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary">ADD ORDER</button>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- Modal -->
<div class="modal fade" id="quantityModal" tabindex="-1" aria-labelledby="quantityModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="quantityModalLabel">Enter Quantity</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <label for="modalQuantity" class="form-label">Quantity</label>
                <input type="number" class="form-control" id="modalQuantity" placeholder="Enter quantity" min="1" required />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="saveQuantity">Save</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const saveQuantityBtn = document.getElementById('saveQuantity');
        const modalQuantityInput = document.getElementById('modalQuantity');
        const hiddenQuantityInput = document.getElementById('hiddenQuantity');

        saveQuantityBtn.addEventListener('click', function () {
            const quantity = modalQuantityInput.value;

            if (quantity && quantity > 0) {
                hiddenQuantityInput.value = quantity;
                modalQuantityInput.value = '';
                const modal = bootstrap.Modal.getInstance(document.getElementById('quantityModal'));
                modal.hide();
            } else {
                alert('Please enter a valid quantity.');
            }
        });
    });
</script>
</body>
</html>
