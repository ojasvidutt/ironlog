// Vercel API route - proxies Supabase calls server-side
// Your keys stay hidden in Vercel environment variables

export default async function handler(req, res) {
  const SUPABASE_URL = process.env.SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_KEY;
  
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, PATCH, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Prefer');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  // Extract the Supabase endpoint from the URL
  // /api/proxy/exercises -> exercises
  const path = req.url.split('/proxy/')[1]?.split('?')[0] || '';
  const supabaseUrl = `${SUPABASE_URL}/rest/v1/${path}`;

  const options = {
    method: req.method,
    headers: {
      'Content-Type': 'application/json',
      'apikey': SUPABASE_KEY,
      'Authorization': `Bearer ${SUPABASE_KEY}`,
      'Prefer': req.method === 'POST' ? 'return=representation' : 'return=minimal'
    }
  };

  if (req.method === 'POST' || req.method === 'PATCH') {
    options.body = JSON.stringify(req.body);
  }

  // Forward query params
  const queryParams = new URLSearchParams(req.query).toString();
  const finalUrl = queryParams ? `${supabaseUrl}?${queryParams}` : supabaseUrl;

  try {
    const response = await fetch(finalUrl, options);
    
    if (!response.ok) {
      const error = await response.text();
      return res.status(response.status).json({ error });
    }

    const data = await response.text();
    return res.status(200).json(data ? JSON.parse(data) : {});
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}