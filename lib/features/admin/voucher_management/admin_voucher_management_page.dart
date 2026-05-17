import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/voucher_model.dart';
import '../../../services/voucher_service.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../presentation/widgets/admin_widgets.dart';

class AdminVoucherManagementPage extends StatelessWidget {
  const AdminVoucherManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminPageScaffold(
      title: 'QUAN LY\nVOUCHER',
      subtitle: 'Ma giam gia cho Member, VIP va tat ca user',
      children: [
        GlowButton(
          label: 'THEM VOUCHER',
          icon: Icons.add_rounded,
          expanded: true,
          onPressed: () => _showVoucherForm(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        Consumer<VoucherService>(
          builder: (context, voucherService, child) {
            final vouchers = voucherService.vouchers;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vouchers.length} VOUCHER',
                  style: const TextStyle(
                    color: AppColors.neon,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                ...vouchers.map(
                  (voucher) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _VoucherCard(voucher: voucher),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showVoucherForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _VoucherFormSheet(),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  const _VoucherCard({required this.voucher});

  final VoucherModel voucher;

  @override
  Widget build(BuildContext context) {
    final voucherService = context.read<VoucherService>();

    return SectionCard(
      color: AppColors.surface2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  voucher.code,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AdminStatusChip(
                label: voucher.isActive ? 'Dang bat' : 'Da tat',
                color: voucher.isActive ? AppColors.neon : AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            voucher.name,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AdminStatusChip(label: voucher.discountLabel, color: AppColors.neon),
              AdminStatusChip(label: voucher.targetLabel, color: AppColors.textSecondary),
              AdminStatusChip(
                label: 'Tu ${voucher.minOrderValue.round()}d',
                color: AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _CircleAction(
                icon: voucher.isActive
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                onTap: () => voucherService.toggleVoucher(voucher.id),
              ),
              const SizedBox(width: 10),
              _CircleAction(
                icon: Icons.delete_outline_rounded,
                color: AppColors.error,
                onTap: () => voucherService.removeVoucher(voucher.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onTap,
    this.color = AppColors.textPrimary,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: AppColors.surfaceHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 19),
      ),
    );
  }
}

class _VoucherFormSheet extends StatefulWidget {
  const _VoucherFormSheet();

  @override
  State<_VoucherFormSheet> createState() => _VoucherFormSheetState();
}

class _VoucherFormSheetState extends State<_VoucherFormSheet> {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final valueController = TextEditingController();
  final minOrderController = TextEditingController(text: '0');
  VoucherDiscountType discountType = VoucherDiscountType.percent;
  VoucherTargetTier targetTier = VoucherTargetTier.all;

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    valueController.dispose();
    minOrderController.dispose();
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
            const AdminSectionTitle(eyebrow: 'Voucher', title: 'Tao ma giam gia'),
            const SizedBox(height: 18),
            _Input(label: 'Ma voucher', controller: codeController),
            const SizedBox(height: 12),
            _Input(label: 'Ten chuong trinh', controller: nameController),
            const SizedBox(height: 12),
            _Input(
              label: 'Gia tri giam',
              controller: valueController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _Input(
              label: 'Don toi thieu',
              controller: minOrderController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _EnumRow<VoucherDiscountType>(
              label: 'Loai giam',
              value: discountType,
              values: VoucherDiscountType.values,
              text: (value) => value.name,
              onChanged: (value) => setState(() => discountType = value),
            ),
            const SizedBox(height: 16),
            _EnumRow<VoucherTargetTier>(
              label: 'Ap dung cho',
              value: targetTier,
              values: VoucherTargetTier.values,
              text: (value) => value.name,
              onChanged: (value) => setState(() => targetTier = value),
            ),
            const SizedBox(height: 18),
            GlowButton(
              label: 'LUU VOUCHER',
              icon: Icons.save_rounded,
              expanded: true,
              onPressed: _saveVoucher,
            ),
          ],
        ),
      ),
    );
  }

  void _saveVoucher() {
    final code = codeController.text.trim().toUpperCase();
    final name = nameController.text.trim();
    final value = double.tryParse(valueController.text.trim()) ?? 0;
    final minOrder = double.tryParse(minOrderController.text.trim()) ?? 0;

    if (code.isEmpty || name.isEmpty || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhap day du thong tin voucher')),
      );
      return;
    }

    context.read<VoucherService>().addVoucher(
          VoucherModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            code: code,
            name: name,
            discountType: discountType,
            discountValue: value,
            minOrderValue: minOrder,
            targetTier: targetTier,
          ),
        );

    Navigator.pop(context);
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _EnumRow<T> extends StatelessWidget {
  const _EnumRow({
    required this.label,
    required this.value,
    required this.values,
    required this.text,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) text;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((item) {
            final active = item == value;
            return ChoiceChip(
              label: Text(text(item)),
              selected: active,
              onSelected: (_) => onChanged(item),
              selectedColor: AppColors.neon,
              labelStyle: TextStyle(
                color: active ? AppColors.background : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
              backgroundColor: AppColors.surface2,
              side: const BorderSide(color: AppColors.border),
            );
          }).toList(),
        ),
      ],
    );
  }
}
