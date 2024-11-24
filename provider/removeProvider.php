<?php
include "../includes/config/conn.php";
include "../includes/config/functions.php";
$query_provider = "select num, fiscalName from provider";
$conn = connect(); 

$num = $_REQUEST['num'];

$infoProvider=getProviderInfo($num);

if (!$infoProvider) {
    exit("Proveedor no encontrado.");
}
?>


<link rel="stylesheet" href="includes/css/forms.css">
<nav id="Return"><a href="WProvider.php">Return</a></nav>
<section id="formCont">
    <div id="formCard">
        <form id = "removeProviderForm" method="POST">
            <input type="number" name="num" id="num" value="<?=$infoProvider['num']?>" readonly>
            <input type="text" name="fiscalName" id="fiscalName" value="<?=$infoProvider['fiscalName']?>" readonly>
            <textarea name="motive" id="motive" placeholder="Write the reason to remove the provider" required></textarea>
            <input type="hidden" name="status" value="0">

            <div>
                <button type="button" class="button" data-bs-toggle="modal" data-bs-target="#removeProviderModal">REMOVE</button>
            </div>
        </form>
    </div>
</section>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">


<div class="modal fade" id="removeProviderModal" tabindex="-1" aria-labelledby="removeProviderModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="removeProviderModalLabel">Confirmation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to remove the provider?<br>
                <input type="num" name="num" id="num" value="<?=$infoProvider['num']?>" readonly>
                <input type="text" name="fiscalName" id="fiscalName" value="<?=$infoProvider['fiscalName']?>" readonly>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmRemove">Yes, remove it!</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>

document.getElementById('confirmRemove').addEventListener('click', function () {
    const form = document.getElementById('removeProviderForm');
    
    // Crea un objeto FormData con los datos del formulario
    const formData = new FormData(form);

    const motive = document.getElementById('motive').value;
    if (motive.trim() === '') {
        alert('Please provide a reason for removal.');
        return; // No continúa si el campo "reason" está vacío
    }

    // Enviar el formulario mediante fetch
    fetch('providerRMProcess.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        alert('Provider removed successfully!');
        // Opcional: Redirige o actualiza la página
        window.location.href = 'WProvider.php';
    })
    .catch(error => {
        console.error('Error:', error);
        alert('There was an issue removing the provider.');
    });

    // Cierra el modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('removeProviderModal'));
    modal.hide();
});

</script>
<script>
// Habilitar o deshabilitar el botón "REMOVE" basado en el contenido del campo "reason"
document.getElementById('motive').addEventListener('input', function() {
    const motive = document.getElementById('motive').value;
    const removeButton = document.querySelector('.button');
    if (motive.trim() === '') {
        removeButton.disabled = true;  // Deshabilita el botón si el campo está vacío
    } else {
        removeButton.disabled = false; // Habilita el botón si el campo tiene texto
    }
});

// Inicializa el estado del botón "REMOVE" al cargar la página
document.addEventListener('DOMContentLoaded', function() {
    const motive = document.getElementById('motive').value;
    const removeButton = document.querySelector('.button');
    if (motive.trim() === '') {
        removeButton.disabled = true;  // Deshabilita el botón si el campo está vacío
    }
});
</script> 
