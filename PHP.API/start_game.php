<?php
include 'db.php';


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $created_by = $_POST['created_by'] ?? null;
    $player_ids = $_POST['player_ids'] ?? null;

    if ($created_by && $player_ids) {
        try {
            $stmt = $pdo->prepare("CALL StartGame(?, ?)");
            $stmt->execute([$created_by, $player_ids]);
            echo json_encode(['message' => 'Game started successfully']);
        } catch (PDOException $e) {
            http_response_code(400);
            echo json_encode(['error' => $e->getMessage()]);
        }
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Missing parameters (created_by, player_ids)']);
    }
}
?>