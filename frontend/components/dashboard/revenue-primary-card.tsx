import type { RevenuePrimaryCardData } from '@/types/dashboard';

import { ArrowDown, ArrowUp } from 'lucide-react';

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function KpiCardRevenue(card: RevenuePrimaryCardData) {
  const isGgrPositive = card.ggrComparison > 0;
  const isNgrPositive = card.ngrComparison > 0;
  const isMonthlyPositive = card.monthlyRevenueChange > 0;

  const currencyFormatter = new Intl.NumberFormat('en-GB', {
    style: 'currency',
    currency: card.currency,
    maximumFractionDigits: 0,
  });

  return (
    <Card className="w-full border-slate-800 bg-slate-950 text-white shadow-sm">
      <CardHeader>
        <div className="flex items-start justify-between gap-4">
          <div>
            <CardTitle className="text-lg font-semibold">
              {card.title}
            </CardTitle>

            <p className="mt-1 text-sm text-slate-400">{card.subtitle}</p>
          </div>

          <div className="rounded-md border border-slate-800 bg-slate-900 px-3 py-2 text-xs text-slate-300">
            {card.periodLabel}
          </div>
        </div>
      </CardHeader>

      <CardContent className="grid gap-6 md:grid-cols-3">
        <div>
          <p className="text-sm text-slate-400">GGR</p>

          <p className="text-2xl font-bold">
            {currencyFormatter.format(card.ggrValue)}
          </p>

          <div
            className={`mt-1 flex items-center gap-1 text-sm ${
              isGgrPositive ? 'text-emerald-400' : 'text-red-400'
            }`}
          >
            {isGgrPositive ? (
              <ArrowUp className="h-4 w-4" />
            ) : (
              <ArrowDown className="h-4 w-4" />
            )}

            <span>{Math.abs(card.ggrComparison)}%</span>
          </div>
        </div>

        <div>
          <p className="text-sm text-slate-400">NGR</p>

          <p className="text-2xl font-bold">
            {currencyFormatter.format(card.ngrValue)}
          </p>

          <div
            className={`mt-1 flex items-center gap-1 text-sm ${
              isNgrPositive ? 'text-emerald-400' : 'text-red-400'
            }`}
          >
            {isNgrPositive ? (
              <ArrowUp className="h-4 w-4" />
            ) : (
              <ArrowDown className="h-4 w-4" />
            )}

            <span>{Math.abs(card.ngrComparison)}%</span>
          </div>
        </div>

        <div>
          <p className="text-sm text-slate-400">Monthly Revenue Change</p>

          <div
            className={`mt-1 flex items-center gap-1 text-2xl font-bold ${
              isMonthlyPositive ? 'text-emerald-400' : 'text-red-400'
            }`}
          >
            {isMonthlyPositive ? (
              <ArrowUp className="h-5 w-5" />
            ) : (
              <ArrowDown className="h-5 w-5" />
            )}

            <span>{Math.abs(card.monthlyRevenueChange)}%</span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
