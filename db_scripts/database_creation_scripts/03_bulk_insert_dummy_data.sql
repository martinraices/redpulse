-- Red Pulse / PostgreSQL
-- Script 03: bulk-generate synthetic development data
-- Execute while connected to RedPulseDB AFTER 02_create_schema.sql.
-- The generated data is synthetic and must never be treated as production data.


BEGIN;

-- Make repeated runs safe for local development.
TRUNCATE TABLE
    technical_metrics,
    bonuses,
    withdrawals,
    deposits,
    bets,
    games,
    providers,
    players,
    markets
RESTART IDENTITY CASCADE;

-- Reference data -------------------------------------------------------------
INSERT INTO markets (code, name, region, currency_code)
VALUES
    ('GB', 'United Kingdom', 'Europe', 'GBP'),
    ('ES', 'Spain',          'Europe', 'EUR'),
    ('SE', 'Sweden',         'Europe', 'SEK'),
    ('DE', 'Germany',        'Europe', 'EUR'),
    ('CA', 'Canada',         'North America', 'CAD'),
    ('BR', 'Brazil',         'South America', 'BRL');

INSERT INTO providers (code, name)
VALUES
    ('PRAG', 'Pragmatic Play'),
    ('EVOP', 'Evolution'),
    ('NETE', 'NetEnt'),
    ('PLAY', 'Playtech'),
    ('REDX', 'RedX Games');

INSERT INTO games (provider_id, game_code, name, category)
VALUES
    (1, 'PRAG-SWEET', 'Sweet Bonanza',        'Slots'),
    (1, 'PRAG-GATES', 'Gates of Olympus',     'Slots'),
    (1, 'PRAG-WOLF',  'Wolf Gold',            'Slots'),
    (1, 'PRAG-BASS',  'Big Bass Splash',      'Slots'),
    (2, 'EVOP-ROUL',  'Live Roulette',         'Live Casino'),
    (2, 'EVOP-BJ',    'Live Blackjack',        'Live Casino'),
    (2, 'EVOP-BACC',  'Live Baccarat',         'Live Casino'),
    (2, 'EVOP-CRAZY', 'Crazy Time',            'Live Casino'),
    (3, 'NETE-STAR',  'Starburst',             'Slots'),
    (3, 'NETE-DEAD',  'Dead or Alive 2',       'Slots'),
    (3, 'NETE-GONZO', 'Gonzo''s Quest',        'Slots'),
    (3, 'NETE-JACK',  'Jack Hammer',           'Slots'),
    (4, 'PLAY-AGE',   'Age of the Gods',       'Slots'),
    (4, 'PLAY-BUFF',  'Buffalo Blitz',         'Slots'),
    (4, 'PLAY-ROUL',  'Premium Roulette',      'Table'),
    (4, 'PLAY-BJ',    'Premium Blackjack',     'Table'),
    (5, 'REDX-PULSE', 'Red Pulse Reels',       'Slots'),
    (5, 'REDX-FIRE',  'Fireline 7s',           'Slots'),
    (5, 'REDX-ROUL',  'RedX Roulette',         'Table'),
    (5, 'REDX-ARENA', 'RedX Live Arena',       'Live Casino');

-- Players: 5,000 -------------------------------------------------------------
INSERT INTO players (
    player_ref, market_id, registration_at, status, is_test, segment
)
SELECT
    'PLY-' || LPAD(gs::text, 8, '0'),
    1 + ((gs - 1) % 6),
    NOW() - ((gs * 37) % 365) * INTERVAL '1 day'
          - ((gs * 11) % 24)  * INTERVAL '1 hour',
    CASE
        WHEN gs % 97 = 0 THEN 'self_excluded'
        WHEN gs % 89 = 0 THEN 'closed'
        WHEN gs % 83 = 0 THEN 'blocked'
        ELSE 'active'
    END,
    (gs % 100 = 0),
    CASE
        WHEN gs % 20 = 0 THEN 'VIP'
        WHEN gs % 5  = 0 THEN 'Dormant'
        WHEN gs % 2  = 0 THEN 'Regular'
        ELSE 'Casual'
    END
FROM generate_series(1, 5000) AS gs;

-- Bets: 100,000 --------------------------------------------------------------
INSERT INTO bets (
    bet_ref, player_id, market_id, provider_id, game_id,
    placed_at, settled_at, status, currency_code,
    stake_amount, payout_amount, bonus_bet_amount, is_real_money
)
SELECT
    'BET-' || LPAD(gs::text, 10, '0'),
    p.id,
    p.market_id,
    g.provider_id,
    g.id,
    NOW() - ((gs * 13) % (90 * 24 * 60)) * INTERVAL '1 minute',
    NOW() - ((gs * 13) % (90 * 24 * 60)) * INTERVAL '1 minute'
          + (1 + (gs % 40)) * INTERVAL '1 minute',
    CASE
        WHEN gs % 101 = 0 THEN 'void'
        WHEN gs % 137 = 0 THEN 'cancelled'
        ELSE 'settled'
    END,
    m.currency_code,
    ROUND((0.50 + ((gs * 17) % 5000) / 100.0)::numeric, 2),
    ROUND(
        (CASE
            WHEN gs % 9 = 0 THEN 0
            WHEN gs % 7 = 0 THEN (0.50 + ((gs * 17) % 5000) / 100.0) * 2.40
            WHEN gs % 5 = 0 THEN (0.50 + ((gs * 17) % 5000) / 100.0) * 1.30
            ELSE (0.50 + ((gs * 17) % 5000) / 100.0) * 0.72
        END)::numeric,
        2
    ),
    ROUND((CASE WHEN gs % 10 = 0 THEN ((gs * 3) % 500) / 100.0 ELSE 0 END)::numeric, 2),
    (gs % 25 <> 0)
