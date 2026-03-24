from pydantic import BaseModel

class Product(BaseModel):
    title: str
    price: float
    currency: str
    link: str
    rating: float | None = 0