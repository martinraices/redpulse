
// components/date-range-picker.tsx
"use client";

import { useState } from "react";
import { format, subDays } from "date-fns";
import type { DateRange } from "react-day-picker";
import { CalendarDays, ChevronDown } from "lucide-react";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";

export function DateRangePicker() {
  const today = new Date()
  const [dateRange, setDateRange] = useState<DateRange | undefined>({
    from: subDays(today, 30),
    to: today,
  });

  return (
    <Popover>
      <PopoverTrigger className="flex h-9 items-center gap-2 rounded-md border border-white/20 px-3 text-sm text-white hover:bg-white/10">
        <CalendarDays className="h-4 w-4" />

        {dateRange?.from
          ? `${format(dateRange.from, "MMM d, yyyy")} – ${
              dateRange.to
                ? format(dateRange.to, "MMM d, yyyy")
                : "Select end date"
            }`
          : "Select dates"}

        <ChevronDown className="h-4 w-4" />
      </PopoverTrigger>

      <PopoverContent className="w-auto p-0" align="end">
        <Calendar
          mode="range"
          defaultMonth={dateRange?.from}
          selected={dateRange}
          onSelect={setDateRange}
          numberOfMonths={2}
        />
      </PopoverContent>
    </Popover>
  );
}