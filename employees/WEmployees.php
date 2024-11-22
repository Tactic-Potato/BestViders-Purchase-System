<nav id="Return"><a href="../index.php"> Return </a></nav>
<section id="tableContainer">
<link rel="stylesheet" href = "../includes/css/tablas.css" />
    <div id="infEmployees">
            <table> 
                <tr>
                    <th>Employee Number</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Second Last Name</th>
                    <th>Status</th>
                    <th>Phone Number</th>
                    <th>Email</th>
                   <!--<th>Manager</th>-->
                    <th>Charge</th>
                    <th>Area</th>
                </tr>
                <?php 
                    include "../includes/config/conn.php";
                    $db = connect();
                    $query = mysqli_query($db, "SELECT e.num, e.firstName, e.lastName, e.surname, e.status, e.numTel, e.email, 
                                                /*m.firstName AS managerFirstName, m.lastName AS managerLastName,*/
                                                c.name AS chargeName, a.name AS areaName
                                                FROM employee e
                                                /*LEFT JOIN employee m ON e.manager = m.num*/
                                                LEFT JOIN charge c ON e.charge = c.code
                                                LEFT JOIN area a ON e.area = a.code");

                    while ($result = mysqli_fetch_array($query)) { ?>
                        <tr>
                            <td><?= $result['num'] ?></td>
                            <td><?= $result['firstName'] ?></td>
                            <td><?= $result['lastName'] ?></td>
                            <td><?= $result['surname'] ?></td>
                            <td><?= $result['status'] ?></td>
                            <td><?= $result['numTel'] ?></td>
                            <td><?= $result['email'] ?></td>
                            <!--<td><?= $result['managerFirstName'] . " " . $result['managerLastName'] ?></td>-->
                            <td><?= $result['chargeName'] ?></td>
                            <td><?= $result['areaName'] ?></td>
                        </tr>
                    <?php } mysqli_close($db); ?>
            </table>
    </div>
</section>
