import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../models/payment_method_model.dart';
import '../../services/auth_service.dart';
import '../../services/payment_method_service.dart';
import '../cart/mycart.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key, required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _PaymentAppBar(onMenuTap: onMenuTap),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PHUONG THUC THANH TOAN',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hien tai app uu tien COD. Vi dien tu va the ngan hang se lam sau.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            if (!auth.isAuthenticated)
              const _PaymentMessageCard(
                icon: Icons.lock_outline_rounded,
                title: 'Can dang nhap',
                subtitle: 'Dang nhap de luu phuong thuc thanh toan cua ban.',
              )
            else
              Consumer<PaymentMethodService>(
                builder: (context, service, child) {
                  final methods = service.methods;
                  final cod = methods.where(
                    (method) => method.type == PaymentMethodType.cash,
                  );

                  return Column(
                    children: [
                      if (cod.isEmpty)
                        _PaymentActionCard(
                          icon: Icons.payments_rounded,
                          title: 'Thanh toan khi nhan hang',
                          subtitle: 'Tao va dat COD lam mac dinh',
                          trailing: const Icon(
                            Icons.add_circle_outline_rounded,
                            color: AppColors.neon,
                          ),
                          onTap: service.ensureCodMethod,
                        )
                      else
                        ...cod.map(
                          (method) => _SavedPaymentMethodCard(
                            method: method,
                            onSetDefault: () => service.setDefault(method.id),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const _ComingSoonPaymentCard(
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'Vi dien tu',
                        subtitle: 'MoMo se duoc tich hop sau',
                      ),
                      const SizedBox(height: 12),
                      const _ComingSoonPaymentCard(
                        icon: Icons.account_balance_rounded,
                        title: 'Chuyen khoan ngan hang',
                        subtitle: 'Se them sau khi hoan thien app',
                      ),
                      const SizedBox(height: 12),
                      const _ComingSoonPaymentCard(
                        icon: Icons.credit_card_rounded,
                        title: 'The ngan hang',
                        subtitle: 'Visa/Mastercard chua kich hoat',
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PaymentAppBar({required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.7),
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
      ),
      title: const Text(
        'THANH TOAN',
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 20,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: AppColors.neon,
        ),
      ),
      centerTitle: true,
      actions: [
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SavedPaymentMethodCard extends StatelessWidget {
  const _SavedPaymentMethodCard({
    required this.method,
    required this.onSetDefault,
  });

  final PaymentMethodModel method;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    return _PaymentActionCard(
      icon: Icons.payments_rounded,
      title: method.label,
      subtitle: method.isDefault
          ? 'Đang là mặc định'
          : 'Nhấn để đặt làm mặc định',
      trailing: method.isDefault
          ? const Icon(Icons.check_circle_rounded, color: AppColors.neon)
          : const Icon(Icons.radio_button_unchecked_rounded),
      onTap: method.isDefault ? null : onSetDefault,
    );
  }
}

class _ComingSoonPaymentCard extends StatelessWidget {
  const _ComingSoonPaymentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _PaymentActionCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: const Text(
        'SOON',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
      disabled: true,
      onTap: null,
    );
  }
}

class _PaymentActionCard extends StatelessWidget {
  const _PaymentActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: disabled ? AppColors.surface : AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: disabled
                ? AppColors.border.withOpacity(0.3)
                : AppColors.neon.withOpacity(0.24),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: disabled ? AppColors.textMuted : AppColors.neon,
              size: 28,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: disabled
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _PaymentMessageCard extends StatelessWidget {
  const _PaymentMessageCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _PaymentActionCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.info_outline_rounded),
      disabled: true,
      onTap: null,
    );
  }
}
