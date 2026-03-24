def convert_to_cop(price: float, currency: str):
    """
    Convert price to Colombian Pesos (COP)
    """
    if currency == "USD":
        return round(price * 4000, 2)  # tasa aproximada
    return price


def normalize_product(product: dict, source: str):
    """
    Normalize product structure
    """
    price_cop = convert_to_cop(product["price"], product["currency"])

    return {
        "title": product["title"],
        "price": product["price"],
        "currency": product["currency"],
        "price_cop": price_cop,
        "link": product["link"],
        "rating": product.get("rating", 0),
        "source": source  # 🔥 importante
    }