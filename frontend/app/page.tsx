import Image from "next/image";
import { Button } from "@/components/ui/button";

export default function Home() {
  return (
<main className="flex min-h-screen items-center justify-center bg-slate-950 text-white">
  <div className="text-center">
    <h1 className="text-4xl font-bold">Red Pulse</h1>

    <p className="mt-3 text-slate-400">
      Management Analytics Dashboard
    </p>

    <div className="mt-6">
      <Button>Click here</Button>
    </div>
  </div>
</main>
  );
}