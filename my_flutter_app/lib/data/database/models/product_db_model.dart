class ProductDbModel {
  final int? id;
  final String productId;
  final String category;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int page;
  final DateTime createdAt;

  ProductDbModel({
    this.id,
    required this.productId,
    required this.category,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.page,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'category': category,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'page': page,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ProductDbModel.fromMap(Map<String, dynamic> map) {
    return ProductDbModel(
      id: map['id'],
      productId: map['product_id'],
      category: map['category'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['image_url'],
      page: map['page'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}