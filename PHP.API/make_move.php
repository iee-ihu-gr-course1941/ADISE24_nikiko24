<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $game_id     = $_POST['game_id'] ?? null;
    $player_id   = $_POST['player_id'] ?? null;
    $tile_id     = $_POST['tile_id'] ?? null;
    $position_x  = $_POST['position_x'] ?? null;
    $position_y  = $_POST['position_y'] ?? null;

    if ($game_id && $player_id && $tile_id && $position_x !== null && $position_y !== null) {
        try {
            $stmt = $pdo->prepare("CALL MakeMove(?, ?, ?, ?, ?)");
            $stmt->execute([$game_id, $player_id, $tile_id, $position_x, $position_y]);
            echo json_encode(['message' => 'Move recorded successfully']);
        } catch (PDOException $e) {
            http_response_code(400);
            echo json_encode(['error' => $e->getMessage()]);
        }
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Missing parameters']);
    }
}
?>