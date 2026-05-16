import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../cart/mycart.dart';
import '../checkout/checkoutstept.dart';

class CheckoutShippingScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const CheckoutShippingScreen({super.key, required this.onMenuTap});

  @override
  State<CheckoutShippingScreen> createState() => _CheckoutShippingScreenState();
}

class _CheckoutShippingScreenState extends State<CheckoutShippingScreen> {
  String? selectedCountry = 'UNITED STATES';
  String? selectedShipping = 'free';
  bool billingMatchesShipping = true;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              _PersonalInfoSection(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
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
                stateController: stateController,
                zipController: zipController,
                phoneController: phoneController,
              ),
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
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                selectedCountry: selectedCountry,
                streetController: streetController,
                cityController: cityController,
                stateController: stateController,
                zipController: zipController,
                phoneController: phoneController,
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
    firstNameController.dispose();
    lastNameController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
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
                    'Check Out',
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
          'Shipping',
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
          'Where should we send your elite performance gear?',
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

class _PersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String? selectedCountry;
  final ValueChanged<String?> onCountryChanged;

  const _PersonalInfoSection({
    required this.firstNameController,
    required this.lastNameController,
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
              'Personal Information',
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
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'FIRST NAME *',
                hint: 'e.g. ALEX',
                controller: firstNameController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _InputField(
                label: 'LAST NAME *',
                hint: 'e.g. STARK',
                controller: lastNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'COUNTRY *',
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
                    items: ['UNITED STATES', 'UNITED KINGDOM', 'GERMANY', 'JAPAN']
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
  final TextEditingController stateController;
  final TextEditingController zipController;
  final TextEditingController phoneController;

  const _DeliveryAddressSection({
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
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
              'Delivery Address',
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
          label: 'STREET NAME *',
          controller: streetController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'CITY *',
                controller: cityController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _InputField(
                label: 'STATE / PROVINCE *',
                controller: stateController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'ZIP-CODE *',
                controller: zipController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _InputField(
                label: 'PHONE NUMBER *',
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
              'Shipping Method',
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
          title: 'Free Delivery to home',
          subtitle: '3 - 7 business days',
          price: 'FREE',
          isSelected: selectedShipping == 'free',
          onTap: () => onShippingChanged('free'),
        ),
        const SizedBox(height: 12),
        _ShippingOption(
          value: 'standard',
          title: 'Standard Delivery',
          subtitle: '2 - 4 business days',
          price: '\$9.90',
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
          'Billing address matches shipping address.',
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
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String? selectedCountry;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;
  final TextEditingController phoneController;
  final VoidCallback onMenuTap;
  const _ContinueButton(
    {
       required this.firstNameController,
    required this.lastNameController,
    required this.selectedCountry,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
    required this.phoneController,
    required this.onMenuTap,
    }
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
      onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutPaymentScreen(
                          shippingData: {
                            'firstName': firstNameController.text,
                            'lastName': lastNameController.text,
                            'country': selectedCountry ?? '',
                            'street': streetController.text,
                            'city': cityController.text,
                            'state': stateController.text,
                            'zip': zipController.text,
                            'phone': phoneController.text,
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
          'CONTINUE TO PAYMENT',
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