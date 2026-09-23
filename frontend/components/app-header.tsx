"use client";

import { Bell, ChevronDown } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

import { DateRangePicker } from "./date-range-picker";

export function AppHeader() {
  return (
    <header className="flex h-16 items-center border-b border-white/10 bg-[#0B1726] px-6 text-white">
      <div className="ml-auto flex items-center gap-3">

        <DateRangePicker />

        <DropdownMenu>
          <DropdownMenuTrigger className="flex h-9 items-center gap-2 rounded-md border border-white/20 px-3 text-sm hover:bg-white/10">
            vs. previous month
            <ChevronDown className="h-4 w-4" />
          </DropdownMenuTrigger>

          <DropdownMenuContent align="end">
            <DropdownMenuItem>Previous month</DropdownMenuItem>
            <DropdownMenuItem>Previous year</DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>

        <button
          type="button"
          aria-label="Notifications"
          className="flex h-9 w-9 items-center justify-center rounded-md hover:bg-white/10"
        >
          <Bell className="h-5 w-5" />
        </button>

        <DropdownMenu>
          <DropdownMenuTrigger className="ml-2 flex items-center gap-2 border-l border-white/20 pl-4 hover:opacity-80">
            <Avatar>
              <AvatarImage
                src="https://github.com/shadcn.png"
                alt="Alex Smith"
                className="grayscale"
              />
              <AvatarFallback>AS</AvatarFallback>
            </Avatar>

            <span className="flex flex-col text-left text-sm leading-tight">
              <span className="font-medium">Alex Smith</span>
              <span className="text-white/60">Manager</span>
            </span>

            <ChevronDown className="ml-1 h-4 w-4" />
          </DropdownMenuTrigger>

          <DropdownMenuContent align="end">
            <DropdownMenuItem>Settings</DropdownMenuItem>
            <DropdownMenuItem>Log out</DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}


