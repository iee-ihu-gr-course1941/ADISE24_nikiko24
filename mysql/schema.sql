-- --------------------------------------------------------
-- QWIRKLE GAME SCHEMA (COHERENT VERSION)
-- --------------------------------------------------------

DROP DATABASE IF EXISTS `qwirkle_game`;
CREATE DATABASE `qwirkle_game`;
USE `qwirkle_game`;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Table: users
-- --------------------------------------------------------
CREATE TABLE `users` (
  `user_id` INT(11) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table: games
-- --------------------------------------------------------
CREATE TABLE `games` (
  `game_id` INT(11) NOT NULL AUTO_INCREMENT,
  `created_by` INT(11) NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `ended_at` DATETIME DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `start_time` DATETIME DEFAULT NULL,
  `time_limit` INT(11) DEFAULT 1200,
  PRIMARY KEY (`game_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `games_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table: scores
-- --------------------------------------------------------
CREATE TABLE `scores` (
  `score_id` INT(11) NOT NULL AUTO_INCREMENT,
  `game_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `score` INT(11) DEFAULT 0,
  PRIMARY KEY (`score_id`),
  KEY `game_id` (`game_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `scores_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`),
  CONSTRAINT `scores_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table: game_log
-- --------------------------------------------------------
CREATE TABLE `game_log` (
  `log_id` INT(11) NOT NULL AUTO_INCREMENT,
  `game_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `action` VARCHAR(255) NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `game_id` (`game_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `game_log_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`),
  CONSTRAINT `game_log_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table: tiles
-- --------------------------------------------------------
CREATE TABLE `tiles` (
  `tile_id` INT(11) NOT NULL AUTO_INCREMENT,
  `color` ENUM('red','blue','green','yellow','orange','purple') NOT NULL,
  `shape` ENUM('circle','square','diamond','star','cross','clover') NOT NULL,
  PRIMARY KEY (`tile_id`),
  UNIQUE KEY `color` (`color`,`shape`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Populate tiles (36 unique combos)
INSERT INTO `tiles` (`tile_id`, `color`, `shape`) VALUES
(1, 'red',    'circle'),
(2, 'blue',   'circle'),
(3, 'green',  'circle'),
(4, 'yellow', 'circle'),
(5, 'orange', 'circle'),
(6, 'purple', 'circle'),
(7, 'red',    'square'),
(8, 'blue',   'square'),
(9, 'green',  'square'),
(10, 'yellow','square'),
(11, 'orange','square'),
(12, 'purple','square'),
(13, 'red',   'diamond'),
(14, 'blue',  'diamond'),
(15, 'green', 'diamond'),
(16, 'yellow','diamond'),
(17, 'orange','diamond'),
(18, 'purple','diamond'),
(19, 'red',   'star'),
(20, 'blue',  'star'),
(21, 'green', 'star'),
(22, 'yellow','star'),
(23, 'orange','star'),
(24, 'purple','star'),
(25, 'red',   'cross'),
(26, 'blue',  'cross'),
(27, 'green', 'cross'),
(28, 'yellow','cross'),
(29, 'orange','cross'),
(30, 'purple','cross'),
(31, 'red',   'clover'),
(32, 'blue',  'clover'),
(33, 'green', 'clover'),
(34, 'yellow','clover'),
(35, 'orange','clover'),
(36, 'purple','clover');

-- --------------------------------------------------------
-- Table: tile_bag
-- --------------------------------------------------------
CREATE TABLE `tile_bag` (
  `bag_id` INT(11) NOT NULL AUTO_INCREMENT,
  `game_id` INT(11) NOT NULL,
  `tile_id` INT(11) NOT NULL,
  `quantity` INT(11) NOT NULL,
  PRIMARY KEY (`bag_id`),
  KEY `game_id` (`game_id`),
  KEY `tile_id` (`tile_id`),
  CONSTRAINT `tile_bag_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`),
  CONSTRAINT `tile_bag_ibfk_2` FOREIGN KEY (`tile_id`) REFERENCES `tiles` (`tile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table: player_hands
-- --------------------------------------------------------
CREATE TABLE `player_hands` (
  `hand_id` INT(11) NOT NULL AUTO_INCREMENT,
  `game_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `tile_id` INT(11) NOT NULL,
  PRIMARY KEY (`hand_id`),
  KEY `game_id` (`game_id`),
  KEY `user_id` (`user_id`),
  KEY `tile_id` (`tile_id`),
  CONSTRAINT `player_hands_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`),
  CONSTRAINT `player_hands_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `player_hands_ibfk_3` FOREIGN KEY (`tile_id`) REFERENCES `tiles` (`tile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table: grid
-- --------------------------------------------------------
CREATE TABLE `grid` (
  `grid_id` INT(11) NOT NULL AUTO_INCREMENT,
  `game_id` INT(11) NOT NULL,
  `tile_id` INT(11) NOT NULL,
  `position_x` INT(11) NOT NULL,
  `position_y` INT(11) NOT NULL,
  PRIMARY KEY (`grid_id`),
  UNIQUE KEY `game_id` (`game_id`,`position_x`,`position_y`),
  KEY `tile_id` (`tile_id`),
  CONSTRAINT `grid_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`),
  CONSTRAINT `grid_ibfk_2` FOREIGN KEY (`tile_id`) REFERENCES `tiles` (`tile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger: CheckEndConditions on tile_bag
--
DELIMITER $$
CREATE TRIGGER `CheckEndConditions`
AFTER DELETE ON `tile_bag`
FOR EACH ROW
BEGIN
    DECLARE remaining_tiles INT;

    SELECT SUM(quantity) INTO remaining_tiles 
    FROM tile_bag 
    WHERE game_id = OLD.game_id;

    IF remaining_tiles IS NULL OR remaining_tiles = 0 THEN
        CALL EndGame(OLD.game_id);
    END IF;
END$$
DELIMITER ;

--
-- Trigger: UpdateScore on grid
--
DELIMITER $$
CREATE TRIGGER `UpdateScore`
AFTER INSERT ON `grid`
FOR EACH ROW
BEGIN
    -- All DECLARE statements first
    DECLARE points INT DEFAULT 1;
    DECLARE this_user INT;

    -- Example: awarding points for row/column (simplified)
    SET points = (
        SELECT COUNT(*)
        FROM grid
        WHERE game_id = NEW.game_id
          AND (position_x = NEW.position_x OR position_y = NEW.position_y)
    );

    -- We'll guess the user who placed the tile is the last holder in player_hands
    SELECT user_id 
      INTO this_user
      FROM player_hands
     WHERE game_id = NEW.game_id
       AND tile_id = NEW.tile_id
     ORDER BY hand_id DESC
     LIMIT 1;

    UPDATE scores
       SET score = score + points
     WHERE game_id = NEW.game_id
       AND user_id = this_user;
END$$
DELIMITER ;

-- --------------------------------------------------------
-- Insert Sample Users
-- --------------------------------------------------------
INSERT INTO `users` (username, password) VALUES
('player1', 'secret'),
('player2', 'secret'),
('player3', 'secret');

--
-- STORED PROCEDURES
--
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EndGame` (IN `p_game_id` INT)
BEGIN
    DECLARE max_score INT DEFAULT 0;
    DECLARE winner_ids TEXT DEFAULT NULL;

    UPDATE games
    SET is_active = FALSE,
        ended_at = CURRENT_TIMESTAMP
    WHERE game_id = p_game_id;

    SELECT MAX(score) INTO max_score
    FROM scores
    WHERE game_id = p_game_id;

    SELECT GROUP_CONCAT(user_id) INTO winner_ids
    FROM scores
    WHERE game_id = p_game_id AND score = max_score;

    INSERT INTO game_log (game_id, user_id, action)
    SELECT p_game_id, user_id, CONCAT('Winner with score: ', max_score)
    FROM scores
    WHERE game_id = p_game_id AND score = max_score;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRemainingTime` (IN `p_game_id` INT)
BEGIN
    DECLARE remaining_time INT;

    SELECT GREATEST(time_limit - TIMESTAMPDIFF(SECOND, start_time, CURRENT_TIMESTAMP), 0) AS remaining_time
    INTO remaining_time
    FROM games
    WHERE game_id = p_game_id;

    SELECT remaining_time;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MakeMove`
(
   IN `p_game_id` INT, 
   IN `p_user_id` INT, 
   IN `p_tile_id` INT, 
   IN `p_position_x` INT, 
   IN `p_position_y` INT
)
BEGIN
    DECLARE is_valid BOOLEAN DEFAULT TRUE;

    SELECT COUNT(*)
    INTO is_valid
    FROM player_hands
    WHERE game_id = p_game_id
      AND user_id = p_user_id
      AND tile_id = p_tile_id;

    IF is_valid = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tile not in player hand';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM grid
        WHERE game_id = p_game_id
          AND position_x = p_position_x
          AND position_y = p_position_y
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Position already occupied';
    END IF;

    INSERT INTO grid (game_id, tile_id, position_x, position_y)
    VALUES (p_game_id, p_tile_id, p_position_x, p_position_y);

    DELETE FROM player_hands
    WHERE game_id = p_game_id
      AND user_id = p_user_id
      AND tile_id = p_tile_id;

    INSERT INTO game_log (game_id, user_id, action)
    VALUES (p_game_id, p_user_id, CONCAT('Placed tile at (', p_position_x, ',', p_position_y, ')'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegisterUser`
(
   IN `p_username` VARCHAR(50), 
   IN `p_password` VARCHAR(255)
)
BEGIN
    DECLARE user_exists INT;

    SELECT COUNT(*)
    INTO user_exists
    FROM users
    WHERE username = p_username;

    IF user_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
    ELSE
        INSERT INTO users (username, password) VALUES (p_username, p_password);
    END IF;
END$$

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `StartGame`
(
   IN `p_created_by` INT, 
   IN `p_player_ids` TEXT
)
BEGIN
    -- ----------------------------------------------------
    -- 1) Declare top-level variables
    -- ----------------------------------------------------
    DECLARE tile_count INT DEFAULT 6;
    DECLARE player_id  INT;
    DECLARE tile_id    INT;

    -- ----------------------------------------------------
    -- 2) Create the game row
    -- ----------------------------------------------------
    INSERT INTO games (created_by, start_time)
    VALUES (p_created_by, CURRENT_TIMESTAMP());
    SET @game_id = LAST_INSERT_ID();

    -- ----------------------------------------------------
    -- 3) Populate tile_bag
    -- ----------------------------------------------------
    INSERT INTO tile_bag (game_id, tile_id, quantity)
    SELECT @game_id, tile_id, 3
    FROM tiles;

    -- ----------------------------------------------------
    -- 4) Create your temporary tables BEFORE the cursor
    -- ----------------------------------------------------
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_numbers (n INT);
    TRUNCATE temp_numbers;
    INSERT INTO temp_numbers (n) VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

    CREATE TEMPORARY TABLE IF NOT EXISTS temp_player_ids (player_id INT NOT NULL);
    TRUNCATE temp_player_ids;

    INSERT INTO temp_player_ids (player_id)
        SELECT CAST(JSON_EXTRACT(p_player_ids, CONCAT('$[', t.n, ']')) AS SIGNED)
          FROM temp_numbers t
         WHERE JSON_EXTRACT(p_player_ids, CONCAT('$[', t.n, ']')) IS NOT NULL;

    -- ----------------------------------------------------
    -- 5) Insert each player into scores (score=0)
    -- ----------------------------------------------------
    INSERT INTO scores (game_id, user_id, score)
    SELECT @game_id, player_id, 0
      FROM temp_player_ids;

    -- ----------------------------------------------------
    -- 6) Nested block for cursor declarations and usage
    -- ----------------------------------------------------
    BEGIN
        -- All DECLAREs for cursor & handlers must go first in this block
        DECLARE done INT DEFAULT FALSE;

        DECLARE cur CURSOR FOR 
            SELECT player_id 
              FROM temp_player_ids;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

        -- 7) Use the cursor to loop over each player

        OPEN cur;
        read_loop: LOOP
            FETCH cur INTO player_id;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Deal 6 tiles to this player
            SET tile_count = 6;
            WHILE tile_count > 0 DO
                SELECT tile_id 
                  INTO tile_id
                  FROM tile_bag
                 WHERE game_id = @game_id
                   AND quantity > 0
                 ORDER BY RAND()
                 LIMIT 1;

                -- If no tiles left, exit loop
                IF tile_id IS NULL THEN
                    LEAVE read_loop;
                END IF;

                -- Give tile to player
                INSERT INTO player_hands (game_id, user_id, tile_id)
                VALUES (@game_id, player_id, tile_id);

                -- Decrement tile in tile_bag
                UPDATE tile_bag
                   SET quantity = quantity - 1
                 WHERE game_id = @game_id
                   AND tile_id = tile_id;

                SET tile_count = tile_count - 1;
            END WHILE;
        END LOOP;
        CLOSE cur;
    END;

END$$

DELIMITER ;

COMMIT;
