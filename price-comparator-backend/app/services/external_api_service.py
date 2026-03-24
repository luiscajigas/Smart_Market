import requests
from app.utils.helpers import normalize_product


# ✅ Fake Store
def fetch_products_from_fake_store(query: str):
    url = "https://fakestoreapi.com/products"

    try:
        response = requests.get(url, timeout=5)

        if response.status_code != 200:
            return []

        data = response.json()
        products = []

        for item in data:
            if query.lower() in item["title"].lower():
                product = {
                    "title": item["title"],
                    "price": float(item["price"]),
                    "currency": "USD",
                    "link": item["image"],
                    "rating": item.get("rating", {}).get("rate", 0)
                }

                products.append(normalize_product(product, "FakeStore"))

        return products

    except Exception as e:
        print("ERROR FakeStore:", e)
        return []


# ✅ DummyJSON
def fetch_products_dummyjson(query: str):
    url = f"https://dummyjson.com/products/search?q={query}"

    try:
        response = requests.get(url, timeout=5)

        if response.status_code != 200:
            return []

        data = response.json()
        products = []

        for item in data.get("products", []):
            product = {
                "title": item.get("title", ""),
                "price": float(item.get("price", 0)),
                "currency": "USD",
                "link": item.get("thumbnail", ""),
                "rating": item.get("rating", 0)
            }

            products.append(normalize_product(product, "DummyJSON"))

        return products

    except Exception as e:
        print("ERROR DummyJSON:", e)
        return []


# ✅ MercadoLibre (NO rompe si falla)
def fetch_products_mercadolibre(query: str):
    url = f"https://api.mercadolibre.com/sites/MCO/search?q={query}"

    try:
        response = requests.get(url, timeout=5)

        if response.status_code != 200:
            print("MercadoLibre failed")
            return []

        data = response.json()
        products = []

        for item in data.get("results", [])[:10]:
            product = {
                "title": item.get("title", ""),
                "price": float(item.get("price", 0)),
                "currency": item.get("currency_id", "COP"),
                "link": item.get("permalink", ""),
                "rating": 0
            }

            products.append(normalize_product(product, "MercadoLibre"))

        return products

    except Exception as e:
        print("ERROR MercadoLibre:", e)
        return []