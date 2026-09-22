import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarRail,
} from "@/components/ui/sidebar"

const data = [
    {
        title:"Dashboard",
        url : "/dashboard",
    },
    {
        title:"Players",
        url : "/players",
    },
    {
        title:"Revenue",
        url : "/revenue",
    },
    {
        title:"Marketing",
        url : "/marketing",
    }
    ,{
        title:"Bonuses",
        url : "/bonuses",
    },
    {
        title:"Games",
        url : "/games",
    },
    {
        title:"Payment",
        url : "/payment",
    },
    {
        title:"Risk and Fraud",
        url : "/riskAndFraud",
    },
    {
        title:"Reports",
        url : "/reports",
    }
]
    



export function AppSidebar() {
  return (
    <Sidebar >
      <SidebarHeader>
      Red Pulse </SidebarHeader>
      <SidebarContent>
          <SidebarGroup >
            <SidebarGroupContent>
              <SidebarMenu>
                {data.map((item) => (
                  <SidebarMenuItem key={item.title}>
                    <SidebarMenuButton >
                      <a href={item.url}>{item.title}</a>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                ))}
              </SidebarMenu>
            </SidebarGroupContent>
          </SidebarGroup>
 
      </SidebarContent>
      <SidebarRail />
    </Sidebar>
  )
}
