import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../services/cloudinary_service.dart';
import '../../../services/product_service.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/product_image.dart';
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
  String _query = '';

  List<ProductModel> _visibleProducts(ProductService service) {
    return service.adminProducts.where((product) {
      final matchesCategory = _category == 'All' ||
          (_category == 'Footwear' && product.category == ProductCategory.footwear) ||
          (_category == 'Apparel' && product.category == ProductCategory.apparel) ||
          (_category == 'Equipment' && product.category == ProductCategory.equipment);
      final matchesStock = !_lowStockOnly || product.stockQuantity <= 10;
      final normalized = _query.trim().toLowerCase();
      final matchesQuery = normalized.isEmpty ||
          product.name.toLowerCase().contains(normalized) ||
          product.id.toLowerCase().contains(normalized) ||
          product.badgeText.toLowerCase().contains(normalized);
      return matchesCategory && matchesStock && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ProductService>();
    final products = _visibleProducts(service);

    return AdminPageScaffold(
      title: 'QUAN LY\nSAN PHAM',
      subtitle: 'Danh muc, ton kho va trang thai hien thi',
      trailing: IconButton(
        onPressed: () => _showProductForm(context),
        icon: const Icon(Icons.add_circle_outline, color: AppColors.neon),
      ),
      children: [
        _ProductSummaryStrip(products: service.adminProducts),
        const SizedBox(height: 14),
        GlowButton(
          label: 'THEM SAN PHAM',
          icon: Icons.add_rounded,
          expanded: true,
          onPressed: () => _showProductForm(context),
        ),
        if (service.usingFallback) ...[
          const SizedBox(height: 10),
          GlowButton(
            label: 'SEED SAN PHAM LEN FIRESTORE',
            icon: Icons.cloud_upload_rounded,
            expanded: true,
            isPrimary: false,
            onPressed: () => service.seedDefaultProducts(),
          ),
        ],
        const SizedBox(height: 14),
        AdminSearchField(
          hint: 'Tim ten san pham hoac SKU...',
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 14),
        _CategoryFilter(
          selected: _category,
          onChanged: (value) => setState(() => _category = value),
        ),
        const SizedBox(height: 12),
        _SwitchTile(
          title: 'Chi hien thi ton kho thap',
          value: _lowStockOnly,
          onChanged: (value) => setState(() => _lowStockOnly = value),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        Text(
          '${products.length} SAN PHAM',
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ProductFormPage(product: product),
      ),
    );
  }

  void _showStockSheet(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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

class _ProductSummaryStrip extends StatelessWidget {
  const _ProductSummaryStrip({required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final active = products.where((product) => product.isActive).length;
    final lowStock = products.where((product) => product.stockQuantity <= 10).length;

    return Row(
      children: [
        Expanded(
          child: _MiniMetric(
            label: 'Dang hien',
            value: '$active',
            icon: Icons.visibility_rounded,
            color: AppColors.neon,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniMetric(
            label: 'Sap het',
            value: '$lowStock',
            icon: Icons.inventory_2_rounded,
            color: lowStock > 0 ? AppColors.warning : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            child: ProductImage(
              product: product,
              width: 74,
              height: 88,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.isActive ? product.badgeText.toUpperCase() : 'DANG AN',
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
                      label: '${product.stockQuantity} con lai',
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
                      icon: product.isActive
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
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

class _ProductFormSheet extends StatefulWidget {
  const _ProductFormSheet({this.product});

  final ProductModel? product;

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormPage extends StatelessWidget {
  const _ProductFormPage({this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    final editing = product != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
        ),
        title: Text(
          editing ? 'SUA SAN PHAM' : 'THEM SAN PHAM',
          style: const TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: _ProductFormSheet(product: product),
    );
  }
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  final _cloudinaryService = CloudinaryService();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _optionLabelController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _imagePublicIdController;
  late final TextEditingController _imageAssetController;
  late final TextEditingController _badgeController;
  ProductCategory _category = ProductCategory.footwear;
  bool _isNewArrival = false;
  bool _isMemberExclusive = false;
  bool _isBestSeller = false;
  bool _isSignatureSeries = false;
  bool _isActive = true;
  bool _isUploading = false;
  late final List<_StockOptionController> _stockRows;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _priceController = TextEditingController(text: product?.price ?? '');
    _category = product?.category ?? ProductCategory.footwear;
    _optionLabelController = TextEditingController(
      text: product?.optionLabel ?? _defaultOptionLabel(_category),
    );
    _stockRows = product == null
        ? _defaultStockRows(_category)
        : _stockRowsFromMap(product.optionStock);
    _imageUrlController = TextEditingController(text: product?.imageUrl ?? '');
    _imagePublicIdController =
        TextEditingController(text: product?.imagePublicId ?? '');
    _imageAssetController = TextEditingController(text: product?.imageAsset ?? '');
    _badgeController = TextEditingController(text: product?.badge ?? '');
    _isNewArrival = product?.isNewArrival ?? false;
    _isMemberExclusive = product?.isMemberExclusive ?? false;
    _isBestSeller = product?.isBestSeller ?? false;
    _isSignatureSeries = product?.isSignatureSeries ?? false;
    _isActive = product?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _optionLabelController.dispose();
    for (final row in _stockRows) {
      row.dispose();
    }
    _imageUrlController.dispose();
    _imagePublicIdController.dispose();
    _imageAssetController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.product != null;
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
              eyebrow: editing ? 'Chinh sua' : 'Tao moi',
              title: editing ? widget.product!.name : 'Them san pham',
            ),
            const SizedBox(height: 18),
            _TextInput(label: 'Ten san pham', controller: _nameController),
            const SizedBox(height: 12),
            _TextInput(label: 'Gia ban', controller: _priceController),
            const SizedBox(height: 12),
            _CategoryPicker(
              value: _category,
              onChanged: _changeCategory,
            ),
            const SizedBox(height: 12),
            if (_category != ProductCategory.equipment) ...[
              _TextInput(label: 'Nhan tuy chon', controller: _optionLabelController),
              const SizedBox(height: 12),
              _StockRowsEditor(
                rows: _stockRows,
                onChanged: () => setState(() {}),
                onAdd: _addStockRow,
                onRemove: _removeStockRow,
              ),
              const SizedBox(height: 12),
            ] else ...[
              _NoSizeNotice(
                stock: _stockRowsToMap(_stockRows)['Default'] ?? 1,
                onChanged: _setDefaultStock,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),
            _TextInput(label: 'Badge tuy chon', controller: _badgeController),
            const SizedBox(height: 12),
            _FlagRow(
              isNewArrival: _isNewArrival,
              isMemberExclusive: _isMemberExclusive,
              isBestSeller: _isBestSeller,
              isSignatureSeries: _isSignatureSeries,
              isActive: _isActive,
              onNewArrival: (value) => setState(() => _isNewArrival = value),
              onMember: (value) => setState(() => _isMemberExclusive = value),
              onBestSeller: (value) => setState(() => _isBestSeller = value),
              onSignature: (value) => setState(() => _isSignatureSeries = value),
              onActive: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: 12),
            _ImagePreview(
              product: _previewProduct(),
              onPickGallery: _isUploading
                  ? null
                  : () => _pickAndUploadImage(ImageSource.gallery),
              onPickCamera: _isUploading
                  ? null
                  : () => _pickAndUploadImage(ImageSource.camera),
              isUploading: _isUploading,
            ),
            const SizedBox(height: 18),
            GlowButton(
              label: editing ? 'CAP NHAT SAN PHAM' : 'LUU SAN PHAM',
              icon: Icons.save_rounded,
              expanded: true,
              onPressed: _saveProduct,
            ),
            if (editing) ...[
              const SizedBox(height: 12),
              GlowButton(
                label: 'XOA SAN PHAM',
                icon: Icons.delete_rounded,
                expanded: true,
                isPrimary: false,
                onPressed: _deleteProduct,
              ),
            ],
          ],
        ),
      ),
    );
  }

  ProductModel _previewProduct() {
    return ProductModel(
      id: widget.product?.id ?? 'preview',
      name: _nameController.text.trim(),
      price: _priceController.text.trim(),
      imageAsset: _imageAssetController.text.trim(),
      imageUrl:
          _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      imagePublicId: _imagePublicIdController.text.trim().isEmpty
          ? null
          : _imagePublicIdController.text.trim(),
      category: _category,
      optionLabel: _optionLabel(),
      optionStock: _normalizedStock(),
      badge: _badgeController.text.trim(),
      isNewArrival: _isNewArrival,
      isMemberExclusive: _isMemberExclusive,
      isBestSeller: _isBestSeller,
      isSignatureSeries: _isSignatureSeries,
      isActive: _isActive,
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 86,
      );
      if (picked == null) return;
      setState(() => _isUploading = true);
      final result = await _cloudinaryService.uploadProductImage(picked);
      if (!mounted) return;
      setState(() {
        _imageUrlController.text = result.imageUrl;
        _imagePublicIdController.text = result.publicId;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _saveProduct() {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhap ten va gia san pham')),
      );
      return;
    }
    if (_normalizedStock().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhap it nhat mot size/tuy chon ton kho')),
      );
      return;
    }

    final product = _previewProduct().copyWith(
      id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
    context.read<ProductService>().saveProduct(product);
    Navigator.pop(context);
  }

  void _changeCategory(ProductCategory value) {
    if (_category == value) return;
    _category = value;
    _optionLabelController.text = _defaultOptionLabel(value);
    _replaceStockRows(_defaultStockRows(value));
    setState(() {});
  }

  String _optionLabel() {
    if (_category == ProductCategory.equipment) return 'Phan loai';
    final value = _optionLabelController.text.trim();
    return value.isEmpty ? _defaultOptionLabel(_category) : value;
  }

  Map<String, int> _normalizedStock() {
    if (_category == ProductCategory.equipment) {
      final current = _stockRowsToMap(_stockRows);
      return {'Default': current['Default'] ?? 1};
    }
    return _stockRowsToMap(_stockRows);
  }

  void _setDefaultStock(int value) {
    if (_stockRows.isEmpty) {
      _stockRows.add(
        _StockOptionController(option: 'Default', quantity: value.toString()),
      );
    } else {
      _stockRows.first.option.text = 'Default';
      _stockRows.first.quantity.text = value.toString();
      while (_stockRows.length > 1) {
        final row = _stockRows.removeLast();
        row.dispose();
      }
    }
    setState(() {});
  }

  void _replaceStockRows(List<_StockOptionController> nextRows) {
    for (final row in _stockRows) {
      row.dispose();
    }
    _stockRows
      ..clear()
      ..addAll(nextRows);
  }

  void _addStockRow() {
    _stockRows.add(_StockOptionController());
    setState(() {});
  }

  void _removeStockRow(_StockOptionController row) {
    if (_stockRows.length == 1) {
      row.option.text = 'Default';
      row.quantity.text = '1';
      setState(() {});
      return;
    }
    _stockRows.remove(row);
    row.dispose();
    setState(() {});
  }

  Future<void> _deleteProduct() async {
    final product = widget.product;
    if (product == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoa san pham'),
        content: Text('Xoa ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('HUY'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('XOA'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await context.read<ProductService>().deleteProduct(product.id);
    if (!mounted) return;
    Navigator.pop(context);
  }
}

class _StockSheet extends StatefulWidget {
  const _StockSheet({required this.product});

  final ProductModel product;

  @override
  State<_StockSheet> createState() => _StockSheetState();
}

class _StockSheetState extends State<_StockSheet> {
  late final List<_StockOptionController> _stockRows;

  @override
  void initState() {
    super.initState();
    _stockRows = _stockRowsFromMap(widget.product.optionStock);
  }

  @override
  void dispose() {
    for (final row in _stockRows) {
      row.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(eyebrow: 'Ton kho', title: widget.product.name),
            const SizedBox(height: 16),
            AdminMetricCard(
              label: 'Ton kho hien tai',
              value: '${widget.product.stockQuantity}',
              icon: Icons.inventory_2_rounded,
            ),
            const SizedBox(height: 12),
            const Text(
              'Quan ly tung size/tuy chon rieng de tranh sai format du lieu.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 10),
            if (widget.product.category == ProductCategory.equipment)
              _NoSizeNotice(
                stock: _stockRowsToMap(_stockRows)['Default'] ?? 1,
                onChanged: _setDefaultStock,
              )
            else
              _StockRowsEditor(
                rows: _stockRows,
                onChanged: () => setState(() {}),
                onAdd: _addStockRow,
                onRemove: _removeStockRow,
              ),
            const SizedBox(height: 18),
            GlowButton(
              label: 'LUU TON KHO',
              icon: Icons.check_rounded,
              expanded: true,
              onPressed: () {
                final nextStock = widget.product.category == ProductCategory.equipment
                    ? {'Default': _stockRowsToMap(_stockRows)['Default'] ?? 1}
                    : _stockRowsToMap(_stockRows);
                if (nextStock.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nhap it nhat mot size/tuy chon')),
                  );
                  return;
                }
                context.read<ProductService>().updateStock(
                      widget.product.id,
                      nextStock,
                    );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addStockRow() {
    _stockRows.add(_StockOptionController());
    setState(() {});
  }

  void _removeStockRow(_StockOptionController row) {
    if (_stockRows.length == 1) {
      row.option.text = 'Default';
      row.quantity.text = '1';
      setState(() {});
      return;
    }
    _stockRows.remove(row);
    row.dispose();
    setState(() {});
  }

  void _setDefaultStock(int value) {
    if (_stockRows.isEmpty) {
      _stockRows.add(
        _StockOptionController(option: 'Default', quantity: value.toString()),
      );
    } else {
      _stockRows.first.option.text = 'Default';
      _stockRows.first.quantity.text = value.toString();
      while (_stockRows.length > 1) {
        final row = _stockRows.removeLast();
        row.dispose();
      }
    }
    setState(() {});
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
            AdminSectionTitle(eyebrow: 'Hien thi', title: product.name),
            const SizedBox(height: 16),
            Text(
              product.isActive
                  ? 'San pham dang hien thi cho user.'
                  : 'San pham dang bi an khoi danh muc user.',
              style: const TextStyle(color: AppColors.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 18),
            GlowButton(
              label: product.isActive ? 'AN SAN PHAM' : 'HIEN SAN PHAM',
              icon: product.isActive
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              expanded: true,
              isPrimary: false,
              onPressed: () {
                context.read<ProductService>().toggleProductVisibility(product.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _StockRowsEditor extends StatelessWidget {
  const _StockRowsEditor({
    required this.rows,
    required this.onChanged,
    required this.onAdd,
    required this.onRemove,
  });

  final List<_StockOptionController> rows;
  final VoidCallback onChanged;
  final VoidCallback onAdd;
  final ValueChanged<_StockOptionController> onRemove;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Size / tuy chon va ton kho',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: row.option,
                      onChanged: (_) => onChanged(),
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Size',
                        hintText: '8 / M / Default',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: row.quantity,
                      onChanged: (_) => onChanged(),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Ton',
                        hintText: '10',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onRemove(row),
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('THEM SIZE'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.neon,
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoSizeNotice extends StatelessWidget {
  const _NoSizeNotice({
    required this.stock,
    required this.onChanged,
  });

  final int stock;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'San pham nay khong can size',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Phu kien/bong ro se luu ton kho bang Default va khong hien size cho user.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.35),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: stock.toString(),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Ton kho'),
            onChanged: (value) => onChanged(int.tryParse(value.trim()) ?? 0),
          ),
        ],
      ),
    );
  }
}

class _StockOptionController {
  _StockOptionController({String option = '', String quantity = '0'})
      : option = TextEditingController(text: option),
        quantity = TextEditingController(text: quantity);

  final TextEditingController option;
  final TextEditingController quantity;

  void dispose() {
    option.dispose();
    quantity.dispose();
  }
}

List<_StockOptionController> _stockRowsFromMap(Map<String, int>? stock) {
  final rows = <_StockOptionController>[];
  if (stock != null && stock.isNotEmpty) {
    for (final entry in stock.entries) {
      rows.add(
        _StockOptionController(
          option: entry.key,
          quantity: entry.value.toString(),
        ),
      );
    }
  }
  if (rows.isEmpty) {
    rows.add(_StockOptionController(option: 'Default', quantity: '1'));
  }
  return rows;
}

List<_StockOptionController> _defaultStockRows(ProductCategory category) {
  switch (category) {
    case ProductCategory.footwear:
      return ['36', '37', '38', '39', '40', '41', '42']
          .map((size) => _StockOptionController(option: size, quantity: '0'))
          .toList();
    case ProductCategory.apparel:
      return ['S', 'M', 'L', 'XL']
          .map((size) => _StockOptionController(option: size, quantity: '0'))
          .toList();
    case ProductCategory.equipment:
      return [_StockOptionController(option: 'Default', quantity: '1')];
  }
}

String _defaultOptionLabel(ProductCategory category) {
  switch (category) {
    case ProductCategory.footwear:
      return 'Size giay';
    case ProductCategory.apparel:
      return 'Size quan ao';
    case ProductCategory.equipment:
      return 'Phan loai';
  }
}

Map<String, int> _stockRowsToMap(List<_StockOptionController> rows) {
  final result = <String, int>{};
  for (final row in rows) {
    final option = row.option.text.trim();
    if (option.isEmpty) continue;
    final quantity = int.tryParse(row.quantity.text.trim()) ?? 0;
    result[option] = quantity < 0 ? 0 : quantity;
  }
  return result;
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.value, required this.onChanged});

  final ProductCategory value;
  final ValueChanged<ProductCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ProductCategory>(
      value: value,
      dropdownColor: AppColors.surface2,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: const InputDecoration(labelText: 'Danh muc'),
      items: ProductCategory.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(category.name),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _FlagRow extends StatelessWidget {
  const _FlagRow({
    required this.isNewArrival,
    required this.isMemberExclusive,
    required this.isBestSeller,
    required this.isSignatureSeries,
    required this.isActive,
    required this.onNewArrival,
    required this.onMember,
    required this.onBestSeller,
    required this.onSignature,
    required this.onActive,
  });

  final bool isNewArrival;
  final bool isMemberExclusive;
  final bool isBestSeller;
  final bool isSignatureSeries;
  final bool isActive;
  final ValueChanged<bool> onNewArrival;
  final ValueChanged<bool> onMember;
  final ValueChanged<bool> onBestSeller;
  final ValueChanged<bool> onSignature;
  final ValueChanged<bool> onActive;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _FlagChip(label: 'New', value: isNewArrival, onChanged: onNewArrival),
        _FlagChip(label: 'Member', value: isMemberExclusive, onChanged: onMember),
        _FlagChip(label: 'Best seller', value: isBestSeller, onChanged: onBestSeller),
        _FlagChip(label: 'Signature', value: isSignatureSeries, onChanged: onSignature),
        _FlagChip(label: 'Active', value: isActive, onChanged: onActive),
      ],
    );
  }
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: value,
      onSelected: onChanged,
      selectedColor: AppColors.neon,
      backgroundColor: AppColors.surface2,
      labelStyle: TextStyle(
        color: value ? AppColors.background : AppColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
      side: const BorderSide(color: AppColors.border),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.product,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.isUploading,
  });

  final ProductModel product;
  final VoidCallback? onPickGallery;
  final VoidCallback? onPickCamera;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ProductImage(
              product: product,
              width: 74,
              height: 74,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isUploading
                  ? 'Dang upload Cloudinary...'
                  : 'Chon anh tu dien thoai hoac chup moi. URL se tu dong luu Firestore.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          IconButton(
            onPressed: onPickGallery,
            icon: isUploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.neon,
                    ),
                  )
                : const Icon(Icons.photo_library_rounded, color: AppColors.neon),
          ),
          IconButton(
            onPressed: isUploading ? null : onPickCamera,
            icon: const Icon(Icons.photo_camera_rounded, color: AppColors.neon),
          ),
        ],
      ),
    );
  }
}
