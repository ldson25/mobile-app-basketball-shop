import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String label;
  final IconData icon;
  final int itemCount;
  final String imageAsset;

  CategoryModel({
    required this.id,
    required this.name,
    required this.label,
    required this.icon,
    required this.itemCount,
    required this.imageAsset,
  });
}

// Danh sách categories mẫu
final List<CategoryModel> categories = [
  CategoryModel(
    id: '1',
    name: 'Footwear',
    label: 'FOOTWEAR',
    icon: Icons.bolt,
    itemCount: 128,
    imageAsset: 'assets/images/categories/footwear.png',
  ),
  CategoryModel(
    id: '2',
    name: 'Apparel',
    label: 'APPAREL',
    icon: Icons.checkroom,
    itemCount: 96,
    imageAsset: 'assets/images/categories/apparel.webp',
  ),
  CategoryModel(
    id: '3',
    name: 'Equipment',
    label: 'EQUIPMENT',
    icon: Icons.sports_basketball,
    itemCount: 64,
    imageAsset: 'assets/images/categories/equipment.jpg',
  ),
];