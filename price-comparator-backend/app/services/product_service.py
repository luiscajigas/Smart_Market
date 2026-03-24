from app.services.external_api_service import (
    fetch_products_from_fake_store,
    fetch_products_dummyjson,
    fetch_products_mercadolibre
)
from app.services.comparison_service import compare_products
from app.database.supabase_client import save_search_results


def search_and_compare_products(query: str):
    products = []

    # 🔎 APIs
    products.extend(fetch_products_mercadolibre(query))
    products.extend(fetch_products_dummyjson(query))
    products.extend(fetch_products_from_fake_store(query))

    print("TOTAL PRODUCTS:", len(products))

    if not products:
        return {
            "query": query,
            "message": "No products found",
            "results": []
        }

    # 🧠 Comparar
    comparison = compare_products(products)

    # 💾 Guardar
    if comparison.get("results"):
        save_search_results(query, comparison["results"])

    return {
        "query": query,
        "best_option": comparison.get("best_option"),
        "cheapest": comparison.get("cheapest"),
        "results": comparison.get("results", [])
    }