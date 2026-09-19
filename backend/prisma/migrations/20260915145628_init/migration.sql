-- CreateTable
CREATE TABLE "bets" (
    "id" BIGSERIAL NOT NULL,
    "bet_ref" VARCHAR(100) NOT NULL,
    "player_id" BIGINT NOT NULL,
    "market_id" BIGINT NOT NULL,
    "provider_id" BIGINT NOT NULL,
    "game_id" BIGINT NOT NULL,
    "placed_at" TIMESTAMPTZ(6) NOT NULL,
    "settled_at" TIMESTAMPTZ(6),
    "status" VARCHAR(30) NOT NULL,
    "currency_code" CHAR(3) NOT NULL,
    "stake_amount" DECIMAL(18,2) NOT NULL,
    "payout_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "bonus_bet_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "is_real_money" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bonuses" (
    "id" BIGSERIAL NOT NULL,
    "bonus_ref" VARCHAR(100) NOT NULL,
    "player_id" BIGINT NOT NULL,
    "market_id" BIGINT NOT NULL,
    "bonus_type" VARCHAR(50) NOT NULL,
    "campaign_name" VARCHAR(100),
    "issued_at" TIMESTAMPTZ(6) NOT NULL,
    "activated_at" TIMESTAMPTZ(6),
    "expired_at" TIMESTAMPTZ(6),
    "status" VARCHAR(30) NOT NULL,
    "issued_amount" DECIMAL(18,2) NOT NULL,
    "bonus_cost_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bonuses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "deposits" (
    "id" BIGSERIAL NOT NULL,
    "deposit_ref" VARCHAR(100) NOT NULL,
    "player_id" BIGINT NOT NULL,
    "market_id" BIGINT NOT NULL,
    "requested_at" TIMESTAMPTZ(6) NOT NULL,
    "processed_at" TIMESTAMPTZ(6),
    "status" VARCHAR(30) NOT NULL,
    "currency_code" CHAR(3) NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "payment_method" VARCHAR(50),
    "is_first_deposit" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "deposits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "games" (
    "id" BIGSERIAL NOT NULL,
    "provider_id" BIGINT NOT NULL,
    "game_code" VARCHAR(100) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "category" VARCHAR(50) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "markets" (
    "id" BIGSERIAL NOT NULL,
    "code" VARCHAR(10) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "region" VARCHAR(100),
    "currency_code" CHAR(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "markets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "players" (
    "id" BIGSERIAL NOT NULL,
    "player_ref" VARCHAR(64) NOT NULL,
    "market_id" BIGINT NOT NULL,
    "registration_at" TIMESTAMPTZ(6) NOT NULL,
    "first_deposit_at" TIMESTAMPTZ(6),
    "status" VARCHAR(30) NOT NULL DEFAULT 'active',
    "is_test" BOOLEAN NOT NULL DEFAULT false,
    "segment" VARCHAR(30),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "players_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "providers" (
    "id" BIGSERIAL NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "providers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "technical_metrics" (
    "id" BIGSERIAL NOT NULL,
    "market_id" BIGINT,
    "metric_type" VARCHAR(50) NOT NULL,
    "service_name" VARCHAR(100),
    "measured_at" TIMESTAMPTZ(6) NOT NULL,
    "numerator" DECIMAL(18,4),
    "denominator" DECIMAL(18,4),
    "value" DECIMAL(18,4) NOT NULL,
    "unit" VARCHAR(20) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "technical_metrics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "withdrawals" (
    "id" BIGSERIAL NOT NULL,
    "withdrawal_ref" VARCHAR(100) NOT NULL,
    "player_id" BIGINT NOT NULL,
    "market_id" BIGINT NOT NULL,
    "requested_at" TIMESTAMPTZ(6) NOT NULL,
    "processed_at" TIMESTAMPTZ(6),
    "status" VARCHAR(30) NOT NULL,
    "currency_code" CHAR(3) NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "payment_method" VARCHAR(50),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "withdrawals_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "bets_bet_ref_key" ON "bets"("bet_ref");

-- CreateIndex
CREATE INDEX "idx_bets_game_id" ON "bets"("game_id");

-- CreateIndex
CREATE INDEX "idx_bets_game_settled" ON "bets"("game_id", "settled_at");

-- CreateIndex
CREATE INDEX "idx_bets_market_id" ON "bets"("market_id");

-- CreateIndex
CREATE INDEX "idx_bets_market_settled" ON "bets"("market_id", "settled_at");

-- CreateIndex
CREATE INDEX "idx_bets_placed_at" ON "bets"("placed_at");

-- CreateIndex
CREATE INDEX "idx_bets_player_id" ON "bets"("player_id");

-- CreateIndex
CREATE INDEX "idx_bets_provider_id" ON "bets"("provider_id");

-- CreateIndex
CREATE INDEX "idx_bets_provider_settled" ON "bets"("provider_id", "settled_at");

-- CreateIndex
CREATE INDEX "idx_bets_settled_at" ON "bets"("settled_at");

-- CreateIndex
CREATE INDEX "idx_bets_status" ON "bets"("status");

-- CreateIndex
CREATE UNIQUE INDEX "bonuses_bonus_ref_key" ON "bonuses"("bonus_ref");

-- CreateIndex
CREATE INDEX "idx_bonuses_bonus_type" ON "bonuses"("bonus_type");

-- CreateIndex
CREATE INDEX "idx_bonuses_issued_at" ON "bonuses"("issued_at");

-- CreateIndex
CREATE INDEX "idx_bonuses_market_id" ON "bonuses"("market_id");

-- CreateIndex
CREATE INDEX "idx_bonuses_market_issued" ON "bonuses"("market_id", "issued_at");

-- CreateIndex
CREATE INDEX "idx_bonuses_player_id" ON "bonuses"("player_id");

-- CreateIndex
CREATE INDEX "idx_bonuses_status" ON "bonuses"("status");

-- CreateIndex
CREATE UNIQUE INDEX "deposits_deposit_ref_key" ON "deposits"("deposit_ref");

-- CreateIndex
CREATE INDEX "idx_deposits_market_id" ON "deposits"("market_id");

-- CreateIndex
CREATE INDEX "idx_deposits_market_processed" ON "deposits"("market_id", "processed_at");

-- CreateIndex
CREATE INDEX "idx_deposits_player_id" ON "deposits"("player_id");

-- CreateIndex
CREATE INDEX "idx_deposits_processed_at" ON "deposits"("processed_at");

-- CreateIndex
CREATE INDEX "idx_deposits_status" ON "deposits"("status");

-- CreateIndex
CREATE INDEX "idx_games_provider_id" ON "games"("provider_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_games_provider_code" ON "games"("provider_id", "game_code");

-- CreateIndex
CREATE UNIQUE INDEX "markets_code_key" ON "markets"("code");

-- CreateIndex
CREATE UNIQUE INDEX "players_player_ref_key" ON "players"("player_ref");

-- CreateIndex
CREATE INDEX "idx_players_first_deposit_at" ON "players"("first_deposit_at");

-- CreateIndex
CREATE INDEX "idx_players_is_test" ON "players"("is_test");

-- CreateIndex
CREATE INDEX "idx_players_market_id" ON "players"("market_id");

-- CreateIndex
CREATE INDEX "idx_players_registration_at" ON "players"("registration_at");

-- CreateIndex
CREATE UNIQUE INDEX "providers_code_key" ON "providers"("code");

-- CreateIndex
CREATE INDEX "idx_technical_market" ON "technical_metrics"("market_id");

-- CreateIndex
CREATE INDEX "idx_technical_market_type_time" ON "technical_metrics"("market_id", "metric_type", "measured_at");

-- CreateIndex
CREATE INDEX "idx_technical_measured_at" ON "technical_metrics"("measured_at");

-- CreateIndex
CREATE INDEX "idx_technical_metric_type" ON "technical_metrics"("metric_type");

-- CreateIndex
CREATE INDEX "idx_technical_type_measured" ON "technical_metrics"("metric_type", "measured_at");

-- CreateIndex
CREATE UNIQUE INDEX "withdrawals_withdrawal_ref_key" ON "withdrawals"("withdrawal_ref");

-- CreateIndex
CREATE INDEX "idx_withdrawals_market_id" ON "withdrawals"("market_id");

-- CreateIndex
CREATE INDEX "idx_withdrawals_market_processed" ON "withdrawals"("market_id", "processed_at");

-- CreateIndex
CREATE INDEX "idx_withdrawals_player_id" ON "withdrawals"("player_id");

-- CreateIndex
CREATE INDEX "idx_withdrawals_processed_at" ON "withdrawals"("processed_at");

-- CreateIndex
CREATE INDEX "idx_withdrawals_status" ON "withdrawals"("status");

-- AddForeignKey
ALTER TABLE "bets" ADD CONSTRAINT "bets_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bets" ADD CONSTRAINT "bets_market_id_fkey" FOREIGN KEY ("market_id") REFERENCES "markets"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bets" ADD CONSTRAINT "bets_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "players"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bets" ADD CONSTRAINT "bets_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "providers"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bonuses" ADD CONSTRAINT "bonuses_market_id_fkey" FOREIGN KEY ("market_id") REFERENCES "markets"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "bonuses" ADD CONSTRAINT "bonuses_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "players"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "deposits" ADD CONSTRAINT "deposits_market_id_fkey" FOREIGN KEY ("market_id") REFERENCES "markets"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "deposits" ADD CONSTRAINT "deposits_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "players"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "games" ADD CONSTRAINT "games_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "providers"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "players" ADD CONSTRAINT "players_market_id_fkey" FOREIGN KEY ("market_id") REFERENCES "markets"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "technical_metrics" ADD CONSTRAINT "technical_metrics_market_id_fkey" FOREIGN KEY ("market_id") REFERENCES "markets"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "withdrawals" ADD CONSTRAINT "withdrawals_market_id_fkey" FOREIGN KEY ("market_id") REFERENCES "markets"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "withdrawals" ADD CONSTRAINT "withdrawals_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "players"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- Check constraints: players
ALTER TABLE "players"
ADD CONSTRAINT "players_status_check"
CHECK ("status" IN ('active','blocked','closed','self_excluded'));

ALTER TABLE "players"
ADD CONSTRAINT "players_segment_check"
CHECK (
  "segment" IS NULL
  OR "segment" IN ('VIP','Regular','Casual','Dormant')
);

-- Check constraints: bets
ALTER TABLE "bets"
ADD CONSTRAINT "bets_status_check"
CHECK ("status" IN ('open','settled','void','cancelled'));

ALTER TABLE "bets"
ADD CONSTRAINT "bets_stake_amount_check"
CHECK ("stake_amount" >= 0);

ALTER TABLE "bets"
ADD CONSTRAINT "bets_payout_amount_check"
CHECK ("payout_amount" >= 0);

ALTER TABLE "bets"
ADD CONSTRAINT "bets_bonus_bet_amount_check"
CHECK ("bonus_bet_amount" >= 0);

-- Check constraints: deposits
ALTER TABLE "deposits"
ADD CONSTRAINT "deposits_status_check"
CHECK ("status" IN ('pending','successful','failed','reversed'));

ALTER TABLE "deposits"
ADD CONSTRAINT "deposits_amount_check"
CHECK ("amount" >= 0);

-- Check constraints: withdrawals
ALTER TABLE "withdrawals"
ADD CONSTRAINT "withdrawals_status_check"
CHECK ("status" IN ('pending','successful','failed','rejected','reversed'));

ALTER TABLE "withdrawals"
ADD CONSTRAINT "withdrawals_amount_check"
CHECK ("amount" >= 0);

-- Check constraints: bonuses
ALTER TABLE "bonuses"
ADD CONSTRAINT "bonuses_status_check"
CHECK ("status" IN ('issued','activated','expired','cancelled','consumed'));

ALTER TABLE "bonuses"
ADD CONSTRAINT "bonuses_issued_amount_check"
CHECK ("issued_amount" >= 0);

ALTER TABLE "bonuses"
ADD CONSTRAINT "bonuses_bonus_cost_amount_check"
CHECK ("bonus_cost_amount" >= 0);

-- Check constraints: technical metrics
ALTER TABLE "technical_metrics"
ADD CONSTRAINT "technical_metrics_metric_type_check"
CHECK (
  "metric_type" IN (
    'availability',
    'api_error_rate',
    'game_launch_failure_rate',
    'p95_response_time'
  )
);

ALTER TABLE "technical_metrics"
ADD CONSTRAINT "technical_metrics_unit_check"
CHECK ("unit" IN ('pct','ms','count'));