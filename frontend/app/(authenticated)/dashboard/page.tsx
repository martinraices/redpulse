import { activePlayersCard } from '@/data/dashboard';

export default function DashboardPage() {
  const Icon = activePlayersCard.icon;
  return (
    <div>
      <h1 className="text-2xl font-semibold">Dashboard</h1>
      <Icon />
      <p>{activePlayersCard.title}</p>
      <p>{activePlayersCard.value}</p>
    </div>
  );
}
