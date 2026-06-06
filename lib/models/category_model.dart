import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String label;
  final String iconKey;
  final int itemCount;
  final String imageAsset;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.label,
    required this.iconKey,
    required this.itemCount,
    required this.imageAsset,
    this.isActive = true,
  });

  IconData get icon {
    switch (iconKey) {
      case 'checkroom':
        return Icons.checkroom;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'bolt':
      default:
        return Icons.bolt;
    }
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? label,
    String? iconKey,
    int? itemCount,
    String? imageAsset,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      iconKey: iconKey ?? this.iconKey,
      itemCount: itemCount ?? this.itemCount,
      imageAsset: imageAsset ?? this.imageAsset,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'iconKey': iconKey,
      'itemCount': itemCount,
      'imageAsset': imageAsset,
      'isActive': isActive,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      iconKey: (json['iconKey'] ?? 'bolt').toString(),
      itemCount: json['itemCount'] is int
          ? json['itemCount'] as int
          : int.tryParse((json['itemCount'] ?? '0').toString()) ?? 0,
      imageAsset: (json['imageAsset'] ?? '').toString(),
      isActive: json['isActive'] != false,
    );
  }
}

final List<CategoryModel> categories = [
  const CategoryModel(
    id: '1',
    name: 'Footwear',
    label: 'FOOTWEAR',
    iconKey: 'bolt',
    itemCount: 128,
    imageAsset: 'assets/images/categories/footwear.png',
  ),
  const CategoryModel(
    id: '2',
    name: 'Apparel',
    label: 'APPAREL',
    iconKey: 'checkroom',
    itemCount: 96,
    imageAsset: 'assets/images/categories/apparel.webp',
  ),
  const CategoryModel(
    id: '3',
    name: 'Equipment',
    label: 'EQUIPMENT',
    iconKey: 'sports_basketball',
    itemCount: 64,
    imageAsset: 'assets/images/categories/equipment.jpg',
  ),
];
