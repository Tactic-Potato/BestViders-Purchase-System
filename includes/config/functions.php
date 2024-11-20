<?php

function getProviderInfo($num){
	$query = "SELECT num,fiscalName,numTel,email from provider where num= ".$num;
	$db = connect();
    if(!$resultado = mysqli_query($db,$query)){
		exit(mysqli_error($db));
    }
	$infoProvider = null;
    
    if (mysqli_num_rows($resultado) > 0) {
        $row = mysqli_fetch_assoc($resultado);
        $infoProvider = array(
            'num' => $row['num'],
            'fiscalName' => $row['fiscalName'],
            'numTel' => $row['numTel'],
            'email' => $row['email']
        );
    }
	return $infoProvider;	
}






?>