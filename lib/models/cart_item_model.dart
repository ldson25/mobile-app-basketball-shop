class CartItemModel {
  final String id;
  final String imagePath;
  final String? imageUrl;
  final String? productId;
  final String title;
  final String size;
  final double price;
  int quantity;
  bool isChecked;

  CartItemModel({
    required this.id,
    required this.imagePath,
    this.imageUrl,
    this.productId,
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
    String? imageUrl,
    String? productId,
    String? title,
    String? size,
    double? price,
    int? quantity,
    bool? isChecked,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'productId': productId,
      'title': title,
      'size': size,
      'price': price,
      'quantity': quantity,
      'isChecked': isChecked,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    return CartItemModel(
      id: (json['id'] ?? '').toString(),
      imagePath: (json['imagePath'] ?? '').toString(),
      imageUrl: json['imageUrl'] as String?,
      productId: json['productId'] as String?,
      title: (json['title'] ?? '').toString(),
      size: (json['size'] ?? '').toString(),
      price: rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse(rawPrice.toString()) ?? 0,
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse((json['quantity'] ?? '1').toString()) ?? 1,
      isChecked: json['isChecked'] == true,
    );
  }
}
