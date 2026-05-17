import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../models/shipping_address_model.dart';
import '../../services/shipping_address_service.dart';
import '../cart/mycart.dart';
import '../checkout/checkoutstept.dart';

class CheckoutShippingScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const CheckoutShippingScreen({super.key, required this.onMenuTap});

  @override
  State<CheckoutShippingScreen> createState() => _CheckoutShippingScreenState();
}

class _CheckoutShippingScreenState extends State<CheckoutShippingScreen> {
  String? selectedCountry = 'VIET NAM';
  String? selectedShipping = 'free';
  String? selectedAddressId;
  bool useSavedAddress = true;
  bool billingMatchesShipping = true;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController wardController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final defaultAddress = context.read<ShippingAddressService>().defaultAddress;
    selectedAddressId ??= defaultAddress?.id;
    useSavedAddress = defaultAddress != null && useSavedAddress;
  }

  @override
  Widget build(BuildContext context) {
    final savedAddresses = context.watch<ShippingAddressService>().addresses;
    ShippingAddressModel? selectedSavedAddress;
    for (final address in savedAddresses) {
      if (address.id == selectedAddressId) {
        selectedSavedAddress = address;
        break;
      }
    }
    final shouldUseSavedAddress =
        useSavedAddress && savedAddresses.isNotEmpty && selectedSavedAddress != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _CheckoutAppBar(onMenuTap: widget.onMenuTap),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _ProgressIndicator(),
              const SizedBox(height: 32),
              _HeaderSection(),
              const SizedBox(height: 32),
              if (savedAddresses.isNotEmpty)
                _SavedAddressSection(
                  addresses: savedAddresses,
                  selectedAddressId: selectedAddressId,
                  useSavedAddress: useSavedAddress,
                  onSelectAddress: (id) {
                    setState(() {
                      selectedAddressId = id;
                      useSavedAddress = true;
                    });
                  },
                  onUseNewAddress: () {
                    setState(() => useSavedAddress = false);
                  },
                ),
              if (savedAddresses.isNotEmpty) const SizedBox(height: 32),
              if (!shouldUseSavedAddress) ...[
                _PersonalInfoSection(
                  fullNameController: fullNameController,
                  selectedCountry: selectedCountry,
                  onCountryChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                ),
                const SizedBox(height: 32),
                _DeliveryAddressSection(
                  streetController: streetController,
                  cityController: cityController,
                  districtController: districtController,
                  wardController: wardController,
                  phoneController: phoneController,
                ),
              ] else
                _SelectedAddressPreview(address: selectedSavedAddress),
              const SizedBox(height: 32),
              _ShippingMethodSection(
                selectedShipping: selectedShipping,
                onShippingChanged: (value) {
                  setState(() {
                    selectedShipping = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _BillingCheckbox(
                value: billingMatchesShipping,
                onChanged: (value) {
                  setState(() {
                    billingMatchesShipping = value ?? true;
                  });
                },
              ),
              const SizedBox(height: 32),
              _ContinueButton(
                fullNameController: fullNameController,
                selectedCountry: selectedCountry,
                selectedShipping: selectedShipping,
                streetController: streetController,
                cityController: cityController,
                districtController: districtController,
                wardController: wardController,
                phoneController: phoneController,
                savedAddress: shouldUseSavedAddress ? selectedSavedAddress : null,
                onMenuTap: widget.onMenuTap,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    streetController.dispose();
    cityController.dispose();
    districtController.dispose();
    wardController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

class _CheckoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;

  const _CheckoutAppBar({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(230),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withAlpha(51),
          ),
        ),
      ),
      child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 40), 
              Expanded(
                child: Center(
                  child: Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -0.5,
                      color: AppColors.neon,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
             ], 
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: AppColors.border,
            ),
          ),
          Positioned(
            top: 28,
            left: 0,
            right: MediaQuery.of(context).size.width / 1.5,
            child: Container(
              height: 2,
              color: AppColors.neon,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ProgressStep(
                isActive: true,
                icon: Icons.local_shipping,
                iconColor: AppColors.surface,
                backgroundColor: AppColors.neon,
              ),
              _ProgressStep(
                isActive: false,
                icon: Icons.payment,
                iconColor: AppColors.textSecondary,
                backgroundColor: AppColors.surface2,
              ),
              _ProgressStep(
                isActive: false,
                icon: Icons.check_circle,
                iconColor: AppColors.textSecondary,
                backgroundColor: AppColors.surface2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _ProgressStep({
    required this.isActive,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: isActive ? null : Border.all(color: AppColors.border),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.neon.withAlpha(77),
                  blurRadius: 15,
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: 22,
        color: iconColor,
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giao hàng',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 48,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Nhập thông tin nhận hàng để Kinetic giao đúng địa chỉ của bạn.',
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SavedAddressSection extends StatelessWidget {
  const _SavedAddressSection({
    required this.addresses,
    required this.selectedAddressId,
    required this.useSavedAddress,
    required this.onSelectAddress,
    required this.onUseNewAddress,
  });

  final List<ShippingAddressModel> addresses;
  final String? selectedAddressId;
  final bool useSavedAddress;
  final ValueChanged<String> onSelectAddress;
  final VoidCallback onUseNewAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_on_rounded, color: AppColors.neon, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Chon dia chi da luu',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...addresses.map(
          (address) {
            final isSelected = useSavedAddress && address.id == selectedAddressId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => onSelectAddress(address.id),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.neon : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected ? AppColors.neon : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.label,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              address.fullAddress,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${address.fullName} / ${address.phone}',
                              style: const TextStyle(
                                color: AppColors.neon,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        TextButton.icon(
          onPressed: onUseNewAddress,
          icon: const Icon(Icons.add_location_alt_rounded),
          label: const Text('Nhập địa chỉ mới'),
          style: TextButton.styleFrom(foregroundColor: AppColors.neon),
        ),
      ],
    );
  }
}

class _SelectedAddressPreview extends StatelessWidget {
  const _SelectedAddressPreview({required this.address});

  final ShippingAddressModel? address;

  @override
  Widget build(BuildContext context) {
    if (address == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neon.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dia chi dang su dung',
            style: TextStyle(
              color: AppColors.neon,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            address!.fullName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            address!.fullAddress,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 6),
          Text(
            address!.phone,
            style: const TextStyle(
              color: AppColors.neon,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoSection extends StatelessWidget {
  final TextEditingController fullNameController;
  final String? selectedCountry;
  final ValueChanged<String?> onCountryChanged;

  const _PersonalInfoSection({
    required this.fullNameController,
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person, color: AppColors.neon, size: 24),
            const SizedBox(width: 12),
            const Text(
                'Thông tin người nhận',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _InputField(
          label: 'HỌ VÀ TÊN *',
          hint: 'Nguyễn Văn A',
          controller: fullNameController,
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'QUỐC GIA *',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    isExpanded: true,
                    dropdownColor: AppColors.surface2,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    items: ['VIET NAM']
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                    onChanged: onCountryChanged,
                    icon: const Icon(Icons.expand_more, color: AppColors.neon),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeliveryAddressSection extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController wardController;
  final TextEditingController phoneController;

  const _DeliveryAddressSection({
    required this.streetController,
    required this.cityController,
    required this.districtController,
    required this.wardController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.neon, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Địa chỉ giao hàng',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _InputField(
          label: 'SỐ NHÀ, TÊN ĐƯỜNG *',
          hint: '72 Lê Thánh Tôn',
          controller: streetController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'TỈNH / THÀNH PHỐ *',
                hint: 'TP. Hồ Chí Minh',
                controller: cityController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _InputField(
                label: 'QUẬN / HUYỆN *',
                hint: 'Quận 1',
                controller: districtController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InputField(
          label: 'PHƯỜNG / XÃ *',
          hint: 'Phường Bến Nghé',
          controller: wardController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'SỐ ĐIỆN THOẠI *',
                hint: '09xxxxxxxx',
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const _InputField({
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.border),
            filled: true,
            fillColor: AppColors.surface2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.neon, width: 1),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

class _ShippingMethodSection extends StatelessWidget {
  final String? selectedShipping;
  final ValueChanged<String?> onShippingChanged;

  const _ShippingMethodSection({
    required this.selectedShipping,
    required this.onShippingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_shipping, color: AppColors.neon, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Phương thức giao hàng',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ShippingOption(
          value: 'free',
          title: 'Giao hàng tiêu chuẩn',
          subtitle: '2 - 5 ngày làm việc',
          price: 'Miễn phí',
          isSelected: selectedShipping == 'free',
          onTap: () => onShippingChanged('free'),
        ),
        const SizedBox(height: 12),
        _ShippingOption(
          value: 'standard',
          title: 'Giao hàng nhanh',
          subtitle: '1 - 2 ngày làm việc',
          price: '30.000đ',
          isSelected: selectedShipping == 'standard',
          onTap: () => onShippingChanged('standard'),
        ),
      ],
    );
  }
}

class _ShippingOption extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShippingOption({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface2.withAlpha(77),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.neon : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.neon : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neon,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              price,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.neon : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _BillingCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.neon;
              }
              return Colors.transparent;
            }),
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Địa chỉ thanh toán giống địa chỉ giao hàng.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final TextEditingController fullNameController;
  final String? selectedCountry;
  final String? selectedShipping;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController wardController;
  final TextEditingController phoneController;
  final ShippingAddressModel? savedAddress;
  final VoidCallback onMenuTap;
  const _ContinueButton(
    {
    required this.fullNameController,
    required this.selectedCountry,
    required this.selectedShipping,
    required this.streetController,
    required this.cityController,
    required this.districtController,
    required this.wardController,
    required this.phoneController,
    this.savedAddress,
    required this.onMenuTap,
    }
  );

  double get _shippingCost => selectedShipping == 'standard' ? 30000 : 0;

  String get _shippingLabel =>
      selectedShipping == 'standard' ? 'Giao hàng nhanh' : 'Giao hàng tiêu chuẩn';

  bool _isBlank(TextEditingController controller) {
    return controller.text.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
      onPressed: () {
            if (savedAddress != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPaymentScreen(
                    shippingData: savedAddress!.toCheckoutData(
                      shippingMethod: selectedShipping ?? 'free',
                      shippingLabel: _shippingLabel,
                      shippingCost: _shippingCost,
                    ),
                    onMenuTap: onMenuTap,
                  ),
                ),
              );
              return;
            }

            if (_isBlank(fullNameController) ||
                _isBlank(phoneController) ||
                _isBlank(streetController) ||
                _isBlank(wardController) ||
                _isBlank(districtController) ||
                _isBlank(cityController)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vui lòng nhập đầy đủ thông tin giao hàng.'),
                ),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutPaymentScreen(
                          shippingData: {
                            'fullName': fullNameController.text.trim(),
                            'country': selectedCountry ?? '',
                            'street': streetController.text.trim(),
                            'ward': wardController.text.trim(),
                            'city': cityController.text.trim(),
                            'district': districtController.text.trim(),
                            'phone': phoneController.text.trim(),
                            'shippingMethod': selectedShipping ?? 'free',
                            'shippingLabel': _shippingLabel,
                            'shippingCost': _shippingCost.toString(),
                          }, onMenuTap: onMenuTap,
                        ),
              ),
            );
          },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neon,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 0,
          shadowColor: AppColors.neon.withAlpha(51),
        ),
        child: const Text(
          'TIẾP TỤC THANH TOÁN',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}
