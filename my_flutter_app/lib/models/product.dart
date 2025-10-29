class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final String? imageUrl;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.categoryId,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      category: json['category_name'] ?? '',
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
    );
  }
}

class ProductResponse {
  final List<Product> products;
  final int totalCount;

  ProductResponse({
    required this.products,
    required this.totalCount,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: (json['products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
      totalCount: json['total_count'],
    );
  }
}