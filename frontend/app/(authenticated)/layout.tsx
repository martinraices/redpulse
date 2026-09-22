import type { ReactNode } from "react";
import { AppSidebar } from "@/components/app-sidebar";
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

  <SidebarProvider>
        <AppSidebar />
      <SidebarInset>
      <div className="flex flex-1 flex-col">
        <header className="h-16 border-b border-slate-800 bg-slate-900">
          Header
        </header>

        <main className="flex-1 p-6">
          {children}
        </main>
      </div>

  </SidebarInset>
   </SidebarProvider>

  );
}
