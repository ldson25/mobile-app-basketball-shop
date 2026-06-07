import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../models/voucher_model.dart';
import '../../services/auth_service.dart';
import '../../services/voucher_service.dart';

class VoucherWalletScreen extends StatelessWidget {
  const VoucherWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
        ),
        title: GestureDetector(
          onTap: () {
            context.read<VoucherService>().seedDefaultVouchers().then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đẩy 15 mã lên Firebase thành công!')),
              );
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi tải lên Firebase: $e')),
              );
            });
          },
          child: Text(
            'VOUCHER CỦA BẠN',
            style: TextStyle(
              color: AppColors.neon,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
      body: Consumer<VoucherService>(
        builder: (context, service, child) {
          final user = context.watch<AuthService>().currentUser;
          final userTier =
              user?.isVip == true ? VoucherTargetTier.vip : VoucherTargetTier.member;
          final vouchers = service.vouchers
              .where(
                (voucher) =>
                    voucher.isActive &&
                    (voucher.targetTier == VoucherTargetTier.all ||
                        voucher.targetTier == userTier),
              )
              .toList();

          if (vouchers.isEmpty) {
            return Center(
              child: Text(
                'Hiện chưa có voucher khả dụng.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            itemCount: vouchers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) => _VoucherTile(voucher: vouchers[index]),
          );
        },
      ),
    );
  }
}

class _VoucherTile extends StatelessWidget {
  const _VoucherTile({required this.voucher});

  final VoucherModel voucher;

  @override
  Widget build(BuildContext context) {
    final bool isPercent = voucher.discountType == VoucherDiscountType.percent;
    final String highlight = isPercent
        ? '${voucher.discountValue.toInt()}%'
        : (voucher.discountType == VoucherDiscountType.freeShipping
            ? 'FREE'
            : '${(voucher.discountValue / 1000).toInt()}K');

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Ticket stub
          Container(
            width: 105,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.neon,
                  AppColors.neon.withOpacity(0.75),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    voucher.discountType == VoucherDiscountType.freeShipping
                        ? Icons.local_shipping_rounded
                        : Icons.local_activity_rounded,
                    color: AppColors.background,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    highlight,
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Space Grotesk',
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Dashed line separator
          SizedBox(
            width: 1,
            height: double.infinity,
            child: CustomPaint(
              painter: _DashedLinePainter(color: AppColors.border),
            ),
          ),
          // Right content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        voucher.code,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Space Grotesk',
                          letterSpacing: 1.0,
                        ),
                      ),
                      Icon(Icons.info_outline_rounded, color: AppColors.textMuted, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    voucher.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _Badge(text: voucher.targetLabel, isPrimary: true),
                      _Badge(text: 'Từ ${_formatVnd(voucher.minOrderValue)}', isPrimary: false),
                    ],
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

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 6, dashSpace = 4, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, this.isPrimary = false});

  final String text;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.neon.withOpacity(0.12) : AppColors.surfaceHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPrimary ? AppColors.neon.withOpacity(0.5) : Colors.transparent,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? AppColors.neon : AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

String _formatVnd(double value) {
  final number = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < number.length; i++) {
    final fromEnd = number.length - i;
    buffer.write(number[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
  }
  return '${buffer}đ';
}
