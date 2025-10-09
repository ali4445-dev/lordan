import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

const LORDAN_CORE_URL = Deno.env.get("LORDAN_CORE_URL")!;
const LORDAN_PUBLIC_KEY = Deno.env.get("LORDAN_PUBLIC_KEY")!;
const LORDAN_PREMIUM_KEY = Deno.env.get("LORDAN_PREMIUM_KEY")!;

serve(async (req: { json: () => any; }) => {
  try {
    const body = await req.json();
    const plan = (body.plan || "free").toLowerCase();
    const apiKey = plan === "premium" ? LORDAN_PREMIUM_KEY : LORDAN_PUBLIC_KEY;

    const r = await fetch(LORDAN_CORE_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-plan": plan,
        "x-lordan-key": apiKey,
      },
      body: JSON.stringify({
        message: body.message,
        mode: body.mode || "text",
        locale: body.locale || "en-US",
      }),
    });

    const data = await r.text();
    return new Response(data, {
      status: r.status,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response(JSON.stringify({ ok: false, error: String(e) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
