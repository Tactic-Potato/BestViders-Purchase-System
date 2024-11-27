<?php
include "../includes/config/conn.php";
include "../includes/config/functions.php";
$query_provider = "select num, fiscal_name from provider";
$conn = connect(); 

$num = $_REQUEST['num'];

$infoProvider=getProviderInfo($num);

if (!$infoProvider) {
    exit("Proveedor no encontrado.");
}
?>
<link rel="stylesheet" href="includes/css/forms.css">
<nav id="Return"><a href="../index.php">Return</a></nav>
<section id="formCont">
    <div id="formCard">
        <form action="providerRHProcess.php" method="POST">
            <label>Provider number</label>
            <input type="number" name="num" id="num" value="<?=$infoProvider['num']?>" readonly>
            <label>Fiscal Name of the Provider</label>
            <input type="text" name="fiscalName" id="fiscalName" value="<?=$infoProvider['fiscalName']?>" readonly>
            <input type="number" name="status" id="status" value="1">
            <div>
                <button type="submit" class="button">REHIRE</button>
            </div>
        </form>
    </div>
</section>


