<?php
session_start();
$role = $_SESSION['role'] ?? '';
?>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.datatables.net/1.13.1/css/dataTables.bootstrap5.min.css" rel="stylesheet">

<style>
body {
    min-height: 100vh;
    background-image: url('https://4kwallpapers.com/images/wallpapers/macos-monterey-stock-black-dark-mode-layers-5k-4480x2520-5889.jpg');
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    display: flex;
    align-items: center;
    padding: 2rem;
}

.content-wrapper {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    padding: 2rem;
    margin: 0 auto;
    max-width: 1400px;
    width: 100%;
}

.return-btn {
    display: inline-block;
    background: #000;
    color: #fff;
    padding: 0.5rem 1.5rem;
    border-radius: 8px;
    text-decoration: none;
    margin-bottom: 1.5rem;
    transition: all 0.3s ease;
}

.return-btn:hover {
    background: #333;
    color: #fff;
    transform: translateX(-5px);
}

.table-container {
    background: #fff;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.table thead th {
    background: #000;
    color: #fff;
    font-weight: 500;
    border: none;
}

.table tbody tr:nth-child(even) {
    background-color: rgba(0, 0, 0, 0.02);
}

.dataTables_wrapper .dataTables_length select {
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 6px;
    padding: 0.375rem 0.75rem;
}

.dataTables_wrapper .dataTables_filter input {
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 6px;
    padding: 0.375rem 0.75rem;
}

.dataTables_wrapper .dataTables_paginate .paginate_button {
    border: none !important;
    background: transparent !important;
    color: #000 !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button.current {
    background: #000 !important;
    color: #fff !important;
}

.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
    background: #333 !important;
    color: #fff !important;
}

.materials-list {
    max-width: 300px;
    white-space: normal;
    word-wrap: break-word;
}

@media (max-width: 767px) {
    body {
        padding: 1rem;
    }
    
    .content-wrapper {
        padding: 1rem;
    }
    
    .table-container {
        overflow-x: auto;
    }
}
</style>

<div class="content-wrapper">
    <a href="../index.php" class="return-btn">
        <i class="fas fa-arrow-left me-2"></i>Return
    </a>
    
    <div class="table-container">
        <table id="requestTable" class="table table-hover">
        <thead>
    <tr>
        <th>Request Number</th>
        <th>Request Date</th>
        <th>Status</th>
        <th>Employee</th>
        <th>Provider</th>
        <th>Materials</th>
        <th>Make report</th>
    </tr>
</thead>
<tbody>
    <?php 
    include "../includes/config/conn.php";
    $db = connect();    

    $query = "
        SELECT 
            r.num AS requestNum,
            r.request_date,
            sr.name AS status_name,
            CONCAT(e.firstName, ' ', e.lastName) AS employee_name,
            GROUP_CONCAT(
                CONCAT(
                    rm.material, ': ',
                    m.name,
                    ' (Quantity: ', rm.quantity,
                    ', Amount: $', rm.amount, ')'
                ) SEPARATOR '<br>'
            ) AS materials_detail
        FROM request r
        LEFT JOIN employee e ON r.employee = e.num
        LEFT JOIN request_material rm ON r.num = rm.request
        LEFT JOIN raw_material m ON rm.material = m.code
        LEFT JOIN status_request sr ON r.status = sr.code
        GROUP BY r.num
        ORDER BY r.request_date DESC
    ";

    $result = mysqli_query($db, $query);
    
    while ($row = mysqli_fetch_assoc($result)) { ?>
        <tr>
            <td><?= htmlspecialchars($row['requestNum']) ?></td>lucia.sanchez@gmail.com
            <td><?= htmlspecialchars($row['request_date']) ?></td>
            <td><?= htmlspecialchars($row['status_name']) ?></td>
            <td><?= htmlspecialchars($row['employee_name']) ?></td>
            <td class="materials-list"><?= $row['materials_detail'] ?></td>
            <<td><a href="receptionCreate.php?requestNum=<?=$row['requestNum']?>">Report</a></td>

        </tr>
    <?php }
    mysqli_close($db);
    ?>
</tbody>

        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.1/js/dataTables.bootstrap5.min.js"></script>
<script src="https://kit.fontawesome.com/your-code.js" crossorigin="anonymous"></script>

<script>
$(document).ready(function() {
    $('#requestTable').DataTable({
        "paging": true,
        "searching": true,
        "ordering": true,
        "pageLength": 10,
        "lengthMenu": [[5, 10, 25, 50], [5, 10, 25, 50]],
        "language": {
            "lengthMenu": "Show _MENU_ entries",
            "search": "Search:",
            "paginate": {
                "first": "First",
                "last": "Last",
                "next": "Next",
                "previous": "Previous"
            },
            "info": "Showing _START_ to _END_ of _TOTAL_ entries",
            "infoEmpty": "Showing 0 to 0 of 0 entries",
            "infoFiltered": "(filtered from _MAX_ total entries)"
        },
        "columnDefs": [
            { "orderable": false, "targets": 5 },
            { "searchable": false, "targets": 5 }
        ],
        "dom": '<"row"<"col-sm-6"l><"col-sm-6"f>>rtip',
        "responsive": true
    });
    $('.dataTables_length label').find('select').removeClass('form-select');
});
</script>