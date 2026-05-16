// lib/features/product/presentation/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/cart_service.dart';
import '../../../services/favorites_service.dart';
import '../../../models/product_model.dart';
import '../../cart/mycart.dart';
import '../../favorites/favorites.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = '10';
  bool _isDescriptionExpanded = false;
  bool _isShippingExpanded = false;

  final List<String> _sizes = ['8', '9', '10', '11', '12', '13'];

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
              _buildSizeSelector(),
              const SizedBox(height: 32),
              _buildTechnicalSpecs(),
              const SizedBox(height: 32),
              _buildActionButtons(),
              const SizedBox(height: 32),
              _buildExpandableSections(),
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
        'DISCOVERY',
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
        // Cart icon với badge
        Consumer<CartService>(
          builder: (context, cartService, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
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
        // Main image
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
        // Thumbnail grid
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
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT SIZE (US)',
          style: TextStyle(
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
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: _sizes.map((size) {
            final isSelected = _selectedSize == size;
            return GestureDetector(
              onTap: () => setState(() => _selectedSize = size),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.neon : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected ? AppColors.neon : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    size,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.background : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
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
          _buildSpecItem('Weight', '340G'),
          Container(
            width: 1,
            height: 40,
            color: AppColors.border.withOpacity(0.2),
          ),
          _buildSpecItem('Cushion', 'NITRO-F'),
          Container(
            width: 1,
            height: 40,
            color: AppColors.border.withOpacity(0.2),
          ),
          _buildSpecItem('Material', 'ARMOR-M'),
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
            // Add to Cart button
            GestureDetector(
              onTap: () {
                cartService.addToCart(widget.product, _selectedSize);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.product.name} added to cart (Size $_selectedSize)'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'VIEW CART',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
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
                  color: AppColors.neon,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neon.withOpacity(0.3),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: const Text(
                  'ADD TO CART',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Wishlist button
            GestureDetector(
              onTap: () {
                favoritesService.toggleFavorite(widget.product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? '${widget.product.name} removed from favorites'
                          : '${widget.product.name} added to favorites',
                    ),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'VIEW FAVORITES',
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
                      isFavorite ? 'REMOVE FROM WISHLIST' : 'ADD TO WISHLIST',
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
        // Description section
        GestureDetector(
          onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
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
                const Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  _isDescriptionExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_isDescriptionExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: const Text(
              'Engineered for the aggressive playmaker. The Bolt V1 features a dual-density nitrogen-infused midsole and 360-degree lock-down system.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        // Shipping section
        GestureDetector(
          onTap: () => setState(() => _isShippingExpanded = !_isShippingExpanded),
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
                const Text(
                  'SHIPPING & RETURNS',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  _isShippingExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_isShippingExpanded)
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Free shipping on orders over \$100. 30-day return policy for unworn items.',
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
}