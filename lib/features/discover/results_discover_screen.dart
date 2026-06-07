import 'package:doanltdd/features/products/presentation/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../services/product_service.dart';
import '../../../widgets/product_card.dart';


enum _PriceFilter {
  all,
  underTwoMillion,
  fromTwoToFourMillion,
  overFourMillion,
}

class ResultsDiscoverScreen extends StatefulWidget {
  const ResultsDiscoverScreen({
    super.key,
    required this.categoryName,
    required this.itemCount,
    this.searchKeyword,
    required this.onRequireAuth,
  });

  final String categoryName;
  final int itemCount;
  final String? searchKeyword;
  final Future<bool> Function() onRequireAuth;

  @override
  State<ResultsDiscoverScreen> createState() => _ResultsDiscoverScreenState();
}

class _ResultsDiscoverScreenState extends State<ResultsDiscoverScreen> {
  String _selectedSort = 'Nổi bật';
  _PriceFilter _priceFilter = _PriceFilter.all;
  late List<ProductModel> _baseProducts;

  @override
  void initState() {
    super.initState();
    _baseProducts = const [];
  }

  List<ProductModel> _loadProducts(ProductService productService) {
    final allProducts = productService.products;

    final keyword = widget.searchKeyword?.trim().toLowerCase();
    if (keyword != null && keyword.isNotEmpty) {
      return allProducts
          .where(
            (product) =>
                product.name.toLowerCase().contains(keyword) ||
                product.badgeText.toLowerCase().contains(keyword),
          )
          .toList();
    }

    if (widget.categoryName.toLowerCase() == 'all') {
      return allProducts;
    }

    return productService.getProductsByCategory(widget.categoryName);
  }

  List<ProductModel> get _visibleProducts {
    final products = _baseProducts.where((product) {
      final price = _priceOf(product);
      switch (_priceFilter) {
        case _PriceFilter.all:
          return true;
        case _PriceFilter.underTwoMillion:
          return price < 2000000;
        case _PriceFilter.fromTwoToFourMillion:
          return price >= 2000000 && price <= 4000000;
        case _PriceFilter.overFourMillion:
          return price > 4000000;
      }
    }).toList();

    products.sort((a, b) {
      switch (_selectedSort) {
        case 'Giá thấp đến cao':
          return _priceOf(a).compareTo(_priceOf(b));
        case 'Giá cao đến thấp':
          return _priceOf(b).compareTo(_priceOf(a));
        case 'Mới nhất':
          return b.id.compareTo(a.id);
        default:
          return 0;
      }
    });

    return products;
  }

  double _priceOf(ProductModel product) {
    final normalized = product.price.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  String get _title {
    final keyword = widget.searchKeyword?.trim();
    if (keyword != null && keyword.isNotEmpty) return 'Tìm kiếm: $keyword';
    switch (widget.categoryName.toLowerCase()) {
      case 'footwear':
        return 'Giày';
      case 'apparel':
        return 'Trang phục';
      case 'equipment':
        return 'Phụ kiện';
      default:
        return widget.categoryName;
    }
  }

  @override
  Widget build(BuildContext context) {
    _baseProducts = _loadProducts(context.watch<ProductService>());
    final products = _visibleProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _title.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TÌM THẤY ${products.length} SẢN PHẨM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                    color: AppColors.neon,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildFilterButton()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildSortButton()),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Text(
                      'Không tìm thấy sản phẩm',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.6,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onProductTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return _ToolbarButton(
      icon: Icons.tune_rounded,
      label: _filterLabel,
      onTap: _showFilterSheet,
    );
  }

  Widget _buildSortButton() {
    return _ToolbarButton(
      icon: Icons.sort_rounded,
      label: _selectedSort,
      onTap: _showSortSheet,
    );
  }

  String get _filterLabel {
    switch (_priceFilter) {
      case _PriceFilter.all:
        return 'Tất cả giá';
      case _PriceFilter.underTwoMillion:
        return 'Dưới 2 triệu';
      case _PriceFilter.fromTwoToFourMillion:
        return '2 - 4 triệu';
      case _PriceFilter.overFourMillion:
        return 'Trên 4 triệu';
    }
  }

  void _showFilterSheet() {
    _showOptionSheet<_PriceFilter>(
      title: 'LỌC THEO GIÁ',
      selectedValue: _priceFilter,
      options: const {
        _PriceFilter.all: 'Tất cả giá',
        _PriceFilter.underTwoMillion: 'Dưới 2 triệu',
        _PriceFilter.fromTwoToFourMillion: '2 - 4 triệu',
        _PriceFilter.overFourMillion: 'Trên 4 triệu',
      },
      onSelected: (value) => setState(() => _priceFilter = value),
    );
  }

  void _showSortSheet() {
    _showOptionSheet<String>(
      title: 'SẮP XẾP SẢN PHẨM',
      selectedValue: _selectedSort,
      options: const {
        'Nổi bật': 'Nổi bật',
        'Giá thấp đến cao': 'Giá thấp đến cao',
        'Giá cao đến thấp': 'Giá cao đến thấp',
        'Mới nhất': 'Mới nhất',
      },
      onSelected: (value) => setState(() => _selectedSort = value),
    );
  }

  void _showOptionSheet<T>({
    required String title,
    required T selectedValue,
    required Map<T, String> options,
    required ValueChanged<T> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                ...options.entries.map((entry) {
                  final selected = entry.key == selectedValue;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      entry.value,
                      style: TextStyle(
                        color: selected
                            ? AppColors.neon
                            : AppColors.textPrimary,
                        fontWeight: selected
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ),
                    ),
                    trailing: selected
                        ? Icon(Icons.check, color: AppColors.neon)
                        : null,
                    onTap: () {
                      onSelected(entry.key);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.neon, size: 17),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
