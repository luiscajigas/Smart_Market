class ProductResult {
  final String title;
  final double price;
  final String currency;
  final String link;
  final double score;

  ProductResult({
    required this.title,
    required this.price,
    required this.currency,
    required this.link,
    required this.score,
  });

  factory ProductResult.fromJson(Map<String, dynamic> json) {
    return ProductResult(
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      link: json['link'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SearchResponse {
  final String query;
  final Map<String, dynamic>? bestOption;
  final Map<String, dynamic>? cheapest;
  final List<ProductResult> results;

  SearchResponse({
    required this.query,
    this.bestOption,
    this.cheapest,
    required this.results,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      query: json['query'] ?? '',
      bestOption: json['best_option'],
      cheapest: json['cheapest'],
      results: (json['results'] as List?)
              ?.map((e) => ProductResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
