import type {
  SummaryCardData,
  RevenuePrimaryCardData,
} from '@/types/dashboard';
import {
  Users,
  CircleEuro,
  Funnel,
  Gift,
  ShieldCheck,
  Globe,
  Gamepad,
} from 'lucide-react';

export const activePlayersCard: SummaryCardData = {
  icon: Users,
  title: 'Active Players',
  format: 'number',
  value: 24532,
  comparison: 12,
  status: 'current',
  targetRoute: '/players',
};

export const depositCard: SummaryCardData = {
  icon: CircleEuro,
  title: 'Deposits',
  format: 'currency',
  value: 892430,
  currency: 'GBP',
  comparison: 18,
  status: 'current',
  targetRoute: '/payment',
};

export const conversionRateCard: SummaryCardData = {
  icon: Funnel,
  title: 'Conversion Rate',
  format: 'percentage',
  value: 8.4,
  comparison: 0.6,
  status: 'current',
  targetRoute: '/players',
};

export const bonusCostCard: SummaryCardData = {
  icon: Gift,
  title: 'Bonus Cost',
  format: 'currency',
  value: 143230,
  currency: 'GBP',
  comparison: -6,
  status: 'current',
  targetRoute: '/bonuses',
};

export const systemUptimeCard: SummaryCardData = {
  icon: ShieldCheck,
  title: 'System Uptime',
  format: 'percentage',
  value: 99.98,
  comparison: 0.01,
  status: 'current',
  targetRoute: '/reports',
};

export const regionsCard: SummaryCardData = {
  icon: Globe,
  title: 'Regions',
  format: 'number',
  value: 18,
  comparison: 2,
  status: 'current',
  targetRoute: '/marketing',
};

export const gamesCard: SummaryCardData = {
  icon: Gamepad,
  title: 'Games',
  format: 'number',
  value: 0,
  comparison: 0,
  status: 'current',
  targetRoute: '/games',
};
export const retentionCard: SummaryCardData = {
  icon: Gamepad,
  title: 'Retention',
  format: 'percentage',
  value: 0,
  comparison: 0,
  status: 'current',
  targetRoute: '/retention',
};

export const revenuePrimaryCard: RevenuePrimaryCardData = {
  title: 'Revenue',
  subtitle: 'Gross and net gaming revenue with daily trend',
  ggrValue: 845230,
  ggrComparison: 12,
  ngrValue: 712480,
  ngrComparison: 9,
  monthlyRevenueChange: 8.4,
  periodLabel: 'Last 30 days',
  currency: 'GBP',
};
