from supabase import create_client
from app.core.config import SUPABASE_URL, SUPABASE_KEY
from datetime import datetime

# Validate credentials
if not SUPABASE_URL or not SUPABASE_KEY:
    raise Exception("Supabase credentials are missing in .env")

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)


def save_search_results(query, results):
    # ✅ Avoid inserting empty data
    if not results:
        print("No results to save in database")
        return

    data = []

    for item in results:
        data.append({
            "query": query,
            "title": item.get("title"),
            "price": item.get("price"),
            "currency": item.get("currency"),
            "link": item.get("link"),
            "score": item.get("score"),
            "created_at": datetime.utcnow().isoformat()
        })

    try:
        response = supabase.table("results").insert(data).execute()
        print("Data saved successfully")
    except Exception as e:
        print("Error saving to Supabase:", e)


def delete_old_results():
    try:
        supabase.rpc("delete_old_results").execute()
        print("Old data deleted")
    except Exception as e:
        print("Error deleting old data:", e)