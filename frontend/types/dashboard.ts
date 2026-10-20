import type { LucideIcon } from 'lucide-react';

export interface SummaryCardData {
  icon: LucideIcon;
  title: string;
  format?: 'number' | 'currency' | 'percentage';
  currency?: 'GBP' | 'USD' | 'EUR';
  value: number;
  comparison: number;
  status: 'current' | 'delayed' | 'unavailable';
  targetRoute: string;
}

export interface RevenuePrimaryCardData {
  title: string;
  subtitle: string;
  ggrValue: number;
  ggrComparison: number;
  ngrValue: number;
  ngrComparison: number;
  monthlyRevenueChange: number;
  periodLabel: string;
  currency: 'GBP' | 'USD' | 'EUR';
}
export interface DashboardSummaryResponse {
  revenue: {
    value: number;
  };
  players: {
    value: number;
  };
  retention: {
    value: number;
  };
  games: {
    value: number;
  };
  bonus: {
    value: number;
  };
  technical: {
    value: number;
  };
  geography: {
    value: number;
  };
}
