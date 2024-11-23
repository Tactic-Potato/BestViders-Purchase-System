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
<nav id="Return"><a href="index.php">Return</a></nav>
<section id="formCont">
    <div id="formCard">
        <form id = "removeProviderForm" method="POST">
            <input type="number" name="num" id="num" value="<?=$infoProvider['num']?>" readonly>
            <input type="text" name="fiscalName" id="fiscalName" value="<?=$infoProvider['fiscalName']?>" readonly>
            <textarea name="reason" id="reason" placeholder="Write the reason to remove the provider" required></textarea>

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

    // Enviar el formulario mediante fetch
    fetch('providerRMProcess.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        alert('Provider removed successfully!');
        // Opcional: Redirige o actualiza la página
        window.location.href = 'index.php';
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
