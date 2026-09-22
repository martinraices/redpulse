import type { ReactNode } from "react";

import {
  SidebarProvider,
  SidebarInset,
} from "@/components/ui/sidebar";

export default function AuthenticatedLayout({
  children,
}: {
  children: ReactNode;
}) {
  return (
    <div className="flex min-h-screen bg-slate-950 text-white">
      <aside className="w-64 border-r border-slate-800 bg-slate-900">
        Sidebar
      </aside>
 

      <div className="flex flex-1 flex-col">
        <header className="h-16 border-b border-slate-800 bg-slate-900">
          Header
        </header>

        <main className="flex-1 p-6">
          {children}
        </main>
      </div>
  </div>


  );
}
