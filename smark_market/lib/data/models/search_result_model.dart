class ProductResult {
  final String name;
  final String? brand;
  final double price;
  final double? oldPrice;
  final double? discount;
  final String currency;
  final List<String> images;
  final String? description;
  final String? stock;
  final String? category;
  final String source;
  final String? url;
  final String? sku;
  final String? productId;

  ProductResult({
    required this.name,
    this.brand,
    required this.price,
    this.oldPrice,
    this.discount,
    required this.currency,
    required this.images,
    this.description,
    this.stock,
    this.category,
    required this.source,
    this.url,
    this.sku,
    this.productId,
  });

  factory ProductResult.fromJson(Map<String, dynamic> json) {
    return ProductResult(
      name: json['name'] ?? '',
      brand: json['brand'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['old_price'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      currency: json['currency'] ?? '',
      images: (json['images'] as List?)?.map((e) => e as String).toList() ?? [],
      description: json['description'],
      stock: json['stock'],
      category: json['category'],
      source: json['source'] ?? 'Desconocido',
      url: json['url'],
      sku: json['sku'],
      productId: json['product_id'],
    );
  }
}

class SearchResponse {
  final String query;
  final List<ProductResult> results;

  SearchResponse({
    required this.query,
    required this.results,
  });

  factory SearchResponse.fromList(List<dynamic> list, String query) {
    return SearchResponse(
      query: query,
      results: list
          .map((e) => ProductResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
