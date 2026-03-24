from fastapi import APIRouter
from app.services.product_service import search_and_compare_products

router = APIRouter(prefix="/products", tags=["Products"])

@router.get("/search")
def search_products(query: str):
    return search_and_compare_products(query)