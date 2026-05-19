import os

print("Testing environment variables")
print("=" * 40)

# Manually read .env file
env_vars = {}
try:
    with open('.env', 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                key, value = line.split('=', 1)
                env_vars[key.strip()] = value.strip()
except Exception as e:
    print(f"Error reading .env: {e}")
    exit(1)

print(f"Found {len(env_vars)} environment variables")

# Check key variables
url = env_vars.get('SUPABASE_URL', '')
anon_key = env_vars.get('SUPABASE_ANON_KEY', '')
service_key = env_vars.get('SUPABASE_SERVICE_KEY', '')

print(f"\nSUPABASE_URL: {url}")
print(f"SUPABASE_ANON_KEY (first 20): {anon_key[:20] if anon_key else 'None'}")
print(f"SUPABASE_SERVICE_KEY (first 20): {service_key[:20] if service_key else 'None'}")

print(f"\n✅ Anon key starts with 'sb_publishable_': {anon_key.startswith('sb_publishable_') if anon_key else False}")
print(f"✅ Service key starts with 'sb_secret_': {service_key.startswith('sb_secret_') if service_key else False}")
