<?php
header('Content-Type: application/json');

$host = 'localhost';
$db_name = 'mrothol';
$db_user = 'root';
$db_password = '';

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $db_user, $db_password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Ambil parameter 'paket' dari URL query string
    $paket = isset($_GET['paket']) ? $_GET['paket'] : '';

    // Jika paket kosong, tampilkan error
    if ($paket == '') {
        echo json_encode([
            'status' => 'error',
            'message' => 'Paket tidak ditemukan'
        ]);
        exit();
    }

    // Query dengan parameter 'paket'
    $stmt = $conn->prepare("SELECT * FROM menu WHERE paket = :paket");
    $stmt->bindParam(':paket', $paket);
    $stmt->execute();

    // Ambil hasil data
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Periksa apakah ada data yang ditemukan
    if ($users) {
        echo json_encode([
            'status' => 'success',
            'data' => $users
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Data tidak ditemukan'
        ]);
    }

} catch (PDOException $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>