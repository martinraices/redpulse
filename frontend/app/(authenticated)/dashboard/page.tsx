import {
  activePlayersCard,
  depositCard,
  conversionRateCard,
  bonusCostCard,
  systemUptimeCard,
  regionsCard,
  revenuePrimaryCard,
  gamesCard,
  retentionCard,
} from '@/data/dashboard';
import { KpiCard } from '@/components/dashboard/kpi-card';
import { KpiCardRevenue } from '@/components/dashboard/revenue-primary-card';

export default async function DashboardPage() {
  const response = await fetch('http://backend:3001/dashboard/summary');
  const summary = await response.json();
  return (
    <div>
      <h1 className="text-2xl font-semibold">Dashboard</h1>

      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-6">
        <KpiCard {...activePlayersCard} value={summary.players.value} />
        <KpiCard {...bonusCostCard} value={summary.bonus.value} />
        <KpiCard {...depositCard} value={summary.deposits.value} />
        <KpiCard {...conversionRateCard} value={summary.conversionRate.value} />
        <KpiCard {...systemUptimeCard} value={summary.technical.value} />
        <KpiCard {...retentionCard} value={summary.retention.value} />
      </div>

      <div className="mt-6 grid gap-4 xl:grid-cols-4">
        <div className="xl:col-span-3">
          <KpiCardRevenue
            {...revenuePrimaryCard}
            ggrValue={summary.revenue.value}
          />
        </div>

        <div className="xl:col-span-1">
          <KpiCard {...gamesCard} value={summary.games.value} />
        </div>
      </div>
      <div className="mt-6">
        <KpiCard {...regionsCard} value={summary.geography.value} />
      </div>
    </div>
  );
}
