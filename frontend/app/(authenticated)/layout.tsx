import type { ReactNode } from "react";
import { AppSidebar } from "@/components/app-sidebar";
import {  AppHeader } from "@/components/app-header";
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
      <AppHeader />

        <main className="flex-1 p-6">
          {children}
        </main>
      </div>

  </SidebarInset>
   </SidebarProvider>

  );
}
