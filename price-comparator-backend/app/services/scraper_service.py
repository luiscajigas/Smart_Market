from multiprocessing.pool import ThreadPool
from app.connectors.alkosto_spider import search_product as search_alkosto
from app.connectors.exito_spider import search_product as search_exito
from app.connectors.jumbo_spider import search_product as search_jumbo
from typing import List, Generator

def run_search(func_query_tuple):
    func, query = func_query_tuple
    return func(query)

def get_all_products_stream(query: str) -> Generator[List[dict], None, None]:
    """
    Yields results from each spider as soon as they finish.
    """
    search_tasks = [
        (search_alkosto, query),
        (search_exito, query),
        (search_jumbo, query)
    ]
    
    with ThreadPool(processes=3) as pool:
        # imap_unordered returns results as they become available
        for results in pool.imap_unordered(run_search, search_tasks):
            if results:
                yield results

def get_all_products(query: str) -> List[dict]:
    # Original method for backward compatibility if needed
    all_results = []
    for results in get_all_products_stream(query):
        all_results.extend(results)
    return all_results
