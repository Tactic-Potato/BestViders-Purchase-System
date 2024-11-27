<?php
require '../includes/config/conn.php';
$db = connect();
session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $order_num = $_POST['order_num'];
    $estimated_date = $_POST['estimated_date'];
    $provider = $_POST['provider'];
    $materials_and_quantities = json_decode($_POST['materials_and_quantities'], true);
    $employee = $_SESSION['num'];
    $query_area = "SELECT area FROM orders WHERE num = ?";
    $stmt_area = $db->prepare($query_area);
    $stmt_area->bind_param("i", $order_num);
    $stmt_area->execute();
    $area_result = $stmt_area->get_result();
    $area_code = $area_result->fetch_assoc()['area'];
    $total_amount = 0;
    foreach ($materials_and_quantities as $item) {
        $query_price = "SELECT price FROM raw_material WHERE code = ?";
        $stmt_price = $db->prepare($query_price);
        $stmt_price->bind_param("s", $item['material']);
        $stmt_price->execute();
        $result_price = $stmt_price->get_result();
        $price = $result_price->fetch_assoc()['price'];
        $total_amount += $price * $item['quantity'];
    }
    $total_with_tax = $total_amount * 1.16;
    $query_budget = "SELECT budgetRemain 
                    FROM budget 
                    WHERE area = ? 
                    AND budgetMonth = MONTH(?) 
                    AND budgetYear = YEAR(?)";
    
    $stmt_budget = $db->prepare($query_budget);
    $stmt_budget->bind_param("sss", $area_code, $estimated_date, $estimated_date);
    $stmt_budget->execute();
    $budget_result = $stmt_budget->get_result();
    
    if ($budget_row = $budget_result->fetch_assoc()) {
        $budget_remain = $budget_row['budgetRemain'];
        
        if ($budget_remain < $total_with_tax) {
            echo "<script>
                alert('Insufficient budget. Available: $" . number_format($budget_remain, 2) . 
                    ", Required: $" . number_format($total_with_tax, 2) . "');
                window.location.href = 'createRequest.php';
            </script>";
            exit;
        }
    } else {
        echo "<script>
            alert('No budget found for the selected period. Please contact your administrator.');
            window.location.href = 'createRequest.php';
        </script>";
        exit;
    }
    $db->begin_transaction();
    try {
        $query_request = "INSERT INTO request (order_num, estimated_date, employee, provider) 
                            VALUES (?, ?, ?, ?)";
        $stmt_request = $db->prepare($query_request);
        $stmt_request->bind_param("isii", $order_num, $estimated_date, $employee, $provider);
        
        if (!$stmt_request->execute()) {
            throw new Exception("Error creating request: " . $stmt_request->error);
        }
        
        $request_num = $stmt_request->insert_id;
        $query_material = "INSERT INTO request_material (request, material, quantity) VALUES (?, ?, ?)";
        $stmt_material = $db->prepare($query_material);

        foreach ($materials_and_quantities as $item) {
            $stmt_material->bind_param("isi", $request_num, $item['material'], $item['quantity']);
            if (!$stmt_material->execute()) {
                throw new Exception("Error adding material: " . $stmt_material->error);
            }
        }
        $db->commit();
        echo "<script>alert('Request created successfully'); window.location.href = 'createRequest.php';</script>";
        
    } catch (Exception $e) {
        $db->rollback();
        echo "<script>alert('" . $e->getMessage() . "'); window.location.href = 'createRequest.php';</script>";
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
                <form id="requestForm" method="POST" action="createRequest.php">
                    <h2>Create a Request</h2>
                    <div class="mb-3">
                        <label for="order_num" class="form-label">Select Order</label>
                        <select class="form-select" name="order_num" id="order_num" required>
                            <?php
                            $query_orders = "SELECT num FROM orders WHERE status = 'APRV'";
                            $orders = mysqli_query($db, $query_orders);
                            while ($order = mysqli_fetch_assoc($orders)) {
                                echo "<option value='{$order['num']}'>Order #{$order['num']}</option>";
                            }
                            ?>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="estimated_date" class="form-label">Estimated Date</label>
                        <input type="date" class="form-control" name="estimated_date" id="estimated_date" required 
                                min="<?php echo date('Y-m-01', strtotime($budget_period['budget_year'] . '-' . $budget_period['budget_month'] . '-01')); ?>"
                                max="<?php echo date('Y-m-t', strtotime($budget_period['budget_year'] . '-' . $budget_period['budget_month'] . '-01')); ?>" />
                    </div>
                    <div class="mb-3">
                        <label for="provider" class="form-label">Select Provider</label>
                        <select class="form-select" name="provider" id="provider" required>
                            <option value="">Select a provider</option>
                            <?php
                            $query_providers = "SELECT num, fiscal_name FROM provider WHERE status = TRUE";
                            $providers = mysqli_query($db, $query_providers);
                            while ($provider = mysqli_fetch_assoc($providers)) {
                                echo "<option value='{$provider['num']}'>{$provider['fiscal_name']}</option>";
                            }
                            ?>
                        </select>
                    </div>

                    <!-- Materias primas disponibles -->
                    <div id="materialsSection" class="mb-3 d-none">
                        <label class="form-label">Raw Materials</label>
                        <div id="materialsList"></div>
                    </div>

                    <!-- Campo oculto para materiales y cantidades -->
                    <input type="hidden" name="materials_and_quantities" id="hiddenMaterialsAndQuantities" value="[]" />

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">Create Request</button>
                    </div>
                </form>
            </div>
        </section>
    </div>

    <!-- Modal for quantity input -->
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
            const providerSelect = document.getElementById('provider');
            const materialsSection = document.getElementById('materialsSection');
            const materialsList = document.getElementById('materialsList');
            const hiddenMaterialsInput = document.getElementById('hiddenMaterialsAndQuantities');
            let selectedMaterials = [];
            providerSelect.addEventListener('change', function () {
                const providerId = providerSelect.value;
                if (providerId) {
                    fetch(`getMaterials.php?provider=${providerId}`)
                        .then(response => response.json())
                        .then(data => {
                            materialsList.innerHTML = '';
                            data.forEach(material => {
                                const materialCheckbox = `
                                    <div class="form-check">
                                        <input 
                                            class="form-check-input material-checkbox" 
                                            type="checkbox" 
                                            data-material="${material.code}" 
                                            id="material-${material.code}" />
                                        <label class="form-check-label" for="material-${material.code}">
                                            ${material.name}
                                        </label>
                                    </div>`;
                                materialsList.insertAdjacentHTML('beforeend', materialCheckbox);
                            });
                            materialsSection.classList.remove('d-none');
                            const checkboxes = materialsList.querySelectorAll('.material-checkbox');
                            checkboxes.forEach(checkbox => {
                                const materialCode = checkbox.dataset.material;
                                const existingMaterial = selectedMaterials.find(m => m.material === materialCode);
                                if (existingMaterial) {
                                    checkbox.checked = true;
                                }
                                
                                checkbox.addEventListener('click', function(e) {
                                    if (this.checked) {
                                        document.getElementById('modalMaterialCode').value = materialCode;
                                        document.getElementById('modalQuantity').value = '';
                                        const modal = new bootstrap.Modal(document.getElementById('quantityModal'));
                                        modal.show();
                                    } else {
                                        selectedMaterials = selectedMaterials.filter(m => m.material !== materialCode);
                                        hiddenMaterialsInput.value = JSON.stringify(selectedMaterials);
                                    }
                                });
                            });
                        });
                } else {
                    materialsSection.classList.add('d-none');
                    materialsList.innerHTML = '';
                    selectedMaterials = [];
                    hiddenMaterialsInput.value = JSON.stringify(selectedMaterials);
                }
            });
            const saveQuantityBtn = document.getElementById('saveQuantity');
            saveQuantityBtn.addEventListener('click', function () {
                const quantity = document.getElementById('modalQuantity').value;
                const materialCode = document.getElementById('modalMaterialCode').value;

                if (quantity && quantity > 0) {
                    const existingIndex = selectedMaterials.findIndex(m => m.material === materialCode);
                    if (existingIndex !== -1) {
                        selectedMaterials[existingIndex].quantity = parseInt(quantity);
                    } else {
                        selectedMaterials.push({
                            material: materialCode,
                            quantity: parseInt(quantity)
                        });
                    }
                    
                    hiddenMaterialsInput.value = JSON.stringify(selectedMaterials);
                    const modal = bootstrap.Modal.getInstance(document.getElementById('quantityModal'));
                    modal.hide();
                } else {
                    alert('Please enter a valid quantity.');
                }
            });
            const quantityModal = document.getElementById('quantityModal');
            quantityModal.addEventListener('hidden.bs.modal', function () {
                const materialCode = document.getElementById('modalMaterialCode').value;
                const existingMaterial = selectedMaterials.find(m => m.material === materialCode);
                if (!existingMaterial) {
                    const checkbox = document.getElementById(`material-${materialCode}`);
                    if (checkbox) checkbox.checked = false;
                }
            });
        });
    </script>
</body>
</html>