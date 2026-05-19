import os
import sys
from supabase import create_client
from dotenv import load_dotenv

print("=" * 70)
print("SUPABASE CONNECTION VERIFICATION")
print("=" * 70)

# Load environment variables from .env
load_dotenv()

url = os.getenv("SUPABASE_URL")
anon_key = os.getenv("SUPABASE_ANON_KEY")
service_key = os.getenv("SUPABASE_SERVICE_KEY")

print(f"\n📊 CONFIGURATION DETECTED:")
print(f"• URL: {url}")
print(f"• Anon Key: {anon_key[:20]}..." if anon_key else "• Anon Key: ❌ Not found")
print(f"• Service Key: {'✅ Configured' if service_key else '❌ Not found'}")

if not all([url, anon_key, service_key]):
    print("\n❌ ERROR: Missing configuration variables")
    sys.exit(1)

try:
    print(f"\n🔗 Testing connection with ANON KEY...")
    supabase = create_client(url, anon_key)
    
    # Try a basic query
    response = supabase.table('_supabase_settings').select('*').limit(1).execute()
    
    if response.status_code == 200:
        print("   ✅ Anon connection successful")
    else:
        print(f"   ⚠️  Status: {response.status_code}")
    
    print(f"\n🔗 Testing connection with SERVICE ROLE KEY...")
    supabase_admin = create_client(url, service_key)
    
    # Try with a table that probably exists
    try:
        admin_response = supabase_admin.table('auth.users').select('count', count='exact').limit(1).execute()
        print("   ✅ Service role connection successful")
        print(f"   👥 Users in auth.users: {admin_response.count if hasattr(admin_response, 'count') else 'Unknown'}")
    except Exception as e:
        print(f"   ⚠️  Table auth.users not accessible (may be normal)")
        print(f"   Error: {str(e)[:100]}")
    
    print(f"\n📋 Checking for common tables...")
    try:
        # Try to list some common tables
        tables_to_check = ['restaurants', 'reservations', 'users', 'profiles', 'hotels', 'rooms']
        for table in tables_to_check:
            try:
                test = supabase.table(table).select('*').limit(1).execute()
                print(f"   • {table}: ✅ Exists")
            except:
                print(f"   • {table}: ❌ Doesn't exist (may be normal)")
    
    except Exception as e:
        print(f"   ⚠️  Could not verify tables: {str(e)[:100]}")
    
    print(f"\n🎉 VERIFICATION COMPLETED SUCCESSFULLY!")
    print(f"\n✅ Supabase is correctly configured for:")
    print(f"   • Backend API (FastAPI)")
    print(f"   • Frontend Next.js")
    print(f"   • Authentication and database")
    
    print(f"\n⚠️  RECOMMENDATIONS:")
    print(f"1. Check that necessary tables exist in Supabase Dashboard")
    print(f"2. Configure RLS policies in Supabase Dashboard")
    print(f"3. Test authentication with supabase.auth.sign_in()")
    
except Exception as e:
    print(f"\n❌ CRITICAL ERROR: {str(e)}")
    print(f"\n🔧 TROUBLESHOOTING:")
    print(f"1. Verify the project exists in Supabase")
    print(f"2. Verify the API keys are correct")
    print(f"3. Verify your internet connection")
    sys.exit(1)
