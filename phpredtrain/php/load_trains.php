<?php
error_reporting(0);
include_once ("dbconnect.php");
$origin = $_POST['origin'];
$destination = $_POST['destination'];


if (isset($origin)){
   $sql = "SELECT * FROM TRAIN WHERE ORIGIN LIKE  '%$origin%'";
}

if (isset($destination)){
   $sql = "SELECT * FROM TRAIN WHERE DESTINATION LIKE  '%$destination%'";
}

  
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["trains"] = array();
    while ($row = $result->fetch_assoc())
    {
        $trainlist = array();
        $trainlist["plate_number"] = $row["PLATE_NUMBER"];
        $trainlist["origin"] = $row["ORIGIN"];
        $trainlist["destination"] = $row["DESTINATION"];
        $trainlist["depart_time"] = $row["DEPART_TIME"];
        $trainlist["arrive_time"] = $row["ARRIVE_TIME"];
        $trainlist["type"] = $row["TYPE"];
        $trainlist["price"] = $row["PRICE"];
        array_push($response["trains"], $trainlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>