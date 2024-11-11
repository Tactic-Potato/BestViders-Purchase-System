<?php
if (!isset($_SESSION['num'])) {
    header("Location: login.php");
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href = "includes/css/style.css">
    <link rel="stylesheet" href = "includes/css/menu.css">
    <title>Index</title>
</head>
    <section id="header">
        <input id="btnlogout"type="button" value="Log out">    
        <h1>BestViders</h1>
            <?php
        switch ($_SESSION['role']) {
            case 'RH':
                include "menus/rh_menu.php";
                break;
            case 'PR':
                include "menus/pur_menu.php";
                break;
            case 'ST':
                include "menus/st_menu.php";
                break;
            default:
                include "includes/home.php";
                break;
        }
        ?>
    </section>
<body>