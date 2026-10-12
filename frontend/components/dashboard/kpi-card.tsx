import type { SummaryCardData } from '@/types/dashboard';

import { ArrowDown, ArrowUp } from 'lucide-react';
import Link from 'next/link';

import {
  Card,
  CardAction,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';

export function KpiCard(card: SummaryCardData) {
  const Icon = card.icon;
  const isPositive = card.comparison > 0;

  return (
    <Card className="w-full border-slate-800 bg-slate-950 text-white shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle className="flex items-center gap-2 text-sm font-medium text-slate-300">
          <div className="rounded-md bg-slate-900 p-2">
            <Icon className="h-4 w-4 text-blue-400" />
          </div>

          {card.title}
        </CardTitle>
      </CardHeader>

      <CardContent className="space-y-3">
        <p className="text-2xl font-bold tracking-tight text-white">
          {card.value.toLocaleString()}
        </p>

        <div
          className={`flex items-center gap-1 text-sm font-medium ${
            isPositive ? 'text-emerald-400' : 'text-red-400'
          }`}
        >
          {isPositive ? (
            <ArrowUp className="h-4 w-4" />
          ) : (
            <ArrowDown className="h-4 w-4" />
          )}

          <span>{Math.abs(card.comparison)}%</span>
        </div>

        <p className="text-xs text-slate-500">vs. previous month</p>

        <p className="text-xs capitalize text-slate-400">{card.status}</p>
      </CardContent>

      <CardFooter className="border-t border-slate-800 pt-4">
        <CardAction>
          <Link
            href={card.targetRoute}
            className="text-sm font-medium text-slate-300 transition-colors hover:text-white"
          >
            View details
          </Link>
        </CardAction>
      </CardFooter>
    </Card>
  );
}
