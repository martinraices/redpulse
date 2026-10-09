import { activePlayersCard, depositCards } from '@/data/dashboard';
import { KpiCard } from '@/components/dashboard/kpi-card';

export default function DashboardPage() {
  return (
    <div>
      <h1 className="text-2xl font-semibold">Dashboard</h1>
      <KpiCard {...activePlayersCard} />
      <KpiCard {...depositCards} />
    </div>
  );
}
