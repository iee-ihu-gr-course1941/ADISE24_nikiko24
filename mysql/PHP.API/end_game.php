<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $game_id = $_POST['game_id'] ?? null;
    if ($game_id) {
        try {
            // Call EndGame directly:
            $stmt = $pdo->prepare("CALL EndGame(?)");
            $stmt->execute([$game_id]);
            echo json_encode(['message' => 'Game ended successfully']);
        } catch (PDOException $e) {
            http_response_code(400);
            echo json_encode(['error' => $e->getMessage()]);
        }
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Missing game_id']);
    }
}
?>