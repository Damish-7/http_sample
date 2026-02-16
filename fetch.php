<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");




error_reporting(E_ALL);
ini_set('display_errors', 1);

include 'db.php';

$result = mysqli_query($conn, "SELECT * FROM students");

$data = [];

while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode($data);
?>
