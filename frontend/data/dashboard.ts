import type { SummaryCardData } from '@/types/dashboard';
import { Users } from 'lucide-react';

export const activePlayersCard: SummaryCardData = {
  icon: Users,
  title: 'Active Players',
  value: 24532,
  comparison: 12,
  status: 'current',
  targetRoute: '/players',
};
