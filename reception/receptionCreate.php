<?php
    include "../includes/config/conn.php";
    include "../includes/config/functions.php";
    $query_provider = "select num, fiscal_name from provider";
    $conn = connect(); 
    session_start();
    $requestNum = $_REQUEST['requestNum'];

    $infoRequest = getRequestInfo($requestNum);

    if (!$infoRequest) {
        exit("Request not found.");
    }
    $currentDate = date('Y-m-d');
    if (isset($_SESSION['num'])) {
        $employee = $_SESSION['num'];
    } else {
        // Si no hay valor en la sesión, manejarlo adecuadamente (mostrar un mensaje o redirigir)
        $employee = 'Empleado no encontrado'; // O puedes redirigir o dar un mensaje de error
    }
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion de Proveedores y Compras Industriales</title>
    <style>
        /* Estilos generales */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fc;
            color: #333;
            padding: 20px;
        }

        h2, h3 {
            color: #2d3e50;
        }

        a {
            text-decoration: none;
            color: #007bff;
        }

        /* Contenedor principal */
        .card-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .card-container h2 {
            text-align: center;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .card-container .return-btn {
            display: inline-block;
            margin-bottom: 20px;
            font-size: 16px;
            color: #007bff;
            text-decoration: none;
        }

        .card-container .return-btn i {
            font-size: 18px;
        }

        /* Estilo de los formularios */
        form {
            margin-top: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        .form-group p,
        .form-group input {
            font-size: 16px;
        }

        /* Estilo de los inputs */
        input.form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
        }

        input.form-control:focus {
            border-color: #007bff;
            outline: none;
        }

        /* Botones */
        .button-container {
            text-align: center;
        }

        .button {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .button:hover {
            background-color: #218838;
        }

        /* Estilo de la tarjeta de detalles */
        .form-card {
            margin-top: 20px;
        }

        .form-card .form-group {
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #e0e0e0;
        }

        .form-card .form-group p {
            font-weight: normal;
            color: #555;
        }

        /* Estilos responsivos */
        @media screen and (max-width: 768px) {
            .card-container {
                padding: 15px;
            }

            .form-group input {
                font-size: 14px;
            }

            .button {
                font-size: 14px;
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>
    <div class="card-container">
        <a href="../index.php" class="return-btn">
            <i class="fas fa-arrow-left me-2"></i>Return
        </a>
        <div class="card-container">
            <form action="receptionProcess.php" method="POST">
                <h2 class="mb-4">Create Report</h2>
                <h3>Info Request</h3>
                <div class="form-group">
                    <label><strong>Request Number:</strong></label>
                    <p><?=$infoRequest['requestNum']?></p>
                </div>

                <div class="form-group">
                    <label for="requestedDate"><strong>Requested Date:</strong></label>
                    <p><?=$infoRequest['requestDate']?></p>
                </div>
                <div class="form-group">
                    <label for="numTel"><strong>Employee:</strong></label>
                    <p><?=$infoRequest['employee']?></p>
                </div>
                <div class="form-group">
                    <label for="provider"><strong>Provider:</strong></label>
                    <p><?=$infoRequest['provider']?></p>
                </div>
                <div class="form-group">
                    <label for="material_details"><strong>Requested Materials:</strong></label>
                    <p><?=$infoRequest['materials_detail']?></p>
                </div>
                <div class="form-group">
                    <label for="status"><strong>Status of the Request:</strong></label>
                    <p><?=$infoRequest['status']?></p>
                </div>
            </form>

            <div class="form-card">
                <form action="receptionProcess.php" method="POST">
                    <h2 class="mb-4">Create Report</h2>

                    <div class="form-group">
                        <label for="receptionDate">Reception Date</label>
                        <input type="text" name="receptionDate" id="receptionDate" class="form-control" value="<?=$currentDate?>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="receptionDate">Observations</label>
                        <textarea name="observations" id="observations" class="form-control"  placeholder="Write the observations about the delivery"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="missings">How many materials are missing?</label>
                        <input type="text" name="missings" id="missings" class="form-control">
                    </div>
     
                        <input type="text" name="employee" id="employee" class="form-control" value="<?=$employee?>" hidden readonly>
                    

                    <div class="form-group">
                        <label for="provider">Provider</label>
                        <input type="text" name="provider" id="provider" class="form-control" value="<?=$infoRequest['provider']?>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="material_details">Requested Material</label>
                        <input type="text" name="material_details" id="material_details" class="form-control" value="<?=$infoRequest['requestNum']?>"  readonly >
                    </div>  

                    <div class="button-container mt-4">
                        <button type="submit" class="button">Make Report</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
