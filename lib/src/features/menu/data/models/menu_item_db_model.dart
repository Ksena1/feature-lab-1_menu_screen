class MenuItemDbModel {
  final int? id;
  final String itemId;
  final String categoryId;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final int page;
  final DateTime createdAt;

  MenuItemDbModel({
    this.id,
    required this.itemId,
    required this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.page,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_id': itemId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'page': page,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory MenuItemDbModel.fromMap(Map<String, dynamic> map) {
    return MenuItemDbModel(
      id: map['id'],
      itemId: map['item_id'],
      categoryId: map['category_id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['image_url'],
      page: map['page'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}