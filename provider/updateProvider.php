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
<nav id="Return"><a href="index.php">Return</a></nav>
<section id="formCont">
    <div id="formCard">
        <form action="providerUProcess.php" method="POST">
            <input type="number" name="num" id="num" value="<?=$infoProvider['num']?>" readonly>
            <input type="text" name="fiscalName" id="fiscalName" value="<?=$infoProvider['fiscalName']?>" readonly>
            <label>Phone Number</label>
            <input type="text" name="numTel" id="numTel" placeholder="<?=$infoProvider['numTel']?>">

            <label>Email</label>
            <input type="email" name="email" id="email" placeholder ="<?=$infoProvider['email']?>">

            <div>
                <button type="submit" class="button">MODIFY</button>
            </div>
        </form>
    </div>
</section>


