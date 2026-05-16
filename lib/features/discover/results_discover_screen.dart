import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/product_card.dart';
import '../../models/product_model.dart';
import '../products/presentation/product_detail_screen.dart';

class ResultsDiscoverScreen extends StatefulWidget {
  final String categoryName;
  final int itemCount;
  final String? searchKeyword;

  const ResultsDiscoverScreen({
    super.key,
    required this.categoryName,
    required this.itemCount,
    this.searchKeyword,
  });

  @override
  State<ResultsDiscoverScreen> createState() => _ResultsDiscoverScreenState();
}

class _ResultsDiscoverScreenState extends State<ResultsDiscoverScreen> {
  String _selectedSort = 'Featured';
  late List<ProductModel> _products;

  @override
  void initState() {
    super.initState();
    _products = ProductData.getProductsByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    String displayTitle = widget.categoryName;
    if (widget.searchKeyword != null && widget.searchKeyword!.isNotEmpty) {
      displayTitle = 'Search: ${widget.searchKeyword}';
    }

    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        displayTitle.toUpperCase(),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          letterSpacing: -1,
          color: AppColors.textPrimary,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
  // Chỉ dùng cho mobile (2 cột)
  const crossAxisCount = 2;
  const childAspectRatio = 0.6; 
  return Column(
    children: [
      // Filter and Sort Section 
      Container(
        padding: const EdgeInsets.all(16), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Số lượng items
            Text(
              '${_products.length} ITEMS FOUND',
              style: const TextStyle(
                fontSize: 11, // Giảm từ 12 xuống 11
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                color: AppColors.neon,
              ),
            ),
            
            // Search keyword nếu có
            if (widget.searchKeyword != null && widget.searchKeyword!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Showing results for "${widget.searchKeyword}"',
                  style: const TextStyle(
                    fontSize: 12, // Giảm từ 14 xuống 12
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            
            // Filter và Sort buttons
            const SizedBox(height: 10), // Giảm từ 12 xuống 10
            Row(
              children: [
                Expanded(child: _buildFilterButton()),
                const SizedBox(width: 10), // Giảm từ 12 xuống 10
                Expanded(child: _buildSortButton()),
              ],
            ),
          ],
        ),
      ),
      
      // Product Grid - Scrollable
      Expanded(
        child: _products.isEmpty
            ? const Center(
                child: Text(
                  'No products found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            : GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return ProductCard(
              product: product,
              onProductTap: () {
                // Navigation khi nhấn vào product
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      product: product,
                    ),
                  ),
                );
              },
              onFavoriteTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to favorites'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              onAddToCart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to cart'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}

// Cập nhật Filter và Sort buttons
Widget _buildFilterButton() {
  return GestureDetector(
    onTap: _showFilterDialog,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Giảm padding
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tune, color: AppColors.textSecondary, size: 16), // Giảm từ 18 xuống 16
          const SizedBox(width: 6),
          const Text(
            'FILTER',
            style: TextStyle(
              fontSize: 11, // Giảm từ 12 xuống 11
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSortButton() {
  return GestureDetector(
    onTap: _showSortDialog,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Giảm padding
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sort, color: AppColors.textSecondary, size: 16), // Giảm từ 18 xuống 16
          const SizedBox(width: 6),
          Text(
            _selectedSort.toUpperCase(),
            style: const TextStyle(
              fontSize: 10, // Giảm từ 11 xuống 10
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textPrimary,
            ),
          ),
          const Icon(Icons.expand_more, color: AppColors.textSecondary, size: 16), // Giảm từ 18 xuống 16
        ],
      ),
    ),
  );
}
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true, // Cho phép scroll nếu nội dung dài
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'FILTERS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Filter options coming soon',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neon,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('APPLY'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            ...['Featured', 'Price: Low to High', 'Price: High to Low', 'Newest'].map((sortOption) {
              return ListTile(
                title: Text(
                  sortOption,
                  style: TextStyle(
                    color: _selectedSort == sortOption ? AppColors.neon : AppColors.textPrimary,
                    fontWeight: _selectedSort == sortOption ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
                trailing: _selectedSort == sortOption
                    ? const Icon(Icons.check, color: AppColors.neon)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedSort = sortOption;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}