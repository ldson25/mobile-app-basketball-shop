class CartItemModel {
  final String id;
  final String imagePath;
  final String title;
  final String size;
  final double price;
  int quantity;
  bool isChecked;

  CartItemModel({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.size,
    required this.price,
    this.quantity = 1,
    this.isChecked = false,
  });

  // Copy with method để tạo bản sao mới
  CartItemModel copyWith({
    String? id,
    String? imagePath,
    String? title,
    String? size,
    double? price,
    int? quantity,
    bool? isChecked,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}