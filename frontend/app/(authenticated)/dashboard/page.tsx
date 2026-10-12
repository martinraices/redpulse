import {
  activePlayersCard,
  depositCard,
  conversionRateCard,
  bonusCostCard,
  systemUptimeCard,
  regionsCard,
} from '@/data/dashboard';
import { KpiCard } from '@/components/dashboard/kpi-card';

export default function DashboardPage() {
  return (
    <div>
      <h1 className="text-2xl font-semibold">Dashboard</h1>
      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-6">
        <KpiCard {...activePlayersCard} />
        <KpiCard {...depositCard} />
        <KpiCard {...conversionRateCard} />
        <KpiCard {...bonusCostCard} />
        <KpiCard {...systemUptimeCard} />
        <KpiCard {...regionsCard} />
      </div>
    </div>
  );
}
