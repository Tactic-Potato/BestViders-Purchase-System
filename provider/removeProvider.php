<?php
include "includes/config/conn.php";
include "includes/config/functions.php";
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
        <form action="providerRMProcess.php" method="POST">
            <input type="number" name="num" id="num" value="<?=$infoProvider['num']?>" readonly>
            <input type="text" name="fiscalName" id="fiscalName" value="<?=$infoProvider['fiscalName']?>" readonly>


            <div>
                <button type="submit" class="button">REMOVE</button>
            </div>
        </form>
    </div>
</section>

