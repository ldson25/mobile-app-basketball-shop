import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../cart/mycart.dart';

class ShippingAddressesScreen extends StatelessWidget {
  final VoidCallback onMenuTap;

  const ShippingAddressesScreen({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _ShippingAppBar(onMenuTap: onMenuTap),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 24),
            _HeaderSection(),
            SizedBox(height: 32),
            _AddressGrid(),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _ShippingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;

  const _ShippingAppBar({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(179),
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
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              // Title
              const Text(
                'Shipping Addresses',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                  color: AppColors.neon,
                ),
              ),
              // Cart button
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage your delivery destinations for lightning-fast checkout on limited drops.',
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add new address logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neon,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_location, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'ADD NEW ADDRESS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressGrid extends StatelessWidget {
  const _AddressGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 12,
              mainAxisSpacing: 32,
              crossAxisSpacing: 32,
              childAspectRatio: 1.2,
              children: const [
                _AddressCard(
                  isDefault: true,
                  icon: Icons.home,
                  title: 'Primary Base',
                  name: 'MARCUS JORDAN',
                  address: '23 FLIGHT LANE, STE 100\nCHICAGO, IL 60601',
                  phone: '+1 (312) 555-0123',
                  colSpan: 8,
                ),
                _AddressCard(
                  isDefault: false,
                  icon: Icons.business,
                  title: 'Office',
                  name: 'MARCUS JORDAN',
                  address: '777 KINETIC TOWERS\nNEW YORK, NY 10001',
                  phone: '+1 (212) 555-9988',
                  colSpan: 4,
                ),
                _AddressCard(
                  isDefault: false,
                  icon: Icons.fitness_center,
                  title: 'Training Hub',
                  name: 'MARCUS JORDAN',
                  address: 'THE ARENA GYM, COURT 4\nLOS ANGELES, CA 90015',
                  phone: '+1 (213) 555-4422',
                  colSpan: 4,
                ),
                _AddAddressCard(),
              ],
            );
          } else {
            return Column(
              children: const [
                _AddressCard(
                  isDefault: true,
                  icon: Icons.home,
                  title: 'Primary Base',
                  name: 'MARCUS JORDAN',
                  address: '23 FLIGHT LANE, STE 100\nCHICAGO, IL 60601',
                  phone: '+1 (312) 555-0123',
                ),
                SizedBox(height: 16),
                _AddressCard(
                  isDefault: false,
                  icon: Icons.business,
                  title: 'Office',
                  name: 'MARCUS JORDAN',
                  address: '777 KINETIC TOWERS\nNEW YORK, NY 10001',
                  phone: '+1 (212) 555-9988',
                ),
                const SizedBox(height: 16),
                _AddressCard(
                  isDefault: false,
                  icon: Icons.fitness_center,
                  title: 'Training Hub',
                  name: 'MARCUS JORDAN',
                  address: 'THE ARENA GYM, COURT 4\nLOS ANGELES, CA 90015',
                  phone: '+1 (213) 555-4422',
                ),
                const SizedBox(height: 16),
                _AddAddressCard(),
              ],
            );
          }
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final bool isDefault;
  final IconData icon;
  final String title;
  final String name;
  final String address;
  final String phone;
  final int? colSpan;

  const _AddressCard({
    required this.isDefault,
    required this.icon,
    required this.title,
    required this.name,
    required this.address,
    required this.phone,
    this.colSpan,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? AppColors.neon.withAlpha(77) : AppColors.border.withAlpha(51),
        ),
      ),
      child: Stack(
        children: [
          if (isDefault)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neon,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'DEFAULT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: isDefault ? AppColors.neon : AppColors.textSecondary, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: isDefault ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.call, size: 16, color: AppColors.neon),
                        const SizedBox(width: 8),
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neon,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text(
                        'EDIT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text(
                        'REMOVE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (!isDefault)
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'SET DEFAULT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.neon,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isDefault)
            Positioned(
              bottom: -80,
              right: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.neon.withAlpha(13),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );

    if (colSpan != null) {
      return SizedBox(
        width: double.infinity,
        child: card,
      );
    }
    return card;
  }
}

class _AddAddressCard extends StatelessWidget {
  const _AddAddressCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add new address logic
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withAlpha(51),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surface2,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 32,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ADD NEW LOCATION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}