<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$trainid = $_POST['trainid'];


$sqlquantity = "SELECT * FROM TICKET WHERE EMAIL = '$email'";

$resultq = $conn->query($sqlquantity);
if ($resultq->num_rows > 0) {
    $quantity = 0;
    while ($row = $resultq ->fetch_assoc()){
        $quantity = $row["TQUANTITY"] + $quantity;
    }
}

$sqlsearch = "SELECT * FROM TICKET WHERE EMAIL = '$email' AND TRAINID= '$trainid'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $prquantity = $row["TQUANTITY"];
    }
    $prquantity = $prquantity + 1;
    $sqlinsert = "UPDATE TICKET SET TQUANTITY = '$prquantity' WHERE TRAINID = '$trainid' AND EMAIL = '$email'";
    
}else{
    $sqlinsert = "INSERT INTO TICKET(EMAIL,TRAINID,TQUANTITY) VALUES ('$email','$trainid','1')";
}

if ($conn->query($sqlinsert) === true)
{
    $quantity = $quantity +1;
    echo "success,".$quantity;
}
else
{
    echo "failed";
}

?>