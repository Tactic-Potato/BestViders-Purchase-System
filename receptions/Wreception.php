<body>
    <nav id="Return"><a href="../index.php"> Return </a></nav>
    <link rel="stylesheet" href="../includes/css/tablas.css">
    <section id="tableContainer">
        <div id="infRequests">
            <table>
                <tr>
                    <th>Request Number</th>
                    <th>Request Date</th>
                    <th>Status</th>
                    <th>Employee</th>
                    <th>Provider</th>
                    <th>Materials Requested</th>
                </tr>
                <?php 
                    include "../includes/config/conn.php";
                    $db = connect();
                    $query = mysqli_query($db, "
                        SELECT r.num AS requestNum, r.requestDate, r.status,
                            e.firstName AS employeeFirstName, e.lastName AS employeeLastName, 
                            p.fiscalName AS providerName,
                            GROUP_CONCAT(CONCAT(m.name, ' (Qty: ', rm.cant, ')') SEPARATOR ', ') AS materials
                        FROM reception r
                        LEFT JOIN employee e ON r.employee = e.num
                        LEFT JOIN provider p ON r.provider = p.num
                        LEFT JOIN request_material rm ON r.num = rm.request
                        LEFT JOIN raw_material m ON rm.product = m.code
                        GROUP BY r.num
                    ");

                    while ($result = mysqli_fetch_array($query)) { ?>
                        <tr>
                            <td><?= $result['requestNum'] ?></td>
                            <td><?= $result['requestDate'] ?></td>
                            <td><?= $result['status'] ?></td>
                            <td><?= $result['employeeFirstName'] . " " . $result['employeeLastName'] ?></td>
                            <td><?= $result['providerName'] ?></td>
                            <td><?= $result['materials'] ?></td>
                        </tr>
                    <?php } mysqli_close($db); ?>
            </table>
        </div>
    </section>