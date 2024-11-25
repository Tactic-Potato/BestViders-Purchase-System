<?php
require '../includes/config/conn.php';

$db = connect();

$query_materials = "SELECT code, name FROM raw_material";
$materials = mysqli_query($db, $query_materials);

session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $descrp = $_POST['descrp'];
    $selectedMaterialsAndQuantities = $_POST['materials_and_quantities']; // Recibimos el JSON
    $employee = $_SESSION['num'];
    $area = $_SESSION['role'];

    // Inserta la orden principal
    $insert_query = "INSERT INTO orders (description, employee, area) VALUES ('$descrp', '$employee', '$area')";
    if (mysqli_query($db, $insert_query)) {
        $order_num = mysqli_insert_id($db); // ID de la orden recién creada

        // Decodificar el JSON para obtener el array de materiales y cantidades
        $materials_and_quantities = json_decode($selectedMaterialsAndQuantities, true);

        // Inserta los materiales seleccionados y sus cantidades
        foreach ($materials_and_quantities as $item) {
            $materialCode = $item['material']; // Código del material
            $quantity = $item['quantity']; // Cantidad

            // Verifica que la cantidad sea un número válido y mayor que 0
            if (is_numeric($quantity) && $quantity > 0) {
                // Inserta el material y su cantidad en la tabla order_material
                $insert_material_query = "INSERT INTO order_material (order_num, material, quantity) 
                                          VALUES ('$order_num', '$materialCode', '$quantity')";
                if (!mysqli_query($db, $insert_material_query)) {
                    echo "<script>
                            alert('Error al registrar material: " . mysqli_error($db) . "');
                            window.location.href = 'createOrder.php';
                          </script>";
                    exit;
                }
            } else {
                echo "<script>
                        alert('Cantidad inválida para el material $materialCode');
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
<style>
body {
    min-height: 100vh;
    background-image: url('https://4kwallpapers.com/images/wallpapers/macos-monterey-stock-black-dark-mode-layers-5k-4480x2520-5889.jpg');
    background-size: cover;
    background-position: center;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    margin: 0;
}

.container {
    width: 100%;
    max-width: 800px;
    margin: 0;
    padding: 0;
}

.card {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    border: none;
}

#Return {
    padding: 20px 20px 0;
}

#Return a {
    background: #1a1a1a;
    color: #fff;
    padding: 10px 20px;
    border-radius: 8px;
    text-decoration: none;
    display: inline-block;
    transition: background-color 0.3s ease;
}

#Return a:hover {
    background: #333;
    color: #fff;
}

.card-body {
    padding: 2rem;
}

h2 {
    margin-bottom: 1.5rem;
    color: #1a1a1a;
}

.form-label {
    color: #1a1a1a;
    font-weight: 600;
    margin-bottom: 0.5rem;
}

.form-control {
    border: 2px solid #eee;
    border-radius: 8px;
    padding: 0.75rem;
    transition: border-color 0.3s ease;
}

.form-control:focus {
    border-color: #2c2c2c;
    box-shadow: none;
}

/* Raw Materials Grid Layout */
.mb-3 > div {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1rem;
    margin-top: 1rem;
}

.form-check {
    background: rgba(0, 0, 0, 0.02);
    padding: 1rem;
    border-radius: 8px;
    margin: 0;
    transition: background-color 0.3s ease;
}

.form-check:hover {
    background: rgba(0, 0, 0, 0.04);
}

.btn-primary {
    background: #1a1a1a;
    border: none;
    padding: 12px;
    font-weight: 600;
    border-radius: 8px;
    width: 100%;
    color: white;
    transition: background-color 0.3s ease;
}

.btn-primary:hover {
    background: #4b4848;
}

/* Modal Styling */
.modal-content {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    border: none;
}

.modal-header {
    border-bottom: none;
    padding: 1.5rem;
}

.modal-footer {
    border-top: none;
    padding: 1.5rem;
}

.modal-body {
    padding: 1.5rem;
}

.btn-secondary {
    background: #6c757d;
    border: none;
    padding: 12px 24px;
    font-weight: 600;
    border-radius: 8px;
    color: white;
    transition: background-color 0.3s ease;
}

.btn-secondary:hover {
    background: #5a6268;
}

/* Responsive Design */
@media (max-width: 768px) {
    .mb-3 > div {
        grid-template-columns: repeat(2, 1fr);
    }
    
    .card-body {
        padding: 1.5rem;
    }
}

@media (max-width: 576px) {
    .mb-3 > div {
        grid-template-columns: 1fr;
    }
    
    .container {
        padding: 0 15px;
    }
}
</style>
<body>
    <div class="card">
    <nav id="Return"><a href="../index.php">Return</a></nav>
    <section id="formCont" class="container mt-5">
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
                                    class="form-check-input material-checkbox" 
                                    type="checkbox" 
                                    name="selectedMaterials[]" 
                                    id="material-<?php echo $material['code']; ?>" 
                                    value="<?php echo $material['code']; ?>"
                                    data-bs-toggle="modal" 
                                    data-bs-target="#quantityModal" 
                                    data-material="<?php echo $material['code']; ?>"
                                    data-material-name="<?php echo $material['name']; ?>" />
                                <label class="form-check-label" for="material-<?php echo $material['code']; ?>">
                                    <?php echo $material['name']; ?>
                                </label>
                            </div>
                        <?php endwhile; ?>
                    </div>
                </div>

                <!-- Hidden field to hold materials and quantities as JSON -->
                <input type="hidden" name="materials_and_quantities" id="hiddenMaterialsAndQuantities" />

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
                <input type="hidden" id="modalMaterialCode" />
                <input type="hidden" id="modalMaterialName" />
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
        const hiddenMaterialsInput = document.getElementById('hiddenMaterialsAndQuantities');
        const modalMaterialCodeInput = document.getElementById('modalMaterialCode');

        let selectedMaterialCode = null;

        // Setup the modal with the correct material
        document.querySelectorAll('.material-checkbox').forEach(item => {
            item.addEventListener('click', function() {
                if (item.checked) {
                    selectedMaterialCode = item.getAttribute('data-material');
                    modalMaterialCodeInput.value = selectedMaterialCode;
                }
            });
        });

        saveQuantityBtn.addEventListener('click', function () {
            const quantity = modalQuantityInput.value;

            if (quantity && quantity > 0) {
                // Crear un array con los materiales y sus cantidades
                const currentMaterials = JSON.parse(hiddenMaterialsInput.value || '[]');
                
                // Agregar el material seleccionado con su cantidad al array
                currentMaterials.push({
                    material: selectedMaterialCode,
                    quantity: quantity
                });

                // Actualizar el campo oculto con el JSON de materiales y cantidades
                hiddenMaterialsInput.value = JSON.stringify(currentMaterials);

                // Limpiar el modal y cerrarlo
                modalQuantityInput.value = '';
                const modal = bootstrap.Modal.getInstance(document.getElementById('quantityModal'));
                modal.hide();
            } else {
                alert('Please enter a valid quantity.');
            }
        });
    });
</script>