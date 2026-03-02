<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

include "db.php";

$data = json_decode(file_get_contents("php://input"), true);

$email         = $data["email"];
$name          = $data["name"];
$dob           = $data["dob"];
$place         = $data["place"];
$profile_image = $data["profile_image"] ?? "";

$sql = "UPDATE users 
        SET name='$name', dob='$dob', place='$place', profile_image='$profile_image'
        WHERE email='$email'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
}
?>