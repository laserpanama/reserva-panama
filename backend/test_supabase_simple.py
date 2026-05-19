import os
import sys

print("Supabase Connection Test")
print("=" * 50)

# Read .env manually
def load_env_manual():
    env_vars = {}
    try:
        with open('.env', 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    env_vars[key.strip()] = value.strip()
        return env_vars
    except Exception as e:
        print(f"Error reading .env: {e}")
        return {}

env_vars = load_env_manual()

url = env_vars.get('SUPABASE_URL')
anon_key = env_vars.get('SUPABASE_ANON_KEY')
service_key = env_vars.get('SUPABASE_SERVICE_KEY')

print(f"Found {len(env_vars)} environment variables")
print(f"\nURL: {url}")
print(f"Anon Key valid: {anon_key.startswith('sb_publishable_') if anon_key else False}")
print(f"Service Key valid: {service_key.startswith('sb_secret_') if service_key else False}")

if not all([url, anon_key]):
    print("\n❌ Missing Supabase configuration")
    sys.exit(1)

try:
    from supabase import create_client
    
    print("\nCreating Supabase client...")
    supabase = create_client(url, anon_key)
    print("✅ Client created successfully")
    
    print("\nTesting connection with query...")
    result = supabase.table('_supabase_settings').select('*').limit(1).execute()
    print(f"✅ Connection successful! Status: {result.status_code}")
    
    # Try to get table list if possible
    print("\nChecking available tables...")
    try:
        # Try to get a list of tables by testing common ones
        tables = ['restaurants', 'reservations', 'users', 'profiles', 'hotels']
        for table in tables:
            try:
                test = supabase.table(table).select('*').limit(1).execute()
                print(f"  • {table}: ✅ Exists")
            except:
                print(f"  • {table}: ❌ Doesn't exist (normal for new project)")
    except:
        pass
    
except ImportError:
    print("❌ supabase module not installed")
    print("Try: python -m pip install supabase")
    sys.exit(1)
except Exception as e:
    print(f"\n❌ Connection error: {e}")
    sys.exit(1)

print("\n🎉 Test completed successfully!")