FROM generate_series(1, 100000) AS gs
JOIN players p ON p.id = 1 + ((gs * 17 - 1) % 5000)
JOIN games   g ON g.id = 1 + ((gs * 7  - 1) % 20)
JOIN markets m ON m.id = p.market_id;

-- Deposits: 8,000 ------------------------------------------------------------
INSERT INTO deposits (
    deposit_ref, player_id, market_id, requested_at, processed_at,
    status, currency_code, amount, payment_method, is_first_deposit
)
SELECT
    'DEP-' || LPAD(gs::text, 9, '0'),
    p.id,
    p.market_id,
    LEAST(NOW() - INTERVAL '2 hours', p.registration_at + ((gs * 19) % 120) * INTERVAL '1 day'),
    LEAST(NOW() - INTERVAL '1 hour', p.registration_at + ((gs * 19) % 120) * INTERVAL '1 day'
          + (2 + gs % 120) * INTERVAL '1 minute'),
    CASE
        WHEN gs % 29 = 0 THEN 'failed'
        WHEN gs % 113 = 0 THEN 'reversed'
        WHEN gs % 47 = 0 THEN 'pending'
        ELSE 'successful'
    END,
    m.currency_code,
    ROUND((10 + ((gs * 23) % 49000) / 100.0)::numeric, 2),
    CASE gs % 4
        WHEN 0 THEN 'Card'
        WHEN 1 THEN 'Bank Transfer'
        WHEN 2 THEN 'E-Wallet'
        ELSE 'Instant Banking'
    END,
    FALSE
FROM generate_series(1, 8000) AS gs
JOIN players p ON p.id = 1 + ((gs * 31 - 1) % 5000)
JOIN markets m ON m.id = p.market_id;

-- Mark the first successful deposit per player and copy it to players.
WITH ranked AS (
    SELECT id, player_id, processed_at,
           ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY processed_at, id) AS rn
    FROM deposits
    WHERE status = 'successful'
)
UPDATE deposits d
SET is_first_deposit = TRUE
FROM ranked r
WHERE d.id = r.id AND r.rn = 1;

UPDATE players p
SET first_deposit_at = x.first_deposit_at,
    updated_at = NOW()
FROM (
    SELECT player_id, MIN(processed_at) AS first_deposit_at
    FROM deposits
    WHERE status = 'successful'
    GROUP BY player_id
) x
WHERE p.id = x.player_id;

-- Withdrawals: 4,000 ---------------------------------------------------------
INSERT INTO withdrawals (
    withdrawal_ref, player_id, market_id, requested_at, processed_at,
    status, currency_code, amount, payment_method
)
SELECT
    'WDR-' || LPAD(gs::text, 9, '0'),
    p.id,
    p.market_id,
    NOW() - ((gs * 29) % (120 * 24)) * INTERVAL '1 hour',
    NOW() - ((gs * 29) % (120 * 24)) * INTERVAL '1 hour'
          + (10 + gs % 240) * INTERVAL '1 minute',
    CASE
        WHEN gs % 41 = 0 THEN 'failed'
        WHEN gs % 67 = 0 THEN 'rejected'
        WHEN gs % 109 = 0 THEN 'reversed'
        WHEN gs % 31 = 0 THEN 'pending'
        ELSE 'successful'
    END,
    m.currency_code,
    ROUND((20 + ((gs * 47) % 98000) / 100.0)::numeric, 2),
    CASE gs % 4
        WHEN 0 THEN 'Card'
        WHEN 1 THEN 'Bank Transfer'
        WHEN 2 THEN 'E-Wallet'
        ELSE 'Instant Banking'
    END
FROM generate_series(1, 4000) AS gs
JOIN players p ON p.id = 1 + ((gs * 43 - 1) % 5000)
JOIN markets m ON m.id = p.market_id;

