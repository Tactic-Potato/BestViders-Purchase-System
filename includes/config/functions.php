<?php

function getProviderInfo($num){
	$query = "SELECT num,fiscal_name,numTel,email from provider where num= ".$num;
	$db = connect();
    if(!$resultado = mysqli_query($db,$query)){
		exit(mysqli_error($db));
    }
	$infoProvider = null;
    
    if (mysqli_num_rows($resultado) > 0) {
        $row = mysqli_fetch_assoc($resultado);
        $infoProvider = array(
            'num' => $row['num'],
            'fiscalName' => $row['fiscal_name'],
            'numTel' => $row['numTel'],
            'email' => $row['email']
        );
    }
	return $infoProvider;	
}






?>