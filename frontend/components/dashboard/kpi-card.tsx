import type { SummaryCardData } from '@/types/dashboard';

import { ArrowUp } from 'lucide-react';
import { ArrowDown } from 'lucide-react';

import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';

export function KpiCard(card: SummaryCardData) {
  const Icon = card.icon;
  return (
    <div>
      <Card>
        <CardHeader>
          <CardTitle>
            <Icon />
            {card.title}
          </CardTitle>
        </CardHeader>
        <CardContent>
          <p>{card.value}</p>
          <p>
            {card.comparison > 0 ? <ArrowUp /> : <ArrowDown />}
            {card.comparison}%
          </p>
          <p>{card.status}</p>
        </CardContent>
        <CardFooter>
          <CardAction>{card.targetRoute}</CardAction>
        </CardFooter>
      </Card>
    </div>
  );
}
