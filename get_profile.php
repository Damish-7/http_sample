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

$email = $data["email"];

$result = mysqli_query($conn, "SELECT name, dob, place, profile_image FROM users WHERE email='$email' LIMIT 1");

if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo json_encode([
        "status"        => "success",
        "name"          => $row["name"] ?? "",
        "dob"           => $row["dob"] ?? "",
        "place"         => $row["place"] ?? "",
        "profile_image" => $row["profile_image"] ?? "",
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "User not found"]);
}
?>