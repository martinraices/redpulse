import type { LucideIcon } from 'lucide-react';

export interface SummaryCardData {
  icon: LucideIcon;
  title: string;
  currency?: string;
  value: number;
  comparison: number;
  status: 'current' | 'delayed' | 'unavailable';
  targetRoute: string;
}
