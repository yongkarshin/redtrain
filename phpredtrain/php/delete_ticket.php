<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$trainid = $_POST['trainid'];

     $sqldelete = "DELETE FROM TICKET WHERE EMAIL = '$email' AND TRAINID='$trainid'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>