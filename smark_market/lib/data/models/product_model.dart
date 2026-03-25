class Product {
  final String id;
  final String name;
  final String category;
  final String imageEmoji;
  final Map<String, double> prices;
  final String unit;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.imageEmoji,
    required this.prices,
    required this.unit,
  });

  double get minPrice => prices.values.reduce((a, b) => a < b ? a : b);
  double get maxPrice => prices.values.reduce((a, b) => a > b ? a : b);
  double get savings => maxPrice - minPrice;
  String get bestSupermarket =>
      prices.entries.reduce((a, b) => a.value < b.value ? a : b).key;
}

class Supermarket {
  final String id;
  final String name;
  final String logo;
  final double distance;
  final double rating;
  final double? latitude;
  final double? longitude;

  const Supermarket({
    required this.id,
    required this.name,
    required this.logo,
    required this.distance,
    required this.rating,
    this.latitude,
    this.longitude,
  });
}

class PurchaseHistory {
  final String product;
  final String emoji;
  final String supermarket;
  final double price;
  final DateTime date;
  final int quantity;

  const PurchaseHistory({
    required this.product,
    required this.emoji,
    required this.supermarket,
    required this.price,
    required this.date,
    required this.quantity,
  });
}

class AiRecommendation {
  final String title;
  final String description;
  final String type;
  final double savingAmount;
  final String icon;

  const AiRecommendation({
    required this.title,
    required this.description,
    required this.type,
    required this.savingAmount,
    required this.icon,
  });
}