import  {LayoutDashboard,
  Users,
  Gamepad2,
  Gift,
  BarChart3,
  Megaphone,
  CreditCardCheck,
  Shield,
  FileText,
} from "lucide-react";

export const navigationItems  = [
    {
        title:"Dashboard",
        url : "/dashboard",
        icon:LayoutDashboard, 
    },
    {
        title:"Players",
        url : "/players",
        icon:Users, 
    },
    {
        title:"Revenue",
        url : "/revenue",
        icon:BarChart3, 
    },
    {
        title:"Marketing",
        url : "/marketing",
        icon:Megaphone, 
    }
    ,{
        title:"Bonuses",
        url : "/bonuses",
        icon:Gift, 
    },
    {
        title:"Games",
        url : "/games",
        icon:Gamepad2, 
    },
    {
        title:"Payment",
        url : "/payment",
        icon:CreditCardCheck, 
    },
    {
        title:"Risk and Fraud",
        url : "/riskAndFraud",
        icon:  Shield, 
    },
    {
        title:"Reports",
        url : "/reports",
        icon:FileText, 
    }
]