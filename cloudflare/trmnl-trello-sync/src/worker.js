/**
 * TRMNL Trello Sync — Cloudflare Worker
 *
 * Polling endpoint for a TRMNL private plugin. Returns Trello card data as JSON.
 * Authenticate requests by setting the Authorization header in the TRMNL plugin config:
 *   Authorization: Bearer <PLUGIN_TOKEN>
 *
 * Secrets (set via `wrangler secret put`):
 *   TRELLO_API_KEY, TRELLO_TOKEN, TRELLO_LIST_IDS, PLUGIN_TOKEN
 *
 * Vars (set in wrangler.toml or dashboard):
 *   TRELLO_MAX_CARDS, TZ
 */

const MAX_TITLE_LENGTH = 60;
const DEFAULT_MAX_CARDS = 6;

function validateEnv(env) {
  const required = ['TRELLO_API_KEY', 'TRELLO_TOKEN', 'TRELLO_LIST_IDS', 'PLUGIN_TOKEN'];
  const missing = required.filter(k => !env[k]);
  if (missing.length > 0) {
    throw new Error(`Missing required secrets/vars: ${missing.join(', ')}`);
  }
}

function authenticate(request, env) {
  const header = request.headers.get('Authorization') ?? '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  return token === env.PLUGIN_TOKEN;
}

function parseListConfigs(env) {
  const ids = env.TRELLO_LIST_IDS.split(',').map(s => s.trim());
  const max = parseInt(env.TRELLO_MAX_CARDS, 10) || DEFAULT_MAX_CARDS;
  return ids.map(id => ({ id, max }));
}

async function fetchList(listId, env) {
  const url = `https://api.trello.com/1/lists/${listId}?key=${env.TRELLO_API_KEY}&token=${env.TRELLO_TOKEN}&fields=name&cards=open&card_fields=name,labels,pos`;
  const response = await fetch(url);

  if (!response.ok) {
    if (response.status === 401) throw new Error('Trello authentication failed. Check TRELLO_API_KEY and TRELLO_TOKEN.');
    if (response.status === 404) throw new Error(`Trello list not found: ${listId}`);
    throw new Error(`Trello API error: ${response.status} ${response.statusText}`);
  }

  const data = await response.json();
  return {
    name: data.name,
    cards: data.cards.sort((a, b) => a.pos - b.pos)
  };
}

function transformCard(card) {
  const emoji = card.labels?.[0]?.name.replace(/\s+[A-Za-z].*$/, '').trim() ?? '';
  let title = card.name;
  if (title.length > MAX_TITLE_LENGTH) {
    title = title.substring(0, MAX_TITLE_LENGTH - 3) + '...';
  }
  return { title, emoji };
}

function deduplicateCards(cards) {
  const seen = new Set();
  return cards.filter(card => {
    if (seen.has(card.name)) return false;
    seen.add(card.name);
    return true;
  });
}

function formatTimestamp(date, tz) {
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: tz || 'America/Los_Angeles',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
    timeZoneName: 'short'
  }).formatToParts(date);
  const get = type => parts.find(p => p.type === type)?.value ?? '';
  return `${get('hour')}:${get('minute')} ${get('timeZoneName')}`;
}

async function buildPayload(env) {
  const listConfigs = parseListConfigs(env);
  const listData = await Promise.all(listConfigs.map(cfg => fetchList(cfg.id, env)));

  const lists = listConfigs.map((cfg, i) => {
    const { name, cards } = listData[i];
    const deduped = deduplicateCards(cards);
    const items = deduped.slice(0, cfg.max).map(transformCard);
    return { title: name, count: items.length, items };
  });

  return { lists, updated_at: formatTimestamp(new Date(), env.TZ) };
}

export default {
  async fetch(request, env, _ctx) {
    validateEnv(env);

    if (!authenticate(request, env)) {
      return new Response('Unauthorized', { status: 401 });
    }

    try {
      const payload = await buildPayload(env);
      const cardCount = payload.lists.reduce((sum, l) => sum + l.count, 0);
      console.log(`OK: ${payload.lists.length} lists, ${cardCount} cards, updated_at=${payload.updated_at}`);
      return Response.json(payload);
    } catch (err) {
      console.error(`Error: ${err.message}`);
      return new Response(err.message, { status: 500 });
    }
  }
};
