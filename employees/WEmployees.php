<nav id="Return"><a href="../index.php"> Return </a></nav>
<section id="tableContainer">
<link rel="stylesheet" href = "../includes/css/tablas.css" />
    <div id="infEmployees">
            <table> 
                <tr>
                    <th>Employee Number</th>
                    <th>Employee's Name</th>
                    <th>Status</th>
                    <th>Phone Number</th>
                    <th>Email</th>
                    <th>Charge</th>
                    <th>Area</th>
                </tr>
                <?php 
                    include "../includes/config/conn.php";
                    $db = connect();
                    $query = mysqli_query($db, "SELECT * FROM vw_employee"); 

                    while ($result = mysqli_fetch_array($query)) { ?>
                        <tr>
                            <td><?= $result['num'] ?></td>
                            <td><?= $result['name'] ?></td>
                            <td><?= $result['status'] == 1 ? 'Activo' : 'Inactivo' ?></td>
                            <td><?= $result['numTel'] ?></td>
                            <td><?= $result['email'] ?></td>
                            <td><?= $result['charge'] ?></td>
                            <td><?= $result['area'] ?></td>
                        </tr>
                    <?php } mysqli_close($db); ?>
            </table>
    </div>
</section>

<!-- <td><?= $result['managerFirstName'] . " " . $result['managerLastName'] ?></td>
<td><?= $result['chargeName'] ?></td> -->
