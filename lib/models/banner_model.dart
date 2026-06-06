class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String imageAsset;
  final String productId;
  final bool isActive;
  final int sortOrder;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl = '',
    this.imageAsset = '',
    this.productId = '',
    this.isActive = true,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'imageAsset': imageAsset,
      'productId': productId,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      imageAsset: (json['imageAsset'] ?? '').toString(),
      productId: (json['productId'] ?? '').toString(),
      isActive: json['isActive'] != false,
      sortOrder: json['sortOrder'] is int
          ? json['sortOrder'] as int
          : int.tryParse((json['sortOrder'] ?? '0').toString()) ?? 0,
    );
  }
}
