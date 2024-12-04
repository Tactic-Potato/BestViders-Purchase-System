<?php
include "../includes/config/conn.php";

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $conn = connect();
    
    $num = $_GET['num'] ?? null;
    $status = $_GET['status'] ?? null;

    if (!$num || !$status) {
        echo "Error: Missing 'num' or 'status' parameters.";
        exit;
    }

    $num = intval($num);
    $status = intval($status);

    $remove = "CALL sp_RemoveEmployee(?, ?)";
    $stmt = $conn->prepare($remove);

    if ($stmt) {
        $stmt->bind_param("ii", $num, $status);
        if ($stmt->execute()) {
            echo "Employee removed successfully.";
        } else {
            echo "Error during execution: " . $stmt->error;
        }
        $stmt->close();
    } else {
        echo "Error preparing statement: " . $conn->error;
    }

    $conn->close();
} else {
    echo "Invalid request method.";
}
?>