-- Bonuses: 7,000 -------------------------------------------------------------
INSERT INTO bonuses (
    bonus_ref, player_id, market_id, bonus_type, campaign_name,
    issued_at, activated_at, expired_at, status,
    issued_amount, bonus_cost_amount
)
SELECT
    'BON-' || LPAD(gs::text, 9, '0'),
    p.id,
    p.market_id,
    CASE gs % 4
        WHEN 0 THEN 'Welcome'
        WHEN 1 THEN 'Free Spins'
        WHEN 2 THEN 'Reload'
        ELSE 'Retention'
    END,
    CASE gs % 4
        WHEN 0 THEN 'Welcome 100'
        WHEN 1 THEN 'Weekend Spins'
        WHEN 2 THEN 'Reload Boost'
        ELSE 'Keep Playing'
    END,
    NOW() - ((gs * 17) % (120 * 24)) * INTERVAL '1 hour',
    CASE WHEN gs % 5 <> 0
         THEN NOW() - ((gs * 17) % (120 * 24)) * INTERVAL '1 hour'
              + (1 + gs % 72) * INTERVAL '1 hour'
         ELSE NULL END,
    NOW() - ((gs * 17) % (120 * 24)) * INTERVAL '1 hour' + INTERVAL '30 days',
    CASE
        WHEN gs % 17 = 0 THEN 'cancelled'
        WHEN gs % 11 = 0 THEN 'expired'
        WHEN gs % 5  = 0 THEN 'issued'
        WHEN gs % 3  = 0 THEN 'consumed'
        ELSE 'activated'
    END,
    ROUND((5 + ((gs * 13) % 9500) / 100.0)::numeric, 2),
    ROUND((CASE
        WHEN gs % 5 = 0 THEN 0
        ELSE (2 + ((gs * 7) % 5500) / 100.0)
    END)::numeric, 2)
FROM generate_series(1, 7000) AS gs
JOIN players p ON p.id = 1 + ((gs * 59 - 1) % 5000);

-- Technical metrics: 30 days of hourly data x 6 markets x 4 metrics --------
WITH hours AS (
    SELECT generate_series(
        date_trunc('hour', NOW()) - INTERVAL '30 days',
        date_trunc('hour', NOW()),
        INTERVAL '1 hour'
    ) AS measured_at
), metric_types(metric_type, unit) AS (
    VALUES
        ('availability', 'pct'),
        ('api_error_rate', 'pct'),
        ('game_launch_failure_rate', 'pct'),
        ('p95_response_time', 'ms')
)
INSERT INTO technical_metrics (
    market_id, metric_type, service_name, measured_at,
    numerator, denominator, value, unit
)
SELECT
    m.id,
    mt.metric_type,
    CASE mt.metric_type
        WHEN 'availability' THEN 'platform'
        WHEN 'api_error_rate' THEN 'api-gateway'
        WHEN 'game_launch_failure_rate' THEN 'game-launch'
        ELSE 'api-gateway'
    END,
    h.measured_at,
    CASE
        WHEN mt.metric_type IN ('api_error_rate','game_launch_failure_rate')
            THEN ((EXTRACT(EPOCH FROM h.measured_at)::bigint / 3600 + m.id * 7) % 15)::numeric
        ELSE NULL
    END,
    CASE
        WHEN mt.metric_type IN ('api_error_rate','game_launch_failure_rate') THEN 1000
        ELSE NULL
    END,
    CASE mt.metric_type
        WHEN 'availability' THEN
            ROUND((99.70 + (((EXTRACT(EPOCH FROM h.measured_at)::bigint / 3600 + m.id) % 30) / 100.0))::numeric, 4)
        WHEN 'api_error_rate' THEN
            ROUND((0.10 + (((EXTRACT(EPOCH FROM h.measured_at)::bigint / 3600 + m.id * 3) % 75) / 100.0))::numeric, 4)
        WHEN 'game_launch_failure_rate' THEN
            ROUND((0.20 + (((EXTRACT(EPOCH FROM h.measured_at)::bigint / 3600 + m.id * 5) % 90) / 100.0))::numeric, 4)
        ELSE
            ROUND((180 + ((EXTRACT(EPOCH FROM h.measured_at)::bigint / 3600 + m.id * 11) % 420))::numeric, 4)
    END,
    mt.unit
FROM markets m
CROSS JOIN hours h
CROSS JOIN metric_types mt;

ANALYZE markets;
ANALYZE players;
ANALYZE providers;
ANALYZE games;
ANALYZE bets;
ANALYZE deposits;
ANALYZE withdrawals;
ANALYZE bonuses;
ANALYZE technical_metrics;

COMMIT;

-- Quick verification ---------------------------------------------------------
SELECT 'markets' AS table_name, COUNT(*) AS row_count FROM markets
UNION ALL SELECT 'players', COUNT(*) FROM players
UNION ALL SELECT 'providers', COUNT(*) FROM providers
UNION ALL SELECT 'games', COUNT(*) FROM games
UNION ALL SELECT 'bets', COUNT(*) FROM bets
UNION ALL SELECT 'deposits', COUNT(*) FROM deposits
UNION ALL SELECT 'withdrawals', COUNT(*) FROM withdrawals
UNION ALL SELECT 'bonuses', COUNT(*) FROM bonuses
UNION ALL SELECT 'technical_metrics', COUNT(*) FROM technical_metrics
ORDER BY table_name;
