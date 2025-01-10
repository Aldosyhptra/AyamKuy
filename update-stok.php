<?php
header('Content-Type: application/json');

// Database configuration
$host = 'localhost';
$db_name = 'mrothol';
$db_user = 'root';
$db_password = '';

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $db_user, $db_password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Ambil data JSON dari body request
        $data = json_decode(file_get_contents("php://input"), true);

        if (isset($data['CartItems']) && is_array($data['CartItems']) && !empty($data['CartItems'])) {
            foreach ($data['CartItems'] as $item) {
                if (isset($item['nama']) && isset($item['jumlah'])) {
                    $nama = $item['nama'];
                    $jumlah = (int)$item['jumlah']; // pastikan jumlah adalah integer

                    // Query untuk mendapatkan stok berdasarkan nama
                    $stmt = $conn->prepare("SELECT jumlah FROM stok WHERE nama = :nama");
                    $stmt->bindParam(':nama', $nama);
                    $stmt->execute();

                    $existingItem = $stmt->fetch(PDO::FETCH_ASSOC);

                    if ($existingItem) {
                        $newJumlah = $existingItem['jumlah'] + $jumlah;
                        $updateStmt = $conn->prepare("UPDATE stok SET jumlah = :jumlah WHERE nama = :nama");
                        $updateStmt->bindParam(':jumlah', $newJumlah);
                        $updateStmt->bindParam(':nama', $nama);
                        $updateStmt->execute();
                    } else {
                        $insertStmt = $conn->prepare("INSERT INTO stok (nama, jumlah) VALUES (:nama, :jumlah)");
                        $insertStmt->bindParam(':nama', $nama);
                        $insertStmt->bindParam(':jumlah', $jumlah);
                        $insertStmt->execute();
                    }
                }
            }

            echo json_encode(['status' => 'success', 'message' => 'Jumlah stok berhasil diperbarui']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Data yang dikirim tidak valid']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Metode yang digunakan bukan POST']);
    }

} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
