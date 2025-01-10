<?php
header('Content-Type: application/json');

$host = 'localhost'; // ganti dengan host database Anda
$db_name = 'mrothol'; // nama database
$db_user = 'root'; // username database
$db_password = ''; // password database

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $db_user, $db_password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $input = json_decode(file_get_contents('php://input'),true);
    $user = $input['user'];
    $pass = $input['pass'];
    $stmt = $conn->prepare("SELECT * FROM user where nama = :user and password = :pass");
    $stmt->bindParam(':user', $user);
    $stmt->bindParam(':pass', $pass);
    $stmt->execute();

    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $permitted_chars='0123456789abcdefghijklmnopqrstuvwxyz';
    $rand=substr(str_shuffle($permitted_chars),0,15);

    if ($users)
        echo json_encode(['status'=> 'success', 'message'=>'Login Sukses', 'token'=>$rand]);
    else
        echo json_encode(['status'=> 'salah', 'message'=>'User dan Password Salah']);
    
} catch(PDOException $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>