<?php
header('Content-Type: application/json');

// Koneksi ke database
$host = 'localhost'; // ganti dengan host database Anda
$db_name = 'mrothol'; // nama database
$db_user = 'root'; // username database
$db_password = ''; // password database

try {
    // Koneksi database
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $db_user, $db_password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Membaca input JSON
    $input = json_decode(file_get_contents('php://input'), true);

    // Pastikan data yang dibutuhkan tersedia
    if (!isset($input['CartItems']) || !isset($input['metode'])) {
        echo json_encode(['status' => 'error', 'message' => 'Data tidak lengkap']);
        exit;
    }

    // Data dari JSON
    $menu = $input['CartItems']; // Array dari CartItems
    $metodePembayaran = $input['metode'];
    $tanggal = date("Y-m-d H:i:s");

    // Menambahkan metode pembayaran dan tanggal ke menu
    $menu[] = ["metode_pembayaran" => $metodePembayaran];
    $menu[] = ["tanggal" => $tanggal];

    // Simpan menu ke database sebagai JSON string
    $menuJson = json_encode($menu);

    // Query SQL untuk menyimpan data
    $stmt = $conn->prepare("
        INSERT INTO transaksi (data)
        VALUES (:menu)
    ");

    // Bind parameter
    $stmt->bindParam(':menu', $menuJson);

    // Eksekusi query
    $stmt->execute();

    // Mendapatkan ID terakhir yang diinsertkan
    $insertedId = $conn->lastInsertId();

    // Mengirimkan respons ke Flutter
    echo json_encode([
        'status' => 'success',
        'message' => 'Data berhasil disimpan',
        'inserted_id' => $insertedId
    ]);
} catch (PDOException $e) {
    // Respons jika terjadi error
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>
