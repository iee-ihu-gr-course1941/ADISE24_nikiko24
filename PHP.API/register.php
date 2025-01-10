<?php
include 'db.php';

$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

if ($username && $password) {
    try {
        $stmt = $pdo->prepare("CALL RegisterUser(?, ?)");
        $stmt->execute([$username, $password]);
        echo json_encode(['message' => 'User registered successfully']);
    } catch (PDOException $e) {
        http_response_code(400);
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Missing username or password']);
}
?>