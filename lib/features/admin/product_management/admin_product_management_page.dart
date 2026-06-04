import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../presentation/widgets/admin_widgets.dart';

class AdminProductManagementPage extends StatefulWidget {
  const AdminProductManagementPage({super.key});

  @override
  State<AdminProductManagementPage> createState() =>
      _AdminProductManagementPageState();
}

class _AdminProductManagementPageState
    extends State<AdminProductManagementPage> {
  String _category = 'All';
  bool _lowStockOnly = false;

  List<ProductModel> get _products {
    final all = [
      ...ProductData.footwearProducts,
      ...ProductData.apparelProducts,
      ...ProductData.equipmentProducts,
    ];

    return all.where((product) {
      final matchesCategory = _category == 'All' ||
          (_category == 'Footwear' && int.parse(product.id) <= 8) ||
          (_category == 'Apparel' &&
              int.parse(product.id) >= 9 &&
              int.parse(product.id) <= 12) ||
          (_category == 'Equipment' && int.parse(product.id) >= 13);
      final matchesStock = !_lowStockOnly || product.stockQuantity <= 10;
      return matchesCategory && matchesStock;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _products;

    return AdminPageScaffold(
      title: 'QUẢN LÝ\nSẢN PHẨM',
      subtitle: 'Danh mục, tồn kho và trạng thái hiển thị',
      trailing: IconButton(
        onPressed: () => _showProductForm(context),
        icon: const Icon(Icons.add_circle_outline, color: AppColors.neon),
      ),
      children: [
        GlowButton(
          label: 'THÊM SẢN PHẨM',
          icon: Icons.add_rounded,
          expanded: true,
          onPressed: () => _showProductForm(context),
        ),
        const SizedBox(height: 14),
        const AdminSearchField(hint: 'Tìm tên sản phẩm hoặc SKU...'),
        const SizedBox(height: 14),
        _CategoryFilter(
          selected: _category,
          onChanged: (value) => setState(() => _category = value),
        ),
        const SizedBox(height: 12),
        _SwitchTile(
          title: 'Chỉ hiển thị tồn kho thấp',
          value: _lowStockOnly,
          onChanged: (value) => setState(() => _lowStockOnly = value),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        Text(
          '${products.length} SẢN PHẨM',
          style: const TextStyle(
            color: AppColors.neon,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        ...products.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ProductAdminCard(
              product: product,
              onEdit: () => _showProductForm(context, product: product),
              onStock: () => _showStockSheet(context, product),
              onVisibility: () => _showVisibilitySheet(context, product),
            ),
          ),
        ),
      ],
    );
  }

  void _showProductForm(BuildContext context, {ProductModel? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ProductFormSheet(product: product),
    );
  }

  void _showStockSheet(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _StockSheet(product: product),
    );
  }

  void _showVisibilitySheet(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _VisibilitySheet(product: product),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const values = ['All', 'Footwear', 'Apparel', 'Equipment'];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final value = values[index];
          final active = value == selected;
          return GestureDetector(
            onTap: () => onChanged(value),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: active ? AppColors.neon : AppColors.surface2,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? AppColors.neon : AppColors.border,
                ),
              ),
              child: Text(
                value.toUpperCase(),
                style: TextStyle(
                  color: active ? AppColors.background : AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.neon,
          ),
        ],
      ),
    );
  }
}

class _ProductAdminCard extends StatelessWidget {
  const _ProductAdminCard({
    required this.product,
    required this.onEdit,
    required this.onStock,
    required this.onVisibility,
  });

  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onStock;
  final VoidCallback onVisibility;

  @override
  Widget build(BuildContext context) {
    final lowStock = product.stockQuantity <= 10;

    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              product.imageAsset,
              width: 74,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 74,
                height: 88,
                color: AppColors.surface3,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.badgeText.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.neon,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AdminStatusChip(label: product.price, color: AppColors.neon),
                    AdminStatusChip(
                      label: '${product.stockQuantity} còn lại',
                      color: lowStock ? AppColors.warning : AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _IconAction(icon: Icons.edit_outlined, onTap: onEdit),
                    const SizedBox(width: 8),
                    _IconAction(icon: Icons.inventory_2_outlined, onTap: onStock),
                    const SizedBox(width: 8),
                    _IconAction(
                      icon: Icons.visibility_off_outlined,
                      onTap: onVisibility,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.surfaceHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 18),
      ),
    );
  }
}

class _ProductFormSheet extends StatelessWidget {
  const _ProductFormSheet({this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminSectionTitle(
              eyebrow: product == null ? 'Tạo mới' : 'Chỉnh sửa',
              title: product == null ? 'Thêm sản phẩm' : product!.name,
            ),
            const SizedBox(height: 18),
            _AdminInput(label: 'Tên sản phẩm', initialValue: product?.name),
            const SizedBox(height: 12),
            _AdminInput(label: 'Giá bán', initialValue: product?.price),
            const SizedBox(height: 12),
            _AdminInput(
              label: 'Số lượng tồn kho',
              initialValue: product?.stockQuantity.toString(),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _AdminInput(label: 'Danh mục', initialValue: 'Footwear'),
            const SizedBox(height: 12),
            _UploadBox(product: product),
            const SizedBox(height: 18),
            GlowButton(
              label: product == null ? 'LƯU SẢN PHẨM' : 'CẬP NHẬT SẢN PHẨM',
              icon: Icons.save_rounded,
              expanded: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockSheet extends StatelessWidget {
  const _StockSheet({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(eyebrow: 'Tồn kho', title: product.name),
            const SizedBox(height: 16),
            AdminMetricCard(
              label: 'Tồn kho hiện tại',
              value: '${product.stockQuantity}',
              icon: Icons.inventory_2_rounded,
            ),
            const SizedBox(height: 12),
            const _AdminInput(
              label: 'Số lượng điều chỉnh',
              initialValue: '10',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const _MovementTypeRow(),
            const SizedBox(height: 18),
            GlowButton(
              label: 'LƯU TỒN KHO',
              icon: Icons.check_rounded,
              expanded: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisibilitySheet extends StatelessWidget {
  const _VisibilitySheet({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(eyebrow: 'Hiển thị', title: product.name),
            const SizedBox(height: 16),
            const Text(
              'Ẩn sản phẩm khỏi danh mục user nhưng vẫn giữ nguyên lịch sử đơn hàng.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 18),
            GlowButton(
              label: 'ẨN SẢN PHẨM',
              icon: Icons.visibility_off_rounded,
              expanded: true,
              isPrimary: false,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminInput extends StatelessWidget {
  const _AdminInput({
    required this.label,
    this.initialValue,
    this.keyboardType,
  });

  final String label;
  final String? initialValue;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: product == null
                ? const Icon(Icons.image_outlined, color: AppColors.textMuted)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(product!.imageAsset, fit: BoxFit.cover),
                  ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Tải ảnh sản phẩm lên Firebase Storage',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const Icon(Icons.upload_rounded, color: AppColors.neon),
        ],
      ),
    );
  }
}

class _MovementTypeRow extends StatelessWidget {
  const _MovementTypeRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: AdminStatusChip(label: 'Nhập kho', color: AppColors.neon)),
        SizedBox(width: 8),
        Expanded(
          child: AdminStatusChip(label: 'Điều chỉnh', color: AppColors.warning),
        ),
        SizedBox(width: 8),
        Expanded(child: AdminStatusChip(label: 'Hoàn kho', color: AppColors.textSecondary)),
      ],
    );
  }
}
