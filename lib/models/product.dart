class Product {
  final String id;
  final String code;
  final String name;
  final String category;
  final String description;
  final double price;
  final double oldPrice;
  final String image;
  final String tag;
  final double rating;
  final int reviews;

  const Product({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.image,
    this.tag = '',
    this.rating = 4.8,
    this.reviews = 120,
  });

  int get discount => oldPrice > price ? (((oldPrice - price) / oldPrice) * 100).round() : 0;
}
