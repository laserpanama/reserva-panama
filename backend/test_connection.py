import os
from supabase import create_client
from dotenv import load_dotenv

print("Testing Supabase Connection")
print("=" * 40)

load_dotenv()

url = os.getenv('SUPABASE_URL')
anon_key = os.getenv('SUPABASE_ANON_KEY')

print(f"URL: {url}")
print(f"Anon Key starts with 'sb_publishable_': {anon_key.startswith('sb_publishable_') if anon_key else False}")

if not url or not anon_key:
    print("❌ Missing URL or Anon Key")
    exit(1)

try:
    print("\nCreating Supabase client...")
    supabase = create_client(url, anon_key)
    print("✅ Client created successfully")
    
    print("\nTesting connection with query...")
    result = supabase.table('_supabase_settings').select('*').limit(1).execute()
    print(f"✅ Connection successful! Status: {result.status_code}")
    
except Exception as e:
    print(f"❌ Error: {e}")
