class CategoryDbModel {
  final int? id;
  final String categoryId;
  final String name;
  final String? imageUrl;
  final DateTime createdAt;

  CategoryDbModel({
    this.id,
    required this.categoryId,
    required this.name,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'image_url': imageUrl,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CategoryDbModel.fromMap(Map<String, dynamic> map) {
    return CategoryDbModel(
      id: map['id'],
      categoryId: map['category_id'],
      name: map['name'],
      imageUrl: map['image_url'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}
