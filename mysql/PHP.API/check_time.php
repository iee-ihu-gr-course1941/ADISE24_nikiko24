<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $game_id = $_GET['game_id'] ?? null;

    if ($game_id) {
        try {
            $stmt = $pdo->prepare("CALL GetRemainingTime(?)");
            $stmt->execute([$game_id]);
            $remaining_time = $stmt->fetchColumn();
            echo json_encode(['remaining_time' => $remaining_time]);
        } catch (PDOException $e) {
            http_response_code(400);
            echo json_encode(['error' => $e->getMessage()]);
        }
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Missing game_id parameter']);
    }
}
?>