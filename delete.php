<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

include "db.php";



$rawData = file_get_contents("php://input");
$data = json_decode($rawData);

if ($data && isset($data->id)) {

    $id = $data->id;

    $sql = "DELETE FROM students WHERE id='$id'";

    if (mysqli_query($conn, $sql)) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => mysqli_error($conn)
        ]);
    }

} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid JSON or ID missing",
        "received" => $rawData
    ]);
}
