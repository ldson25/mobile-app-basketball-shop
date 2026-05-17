import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../models/shipping_address_model.dart';
import '../../services/shipping_address_service.dart';
import '../cart/mycart.dart';

class ShippingAddressesScreen extends StatelessWidget {
  final VoidCallback onMenuTap;

  const ShippingAddressesScreen({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _ShippingAppBar(),
      body: Consumer<ShippingAddressService>(
        builder: (context, addressService, child) {
          final addresses = addressService.addresses;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quan ly dia chi nhan hang de checkout nhanh hon.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddressForm(context),
                    icon: const Icon(Icons.add_location_alt_rounded),
                    label: const Text('THEM DIA CHI MOI'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neon,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (addresses.isEmpty)
                  const _EmptyAddressView()
                else
                  ...addresses.map(
                    (address) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _AddressCard(
                        address: address,
                        onEdit: () => _showAddressForm(context, address: address),
                        onDelete: () => addressService.removeAddress(address.id),
                        onSetDefault: () => addressService.setDefault(address.id),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  static void _showAddressForm(
    BuildContext context, {
    ShippingAddressModel? address,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _AddressFormSheet(address: address),
    );
  }
}

class _ShippingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ShippingAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(179),
        border: Border(bottom: BorderSide(color: AppColors.border.withAlpha(51))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
              ),
              const Expanded(
                child: Text(
                  'DIA CHI GIAO HANG',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: AppColors.neon,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _EmptyAddressView extends StatelessWidget {
  const _EmptyAddressView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withAlpha(51)),
      ),
      child: const Column(
        children: [
          Icon(Icons.location_off_outlined, color: AppColors.neon, size: 42),
          SizedBox(height: 12),
          Text(
            'Chua co dia chi',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Them dia chi de checkout tu dong dien thong tin nhan hang.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final ShippingAddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault ? AppColors.neon : AppColors.border.withAlpha(51),
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                address.isDefault ? Icons.home_rounded : Icons.location_on_rounded,
                color: AppColors.neon,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  address.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neon,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'MAC DINH',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            address.fullName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            address.fullAddress,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            address.phone,
            style: const TextStyle(
              color: AppColors.neon,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _SmallActionButton(
                icon: Icons.edit_rounded,
                label: 'Sua',
                onTap: onEdit,
              ),
              _SmallActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'Xoa',
                color: AppColors.error,
                onTap: onDelete,
              ),
              if (!address.isDefault)
                _SmallActionButton(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Mac dinh',
                  onTap: onSetDefault,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.neon,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  const _AddressFormSheet({this.address});

  final ShippingAddressModel? address;

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  late final TextEditingController labelController;
  late final TextEditingController fullNameController;
  late final TextEditingController phoneController;
  late final TextEditingController streetController;
  late final TextEditingController wardController;
  late final TextEditingController districtController;
  late final TextEditingController cityController;
  late bool isDefault;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    labelController = TextEditingController(text: address?.label ?? 'Nha rieng');
    fullNameController = TextEditingController(text: address?.fullName);
    phoneController = TextEditingController(text: address?.phone);
    streetController = TextEditingController(text: address?.street);
    wardController = TextEditingController(text: address?.ward);
    districtController = TextEditingController(text: address?.district);
    cityController = TextEditingController(text: address?.city ?? 'TP. Ho Chi Minh');
    isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    labelController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    wardController.dispose();
    districtController.dispose();
    cityController.dispose();
    super.dispose();
  }

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
            Text(
              widget.address == null ? 'THEM DIA CHI' : 'SUA DIA CHI',
              style: const TextStyle(
                color: AppColors.neon,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            _AddressInput(label: 'Ten dia chi', controller: labelController),
            _AddressInput(label: 'Ho va ten', controller: fullNameController),
            _AddressInput(
              label: 'So dien thoai',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            _AddressInput(label: 'So nha, ten duong', controller: streetController),
            _AddressInput(label: 'Phuong / Xa', controller: wardController),
            _AddressInput(label: 'Quan / Huyen', controller: districtController),
            _AddressInput(label: 'Tinh / Thanh pho', controller: cityController),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: isDefault,
              activeThumbColor: AppColors.neon,
              title: const Text(
                'Dat lam dia chi mac dinh',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onChanged: (value) => setState(() => isDefault = value),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neon,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text(
                  'LUU DIA CHI',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAddress() {
    final requiredFields = [
      fullNameController.text,
      phoneController.text,
      streetController.text,
      wardController.text,
      districtController.text,
      cityController.text,
    ];

    if (requiredFields.any((value) => value.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui long nhap day du thong tin dia chi')),
      );
      return;
    }

    final service = context.read<ShippingAddressService>();
    final address = ShippingAddressModel(
      id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      label: labelController.text.trim().isEmpty
          ? 'Dia chi giao hang'
          : labelController.text.trim(),
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      street: streetController.text.trim(),
      ward: wardController.text.trim(),
      district: districtController.text.trim(),
      city: cityController.text.trim(),
      isDefault: isDefault,
    );

    if (widget.address == null) {
      service.addAddress(address);
    } else {
      service.updateAddress(address);
    }

    Navigator.pop(context);
  }
}

class _AddressInput extends StatelessWidget {
  const _AddressInput({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
