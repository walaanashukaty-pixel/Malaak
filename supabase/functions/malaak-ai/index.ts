import 'jsr:@supabase/functions-js/edge-runtime.d.ts';

import { deterministicFallback, requestStructuredCoaching, safetyPayload } from './coach.ts';
import { deriveCatalogContextFlags, loadEligibleInterventions } from './catalog.ts';
import { persistCoachingEvidence } from './formulation_repository.ts';
import { refreshJourneyPlanForUser, suspendJourneyPlanForSafety } from './journey_repository.ts';
import { routeMessage } from './router.ts';

const jsonHeaders = { 'Content-Type': 'application/json; charset=utf-8' };

function decodeJwtPayload(token: string): Record<string, unknown> | null {
  try {
    const part = token.split('.')[1] ?? '';
    const normalized = part.replace(/-/g, '+').replace(/_/g, '/').padEnd(Math.ceil(part.length / 4) * 4, '=');
    return JSON.parse(atob(normalized));
  } catch {
    return null;
  }
}

Deno.serve(async (req: Request) => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'method_not_allowed' }), { status: 405, headers: jsonHeaders });
  }

  const authorization = req.headers.get('Authorization') ?? '';
  if (!authorization.startsWith('Bearer ')) {
    return new Response(JSON.stringify({ error: 'authentication_required' }), { status: 401, headers: jsonHeaders });
  }
  const jwtPayload = decodeJwtPayload(authorization.slice(7));
  if (jwtPayload?.role !== 'authenticated' || typeof jwtPayload?.sub !== 'string') {
    return new Response(JSON.stringify({ error: 'authenticated_user_required' }), { status: 401, headers: jsonHeaders });
  }

  let body: { message?: unknown; context?: unknown };
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: 'invalid_json' }), { status: 400, headers: jsonHeaders });
  }

  const message = typeof body.message === 'string' ? body.message.trim() : '';
  if (!message) {
    return new Response(JSON.stringify({ error: 'message_required' }), { status: 400, headers: jsonHeaders });
  }

  const route = routeMessage(message, body.context ?? {});
  if (route.mode === 'safety') {
    const turn = safetyPayload(route);
    try {
      await suspendJourneyPlanForSafety(jwtPayload.sub);
    } catch (error) {
      console.error('Malaak journey safety suspension failed', error);
    }
    return new Response(JSON.stringify({ mode: 'safety', reply: turn.reply, turn }), { status: 200, headers: jsonHeaders });
  }

  const flags = deriveCatalogContextFlags(message, body.context ?? {});
  const eligible = await loadEligibleInterventions(route, flags);
  const apiKey = Deno.env.get('OPENAI_API_KEY') ?? '';

  const turn = apiKey
    ? await requestStructuredCoaching({
        apiKey,
        model: Deno.env.get('MALAAK_OPENAI_MODEL') ?? 'gpt-5-mini',
        message,
        context: body.context ?? {},
        route,
        eligible,
      })
    : deterministicFallback(route, eligible);

  try {
    await persistCoachingEvidence({
      userId: jwtPayload.sub,
      route,
      turn,
    });
    await refreshJourneyPlanForUser(jwtPayload.sub);
  } catch (error) {
    // Coaching remains available if evidence persistence is temporarily unavailable.
    // Never retry by trusting identity or evidence fields from the client payload.
    console.error('Malaak evidence persistence failed', error);
  }

  return new Response(
    JSON.stringify({ mode: turn.mode, reply: turn.reply, turn }),
    { status: 200, headers: jsonHeaders },
  );
});
