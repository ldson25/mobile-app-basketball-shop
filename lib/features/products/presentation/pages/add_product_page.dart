import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/section_card.dart';
import '../widgets/product_input_field.dart';
import '../widgets/upload_placeholder.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              const SizedBox(height: 20),
              const Text(
                'INVENTORY MANAGEMENT',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'ADD PRODUCT',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 34),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: GlowButton(
                      label: 'CANCEL',
                      isPrimary: false,
                      expanded: true,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: GlowButton(label: 'SAVE PRODUCT', expanded: true),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sectionGap),
              const SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardTitle('CORE DETAILS'),
                    SizedBox(height: 20),
                    ProductInputField(
                      label: 'Product Name',
                      hint: 'e.g. Kinetic Air Zoom X',
                    ),
                    SizedBox(height: 18),
                    ProductInputField(
                      label: 'Category',
                      hint: 'Select Category',
                      suffix: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 18),
                    ProductInputField(
                      label: 'Price (USD)',
                      hint: '0.00',
                      prefix: Text(
                        '\$',
                        style: TextStyle(
                          color: AppColors.neon,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ProductInputField(
                      label: 'Editorial Description',
                      hint: 'Enter high-impact product narrative...',
                      large: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              const SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardTitle('INVENTORY & LOGISTICS'),
                    SizedBox(height: 20),
                    ProductInputField(
                      label: 'Stock Keeping Unit (SKU)',
                      hint: 'KNT-000-00',
                    ),
                    SizedBox(height: 18),
                    ProductInputField(label: 'Initial Stock Level', hint: '0'),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const UploadPlaceholder(),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              SectionCard(
                color: const Color(0xFF202020),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CardTitle(
                      'VISIBILITY STATUS',
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FEATURE PRODUCT',
                                style: TextStyle(
                                  color: AppColors.neonSoft,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Promote on homepage gallery',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: true,
                          activeThumbColor: Colors.white,
                          activeTrackColor: AppColors.neon,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: AppColors.border,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const ProductInputField(
                      label: 'Current Status',
                      hint: 'Published - Live',
                      suffix: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
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
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.menu_rounded)),
        const Spacer(),
        const Text(
          'KINETIC',
          style: TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontSize: 24,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text, {this.color = AppColors.neonSoft});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 24),
    );
  }
}
