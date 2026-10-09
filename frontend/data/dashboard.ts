import type { SummaryCardData } from '@/types/dashboard';
import { Users } from 'lucide-react';
import { CircleEuro } from 'lucide-react';

export const activePlayersCard: SummaryCardData = {
  icon: Users,
  title: 'Active Players',
  value: 24532,
  comparison: 12,
  status: 'current',
  targetRoute: 'View details',
};

export const depositCards: SummaryCardData = {
  icon: CircleEuro,
  title: 'Deposits Players',
  currency: '£',
  value: 892430,
  comparison: 18,
  status: 'current',
  targetRoute: 'View details',
};
