def calculate_score(product):
    price_score = 1 / (product["price_cop"] + 1)
    rating_score = product.get("rating", 0)

    return (price_score * 0.6) + (rating_score * 0.4)


def compare_products(products):
    for product in products:
        product["score"] = calculate_score(product)

    sorted_products = sorted(products, key=lambda x: x["score"], reverse=True)

    return {
        "best_option": sorted_products[0] if sorted_products else None,
        "cheapest": min(products, key=lambda x: x["price_cop"]) if products else None,
        "results": sorted_products
    }