INSERT INTO nba_players

-- First read in yesterday from the cumulative table
WITH yesterday AS (
    SELECT
        player_id,
        player_name,
        team_id,
        team_name,
        game_date,
        SUM(points) AS points,
        SUM(rebounds) AS rebounds,
        SUM(assists) AS assists,
        SUM(steals) AS steals,
        SUM(blocks) AS blocks,
        SUM(turnovers) AS turnovers
    FROM nba_players
    WHERE game_date = '2020-01-01'
    GROUP BY 1, 2, 3, 4, 5
)

-- Then insert today's data
INSERT INTO nba_players

SELECT
    player_id,
    player_name,
    team_id,
    team_name,
    game_date,
    SUM(points) AS points,
    SUM(rebounds) AS rebounds,
    SUM(assists) AS assists,
    SUM(steals) AS steals,
    SUM(blocks) AS blocks,
    SUM(turnovers) AS turnovers
FROM nba_players
WHERE game_date = '2020-01-02'
GROUP BY 1, 2, 3, 4, 5
ON CONFLICT (player_id, game_date) DO UPDATE
SET
    points = EXCLUDED.points,
    rebounds = EXCLUDED.rebounds,
    assists = EXCLUDED.assists,
    steals = EXCLUDED.steals,
    blocks = EXCLUDED.blocks,
    turnovers = EXCLUDED.turnovers;
```
