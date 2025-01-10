<?php
include 'db.php';

$player1_id = $_POST['player1_id'] ?? '';
$player2_id = $_POST['player2_id'] ?? '';

if ($player1_id && $player2_id) {
    try {
        $stmt = $pdo->prepare("CALL CreateGame(?, ?)");
        $stmt->execute([$player1_id, $player2_id]);
        echo json_encode(['message' => 'Game created successfully']);
    } catch (PDOException $e) {
        http_response_code(400);
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Missing player IDs']);
}
?>