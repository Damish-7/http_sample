<?php
$host = "localhost";
$user = "root";
$password = "";   // try empty password
$database = "student_db";

$conn = mysqli_connect("localhost", "root", "root", "student_db", 8889);


if (!$conn) {
    die("Connection Failed: " . mysqli_connect_error());
}
?>
