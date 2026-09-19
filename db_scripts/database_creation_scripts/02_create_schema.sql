-- Red Pulse / PostgreSQL
-- Script 02: create the MVP relational schema
-- Execute this script while connected to database: RedPulseDB

BEGIN;

CREATE TABLE markets (
    id              BIGSERIAL PRIMARY KEY,
    code            VARCHAR(10)  NOT NULL UNIQUE,
    name            VARCHAR(100) NOT NULL,
    region          VARCHAR(100),
    currency_code   CHAR(3)      NOT NULL,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE players (
    id                BIGSERIAL PRIMARY KEY,
    player_ref        VARCHAR(64) NOT NULL UNIQUE,
    market_id         BIGINT      NOT NULL REFERENCES markets(id) ON DELETE RESTRICT,
    registration_at   TIMESTAMPTZ NOT NULL,
    first_deposit_at  TIMESTAMPTZ,
    status            VARCHAR(30) NOT NULL DEFAULT 'active'
                      CHECK (status IN ('active','blocked','closed','self_excluded')),
    is_test           BOOLEAN     NOT NULL DEFAULT FALSE,
    segment           VARCHAR(30)
                      CHECK (segment IS NULL OR segment IN ('VIP','Regular','Casual','Dormant')),
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE providers (
    id          BIGSERIAL PRIMARY KEY,
    code        VARCHAR(50)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    is_active   BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE games (
    id           BIGSERIAL PRIMARY KEY,
    provider_id  BIGINT       NOT NULL REFERENCES providers(id) ON DELETE RESTRICT,
    game_code    VARCHAR(100)  NOT NULL,
    name         VARCHAR(150)  NOT NULL,
    category     VARCHAR(50)   NOT NULL,
    is_active    BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_games_provider_code UNIQUE (provider_id, game_code)
);

CREATE TABLE bets (
    id                BIGSERIAL PRIMARY KEY,
    bet_ref           VARCHAR(100) NOT NULL UNIQUE,
    player_id         BIGINT       NOT NULL REFERENCES players(id) ON DELETE RESTRICT,
    market_id         BIGINT       NOT NULL REFERENCES markets(id) ON DELETE RESTRICT,
    provider_id       BIGINT       NOT NULL REFERENCES providers(id) ON DELETE RESTRICT,
    game_id           BIGINT       NOT NULL REFERENCES games(id) ON DELETE RESTRICT,
    placed_at         TIMESTAMPTZ  NOT NULL,
    settled_at        TIMESTAMPTZ,
    status            VARCHAR(30)  NOT NULL
                      CHECK (status IN ('open','settled','void','cancelled')),
    currency_code     CHAR(3)      NOT NULL,
    stake_amount      NUMERIC(18,2) NOT NULL CHECK (stake_amount >= 0),
    payout_amount     NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (payout_amount >= 0),
    bonus_bet_amount  NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (bonus_bet_amount >= 0),
    is_real_money     BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE deposits (
    id                BIGSERIAL PRIMARY KEY,
    deposit_ref       VARCHAR(100) NOT NULL UNIQUE,
    player_id         BIGINT       NOT NULL REFERENCES players(id) ON DELETE RESTRICT,
    market_id         BIGINT       NOT NULL REFERENCES markets(id) ON DELETE RESTRICT,
    requested_at      TIMESTAMPTZ  NOT NULL,
    processed_at      TIMESTAMPTZ,
    status            VARCHAR(30)  NOT NULL
                      CHECK (status IN ('pending','successful','failed','reversed')),
    currency_code     CHAR(3)      NOT NULL,
    amount            NUMERIC(18,2) NOT NULL CHECK (amount >= 0),
    payment_method    VARCHAR(50),
    is_first_deposit  BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE withdrawals (
    id                BIGSERIAL PRIMARY KEY,
    withdrawal_ref    VARCHAR(100) NOT NULL UNIQUE,
    player_id         BIGINT       NOT NULL REFERENCES players(id) ON DELETE RESTRICT,
    market_id         BIGINT       NOT NULL REFERENCES markets(id) ON DELETE RESTRICT,
    requested_at      TIMESTAMPTZ  NOT NULL,
    processed_at      TIMESTAMPTZ,
    status            VARCHAR(30)  NOT NULL
                      CHECK (status IN ('pending','successful','failed','rejected','reversed')),
    currency_code     CHAR(3)      NOT NULL,
    amount            NUMERIC(18,2) NOT NULL CHECK (amount >= 0),
    payment_method    VARCHAR(50),
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE bonuses (
    id                 BIGSERIAL PRIMARY KEY,
    bonus_ref          VARCHAR(100) NOT NULL UNIQUE,
    player_id          BIGINT       NOT NULL REFERENCES players(id) ON DELETE RESTRICT,
    market_id          BIGINT       NOT NULL REFERENCES markets(id) ON DELETE RESTRICT,
    bonus_type         VARCHAR(50)  NOT NULL,
    campaign_name      VARCHAR(100),
    issued_at          TIMESTAMPTZ  NOT NULL,
    activated_at       TIMESTAMPTZ,
    expired_at         TIMESTAMPTZ,
    status             VARCHAR(30)  NOT NULL
                       CHECK (status IN ('issued','activated','expired','cancelled','consumed')),
    issued_amount      NUMERIC(18,2) NOT NULL CHECK (issued_amount >= 0),
    bonus_cost_amount  NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (bonus_cost_amount >= 0),
    created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE technical_metrics (
    id             BIGSERIAL PRIMARY KEY,
    market_id      BIGINT REFERENCES markets(id) ON DELETE RESTRICT,
    metric_type    VARCHAR(50)  NOT NULL
                   CHECK (metric_type IN ('availability','api_error_rate','game_launch_failure_rate','p95_response_time')),
    service_name   VARCHAR(100),
    measured_at    TIMESTAMPTZ  NOT NULL,
    numerator      NUMERIC(18,4),
    denominator    NUMERIC(18,4),
    value          NUMERIC(18,4) NOT NULL,
    unit           VARCHAR(20)   NOT NULL
                   CHECK (unit IN ('pct','ms','count')),
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Reporting indexes
CREATE INDEX idx_players_market_id             ON players(market_id);
CREATE INDEX idx_players_registration_at       ON players(registration_at);
CREATE INDEX idx_players_first_deposit_at      ON players(first_deposit_at);
CREATE INDEX idx_players_is_test               ON players(is_test);

CREATE INDEX idx_games_provider_id             ON games(provider_id);

CREATE INDEX idx_bets_player_id                ON bets(player_id);
CREATE INDEX idx_bets_market_id                ON bets(market_id);
CREATE INDEX idx_bets_game_id                  ON bets(game_id);
CREATE INDEX idx_bets_provider_id              ON bets(provider_id);
CREATE INDEX idx_bets_placed_at                ON bets(placed_at);
CREATE INDEX idx_bets_settled_at               ON bets(settled_at);
CREATE INDEX idx_bets_status                   ON bets(status);
CREATE INDEX idx_bets_market_settled           ON bets(market_id, settled_at);
CREATE INDEX idx_bets_game_settled             ON bets(game_id, settled_at);
CREATE INDEX idx_bets_provider_settled         ON bets(provider_id, settled_at);

CREATE INDEX idx_deposits_player_id            ON deposits(player_id);
CREATE INDEX idx_deposits_market_id            ON deposits(market_id);
CREATE INDEX idx_deposits_processed_at         ON deposits(processed_at);
CREATE INDEX idx_deposits_status               ON deposits(status);
CREATE INDEX idx_deposits_market_processed     ON deposits(market_id, processed_at);

CREATE INDEX idx_withdrawals_player_id         ON withdrawals(player_id);
CREATE INDEX idx_withdrawals_market_id         ON withdrawals(market_id);
CREATE INDEX idx_withdrawals_processed_at      ON withdrawals(processed_at);
CREATE INDEX idx_withdrawals_status            ON withdrawals(status);
CREATE INDEX idx_withdrawals_market_processed  ON withdrawals(market_id, processed_at);

CREATE INDEX idx_bonuses_player_id             ON bonuses(player_id);
CREATE INDEX idx_bonuses_market_id             ON bonuses(market_id);
CREATE INDEX idx_bonuses_issued_at             ON bonuses(issued_at);
CREATE INDEX idx_bonuses_bonus_type            ON bonuses(bonus_type);
CREATE INDEX idx_bonuses_status                ON bonuses(status);
CREATE INDEX idx_bonuses_market_issued         ON bonuses(market_id, issued_at);

CREATE INDEX idx_technical_market              ON technical_metrics(market_id);
CREATE INDEX idx_technical_metric_type         ON technical_metrics(metric_type);
CREATE INDEX idx_technical_measured_at         ON technical_metrics(measured_at);
CREATE INDEX idx_technical_type_measured       ON technical_metrics(metric_type, measured_at);
CREATE INDEX idx_technical_market_type_time    ON technical_metrics(market_id, metric_type, measured_at);

COMMIT;
