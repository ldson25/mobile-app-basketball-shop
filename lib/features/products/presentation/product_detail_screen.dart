import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../services/cart_service.dart';
import '../../../services/favorites_service.dart';
import '../../cart/mycart.dart';
import '../../favorites/favorites.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String _selectedOption;
  int _quantity = 1;
  bool _isDescriptionExpanded = false;
  bool _isShippingExpanded = false;

  int get _selectedStock => widget.product.optionStock[_selectedOption] ?? 0;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.product.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductGallery(),
              const SizedBox(height: 24),
              _buildProductInfo(),
              const SizedBox(height: 32),
              _buildOptionSelector(),
              const SizedBox(height: 24),
              _buildQuantitySelector(),
              const SizedBox(height: 32),
              _buildTechnicalSpecs(),
              const SizedBox(height: 32),
              _buildActionButtons(),
              const SizedBox(height: 32),
              _buildExpandableSections(),
              const SizedBox(height: 32),
              _buildReviewsSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'CHI TIẾT',
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 20,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          letterSpacing: -0.5,
          color: AppColors.neon,
        ),
      ),
      centerTitle: true,
      actions: [
        Consumer<CartService>(
          builder: (context, cartService, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                ),
                if (cartService.itemCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.neon,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${cartService.itemCount}',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductGallery() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Image.asset(
                widget.product.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surface2,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                        size: 48,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildThumbnail(widget.product.imageAsset),
            _buildThumbnail(widget.product.imageAsset),
          ],
        ),
      ],
    );
  }

  Widget _buildThumbnail(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.surface2,
              child: const Icon(
                Icons.image_not_supported,
                color: AppColors.textSecondary,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 40,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -1,
            color: AppColors.textPrimary,
            height: 0.95,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.price,
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.neon,
          ),
        ),
        const SizedBox(height: 14),
        _StockBadge(quantity: widget.product.stockQuantity),
      ],
    );
  }

  Widget _buildOptionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.optionLabel.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: widget.product.category == ProductCategory.footwear ? 4 : 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: widget.product.category == ProductCategory.equipment ? 2.1 : 2.5,
          children: widget.product.options.map((option) {
            final stock = widget.product.optionStock[option] ?? 0;
            final isSelected = _selectedOption == option;
            final isAvailable = stock > 0;

            return GestureDetector(
              onTap: isAvailable
                  ? () {
                      setState(() {
                        _selectedOption = option;
                        _quantity = 1;
                      });
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.neon : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected ? AppColors.neon : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        option,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? AppColors.background
                              : isAvailable
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                        ),
                      ),
                      if (isAvailable && widget.product.options.length <= 4)
                        Text(
                          '$stock còn',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? AppColors.background.withOpacity(0.74)
                                : AppColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Text(
          'Còn $_selectedStock sản phẩm cho ${widget.product.optionLabel.toLowerCase()} $_selectedOption',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SỐ LƯỢNG',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 160,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border.withOpacity(0.35)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _quantity == 1
                    ? null
                    : () => setState(() => _quantity--),
                icon: const Icon(Icons.remove_rounded),
                color: AppColors.textPrimary,
                disabledColor: AppColors.textMuted,
              ),
              Text(
                '$_quantity',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              IconButton(
                onPressed: _quantity >= _selectedStock
                    ? null
                    : () => setState(() => _quantity++),
                icon: const Icon(Icons.add_rounded),
                color: AppColors.neon,
                disabledColor: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicalSpecs() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          _buildSpecItem('Trọng lượng', widget.product.specWeight),
          Container(width: 1, height: 40, color: AppColors.border.withOpacity(0.2)),
          _buildSpecItem('Tính năng', widget.product.specFeature),
          Container(width: 1, height: 40, color: AppColors.border.withOpacity(0.2)),
          _buildSpecItem('Chất liệu', widget.product.specMaterial),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Consumer2<CartService, FavoritesService>(
      builder: (context, cartService, favoritesService, child) {
        final isFavorite = favoritesService.isFavorite(widget.product.id);

        return Column(
          children: [
            GestureDetector(
              onTap: _selectedStock == 0
                  ? null
                  : () {
                      cartService.addToCart(
                        widget.product,
                        _selectedOption,
                        quantity: _quantity,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đã thêm ${widget.product.name} x$_quantity vào giỏ hàng (${widget.product.optionLabel}: $_selectedOption)',
                          ),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'XEM GIỎ',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: _selectedStock == 0 ? AppColors.border : AppColors.neon,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: _selectedStock == 0
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.neon.withOpacity(0.3),
                            blurRadius: 30,
                          ),
                        ],
                ),
                child: Text(
                  _selectedStock == 0 ? 'HẾT HÀNG' : 'THÊM VÀO GIỎ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: _selectedStock == 0
                        ? AppColors.textSecondary
                        : AppColors.background,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                favoritesService.toggleFavorite(widget.product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? 'Đã xóa ${widget.product.name} khỏi yêu thích'
                          : 'Đã thêm ${widget.product.name} vào yêu thích',
                    ),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'XEM YÊU THÍCH',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritesScreen(
                              onMenuTap: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.neon : AppColors.textPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isFavorite ? 'XÓA KHỎI YÊU THÍCH' : 'THÊM VÀO YÊU THÍCH',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: isFavorite ? AppColors.neon : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpandableSections() {
    return Column(
      children: [
        _ExpandableRow(
          title: 'MÔ TẢ SẢN PHẨM',
          expanded: _isDescriptionExpanded,
          onTap: () => setState(
            () => _isDescriptionExpanded = !_isDescriptionExpanded,
          ),
        ),
        if (_isDescriptionExpanded)
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Thiết kế cho lối chơi tốc độ và bứt phá. Sản phẩm tập trung vào độ thoải mái, độ bền và cảm giác kiểm soát khi vận động.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        _ExpandableRow(
          title: 'GIAO HÀNG & ĐỔI TRẢ',
          expanded: _isShippingExpanded,
          onTap: () => setState(
            () => _isShippingExpanded = !_isShippingExpanded,
          ),
        ),
        if (_isShippingExpanded)
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Hỗ trợ giao hàng toàn quốc. Sản phẩm chưa qua sử dụng được hỗ trợ đổi trả trong 30 ngày theo chính sách cửa hàng.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'ĐÁNH GIÁ',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 14),
        _ReviewSummary(),
        SizedBox(height: 12),
        _ReviewTile(
          name: 'Minh T.',
          rating: 5,
          comment:
              'Form chắc chắn, đệm êm và bám sân tốt. Rất hợp khi chơi bóng rổ ngoài trời.',
        ),
        SizedBox(height: 12),
        _ReviewTile(
          name: 'Anh K.',
          rating: 4,
          comment:
              'Thiết kế đẹp, chất liệu tốt. Nên tăng nửa size nếu chân bè ngang.',
        ),
      ],
    );
  }
}

class _ExpandableRow extends StatelessWidget {
  const _ExpandableRow({
    required this.title,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.textPrimary,
              ),
            ),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewSummary extends StatelessWidget {
  const _ReviewSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Text(
            '4.8',
            style: TextStyle(
              color: AppColors.neon,
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Stars(rating: 5),
                SizedBox(height: 6),
                Text(
                  'Dựa trên 128 đánh giá',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.name,
    required this.rating,
    required this.comment,
  });

  final String name;
  final int rating;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _Stars(rating: rating),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
          color: AppColors.neon,
          size: 18,
        );
      }),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final lowStock = quantity <= 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: lowStock
            ? AppColors.warning.withOpacity(0.12)
            : AppColors.neon.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: lowStock
              ? AppColors.warning.withOpacity(0.35)
              : AppColors.neon.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            lowStock ? Icons.error_outline_rounded : Icons.inventory_2_outlined,
            color: lowStock ? AppColors.warning : AppColors.neon,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            lowStock ? 'Chỉ còn $quantity sản phẩm' : 'Còn $quantity sản phẩm',
            style: TextStyle(
              color: lowStock ? AppColors.warning : AppColors.neon,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
