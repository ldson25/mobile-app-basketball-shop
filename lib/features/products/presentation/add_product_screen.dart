import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'INVENTORY MANAGEMENT',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ADD PRODUCT',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 42,
                  height: 0.92,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: AppButton(text: 'CANCEL', primary: false),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(text: 'SAVE PRODUCT', onTap: () {}),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const AppCard(child: _ProductForm()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('CORE DETAILS'),
        const SizedBox(height: 18),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Product name',
            hintText: 'e.g. Kinetic Air Zoom X',
          ),
        ),
        const SizedBox(height: 18),
        DropdownButtonFormField<String>(
          initialValue: 'Signature',
          dropdownColor: AppColors.surface3,
          style: GoogleFonts.inter(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Category'),
          items: const [
            DropdownMenuItem(value: 'Signature', child: Text('Signature')),
            DropdownMenuItem(value: 'Performance', child: Text('Performance')),
            DropdownMenuItem(value: 'Lifestyle', child: Text('Lifestyle')),
          ],
          onChanged: (_) {},
        ),
        const SizedBox(height: 18),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Price (USD)',
            hintText: '0.00',
          ),
        ),
        const SizedBox(height: 18),
        const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Editorial description',
            hintText: 'Enter high-impact product narrative...',
          ),
        ),
        const SizedBox(height: 28),
        _label('INVENTORY & LOGISTICS'),
        const SizedBox(height: 18),
        const TextField(
          decoration: InputDecoration(labelText: 'SKU', hintText: 'KNT-000-00'),
        ),
        const SizedBox(height: 18),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Initial stock level',
            hintText: '0',
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.outline.withOpacity(0.35),
              style: BorderStyle.solid,
            ),
            color: Colors.black,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    color: AppColors.surface3,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.volt,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'UPLOAD HERO IMAGE',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        color: const Color(0xFFF4FFC9),
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
    );
  }
}
