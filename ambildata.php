<?php

// Konfigurasi koneksi database
$host = 'localhost';
$db_name = 'mrothol';
$db_user = 'root';
$db_password = '';

try {
    // Membuat koneksi ke database
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $db_user, $db_password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Query untuk mengambil data dari tabel user
    $stmt = $conn->prepare("SELECT * FROM user");
    $stmt->execute();

    // Ambil hasil query
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Kirim respons JSON
    echo json_encode([
        'status' => 'success',
        'data' => $users
    ]);
} catch (PDOException $e) {
    // Tangani error dan kirim respons JSON
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>