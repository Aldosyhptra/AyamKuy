<?php
header('Content-Type: application/json');

$host = 'localhost';
$db_name = 'mrothol';
$db_user = 'root';
$db_password = '';

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $db_user, $db_password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Ambil parameter 'id' dari URL query string
    $id = isset($_GET['id']) ? $_GET['id'] : '';

    // Jika id kosong, tampilkan error
    if ($id == '') {
        echo json_encode([
            'status' => 'error',
            'message' => 'id transaksi tidak ditemukan'
        ]);
        exit();
    }

    // Query dengan parameter 'id'
    $stmt = $conn->prepare("SELECT * FROM transaksi WHERE id = :id");
    $stmt->bindParam(':id', $id);
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