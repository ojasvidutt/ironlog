// Supabase public configuration
// This is safe to expose - uses Row Level Security (RLS) for data protection
const SUPABASE_URL = 'https://cjiwdtllhqawscrmliqv.supabase.co';
const SUPABASE_KEY = 'sb_publishable_CmV2W6RcHM_gGFuQD4MbXQ_vRK1Tj5i';

// Initialize Supabase client
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
