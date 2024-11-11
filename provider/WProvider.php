<nav id="Return"><a href="../index.php"> Return </a></nav>
<section id="tableContainer">
    <link rel="stylesheet" href = "../includes/css/tablas.css" />
    <div id="infProviders">
            <table>
                <tr>
                    <th>Provider Number</th>
                    <th>Fiscal Name</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                </tr>
                <?php 
                    include "../includes/config/conn.php";
                    $db=connect();
                    $query = mysqli_query($db,  "SELECT * FROM provider");
                    while ($result = mysqli_fetch_array($query)){ ?>
                        <tr>
                            <td><?=$result['num']?></td>
                            <td><?=$result['fiscalName']?></td>
                            <td><?=$result['email']?></td>
                            <td><?=$result['numTel']?></td>
                        </tr>
                    <?php } mysqli_close($db); ?>
            </table>
    </div>
</section>
