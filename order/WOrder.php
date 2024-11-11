<nav id="Return"><a href="../../index.php"> Return </a></nav>
<section id="tableContainer">
<div id="infOrders">
    <link rel="stylesheet" href = "../includes/css/tablas.css" />
    <table>
        <tr>
            <th>Order Number</th>
            <th>Description</th>
            <th>Status</th>
            <th>Employee</th>
            <th>Raw Material</th>
        </tr>
        <?php 
            include "../includes/config/conn.php";
            $db = connect();
            $query = mysqli_query($db, "SELECT o.num, o.descrp, o.status,
                                            e.firstName AS employeeFirstName, e.lastName AS employeeLastName, 
                                            rm.name AS rawMaterialName
                                        FROM `order` o
                                        LEFT JOIN employee e ON o.employee = e.num
                                        LEFT JOIN raw_material rm ON o.rawMaterial = rm.code");

            while ($result = mysqli_fetch_array($query)) { ?>
                <tr>
                    <td><?= $result['num'] ?></td>
                    <td><?= $result['descrp'] ?></td>
                    <td><?= $result['status'] ?></td>
                    <td><?= $result['employeeFirstName'] . " " . $result['employeeLastName'] ?></td>
                    <td><?= $result['rawMaterialName'] ?></td>
                </tr>
            <?php } mysqli_close($db); ?>
    </table>
</div>
</section>
</body>
</html>