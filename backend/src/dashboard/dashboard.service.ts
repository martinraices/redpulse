import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class DashboardService {
  // PrismaService gives this service access to the PostgreSQL database.
  constructor(private readonly prisma: PrismaService) {}

  async getSummary() {
    // Define the default dashboard period.
    // startOfDay = today at 00:00
    // thirtyDaysAgo = 30 days before today
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const thirtyDaysAgo = new Date(startOfDay);
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 60);

    // REVENUE
    // GGR = total settled real-money stakes - total payouts.
    const revenueStakeAmount = await this.prisma.bets.aggregate({
      where: {
        status: 'settled',
        is_real_money: true,
        settled_at: {
          gte: thirtyDaysAgo,
        },
      },
      _sum: {
        stake_amount: true,
      },
    });

    const payoutAmount = await this.prisma.bets.aggregate({
      where: {
        status: 'settled',
        is_real_money: true,
        settled_at: {
          gte: thirtyDaysAgo,
        },
      },
      _sum: {
        payout_amount: true,
      },
    });

    // Prisma Decimal values are converted to normal JavaScript numbers.
    const revenueStakeAmountValue = Number(
      revenueStakeAmount._sum.stake_amount ?? 0,
    );

    const payoutAmountValue = Number(payoutAmount._sum.payout_amount ?? 0);

    // Gross Gaming Revenue.
    const ggr = Number(
      (revenueStakeAmountValue - payoutAmountValue).toFixed(2),
    );

    // PLAYERS
    // Count active non-test player accounts.
    const activePlayers = await this.prisma.players.count({
      where: {
        is_test: false,
        bets: {
          some: {
            status: 'settled',
            is_real_money: true,
            placed_at: {
              gte: thirtyDaysAgo,
            },
          },
        },
      },
    });

    // DEPOSITS
    // Sum all deposit amounts.
    const deposits = await this.prisma.deposits.aggregate({
      where: {
        processed_at: {
          gte: thirtyDaysAgo,
        },
      },
      _sum: {
        amount: true,
      },
    });

    const depositsValue = Number(deposits._sum.amount ?? 0);

    // CONVERSION RATE
    // Registered players = all non-test players.
    const registeredPlayers = await this.prisma.players.count({
      where: {
        is_test: false,
      },
    });

    // Converted players = non-test players who made a first deposit.
    const convertedPlayers = await this.prisma.players.count({
      where: {
        is_test: false,
        first_deposit_at: {
          not: null,
        },
      },
    });

    // Avoid division by zero when calculating percentage.
    const conversionRate =
      registeredPlayers === 0
        ? 0
        : Number(((convertedPlayers / registeredPlayers) * 100).toFixed(1));

    // BONUS
    // Sum the total cost of bonuses issued.
    const bonusCost = await this.prisma.bonuses.aggregate({
      where: {
        issued_at: {
          gte: thirtyDaysAgo,
        },
      },
      _sum: {
        bonus_cost_amount: true,
      },
    });

    const bonusCostValue = Number(bonusCost._sum.bonus_cost_amount ?? 0);

    // TECHNICAL
    // Calculate average availability percentage.

    const systemUptime = await this.prisma.technical_metrics.aggregate({
      _avg: {
        value: true,
      },
      where: {
        metric_type: 'availability',
        measured_at: {
          gte: thirtyDaysAgo,
        },
      },
    });

    const systemUptimeValue = Number((systemUptime._avg.value ?? 0).toFixed(1));

    // GEOGRAPHY
    // Get unique regions from the markets table.
    const regions = await this.prisma.markets.findMany({
      distinct: ['region'],
      select: {
        region: true,
      },
    });

    const regionsValue = regions.length;

    // GAMES
    // Count settled real-money bets as the headline games activity metric.

    const gamesActivity = await this.prisma.bets.count({
      where: {
        status: 'settled',
        is_real_money: true,
        placed_at: {
          gte: thirtyDaysAgo,
        },
      },
    });

    // RETENTION
    // Eligible players are non-test players who registered at least 30 days ago.
    const eligiblePlayers = await this.prisma.players.count({
      where: {
        is_test: false,
        registration_at: {
          lte: thirtyDaysAgo,
        },
      },
    });

    // Retained players are eligible players who had at least one
    // settled real-money bet during the last 30 days.
    const retainedPlayers = await this.prisma.players.count({
      where: {
        registration_at: {
          lte: thirtyDaysAgo,
        },
        is_test: false,
        bets: {
          some: {
            status: 'settled',
            is_real_money: true,
            placed_at: {
              gte: thirtyDaysAgo,
            },
          },
        },
      },
    });

    // Retention percentage.
    const retention =
      eligiblePlayers === 0
        ? 0
        : Number(((retainedPlayers / eligiblePlayers) * 100).toFixed(1));

    // API response returned by GET /dashboard/summary.
    return {
      revenue: {
        value: ggr,
      },
      players: {
        value: activePlayers,
      },
      deposits: {
        value: depositsValue,
      },
      conversionRate: {
        value: conversionRate,
      },
      bonus: {
        value: bonusCostValue,
      },
      technical: {
        value: systemUptimeValue,
      },
      geography: {
        value: regionsValue,
      },
      games: {
        value: gamesActivity,
      },
      retention: {
        value: retention,
      },
    };
  }
}
