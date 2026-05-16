import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../../auth/presentation/login.dart';
import '../presentation/widgets/admin_widgets.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _maintenanceMode = false;
  bool _codEnabled = true;
  bool _bankTransferEnabled = true;
  bool _eWalletEnabled = true;
  bool _freeShippingEnabled = true;

  @override
  Widget build(BuildContext context) {
    return AdminPageScaffold(
      title: 'ADMIN\nSETTINGS',
      subtitle: 'Roles, payment, shipping and storefront config',
      children: [
        const AdminMetricCard(
          label: 'System status',
          value: 'Online',
          icon: Icons.verified_rounded,
          delta: 'Ready for Firebase integration',
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Store', title: 'App config'),
        const SizedBox(height: 14),
        _SettingsSwitch(
          icon: Icons.construction_rounded,
          title: 'Maintenance mode',
          subtitle: 'Temporarily lock user shopping flows',
          value: _maintenanceMode,
          onChanged: (value) => setState(() => _maintenanceMode = value),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.store_rounded,
          title: 'Store profile',
          subtitle: 'Store name, currency, support contact',
          onTap: () => _showStoreProfile(context),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.image_rounded,
          title: 'Home banners',
          subtitle: 'Hero banner, editorial blocks, active dates',
          onTap: () => _showBannerSheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Checkout', title: 'Payment methods'),
        const SizedBox(height: 14),
        _SettingsSwitch(
          icon: Icons.money_rounded,
          title: 'Cash on delivery',
          subtitle: 'Allow users to pay when receiving order',
          value: _codEnabled,
          onChanged: (value) => setState(() => _codEnabled = value),
        ),
        const SizedBox(height: 12),
        _SettingsSwitch(
          icon: Icons.account_balance_rounded,
          title: 'Bank transfer',
          subtitle: 'Manual confirmation after transfer',
          value: _bankTransferEnabled,
          onChanged: (value) => setState(() => _bankTransferEnabled = value),
        ),
        const SizedBox(height: 12),
        _SettingsSwitch(
          icon: Icons.account_balance_wallet_rounded,
          title: 'E-wallets',
          subtitle: 'MoMo, ZaloPay, VNPay integration',
          value: _eWalletEnabled,
          onChanged: (value) => setState(() => _eWalletEnabled = value),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Shipping', title: 'Delivery rules'),
        const SizedBox(height: 14),
        _SettingsSwitch(
          icon: Icons.local_shipping_rounded,
          title: 'Free standard shipping',
          subtitle: 'Default shipping policy for Viet Nam',
          value: _freeShippingEnabled,
          onChanged: (value) => setState(() => _freeShippingEnabled = value),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.map_rounded,
          title: 'Supported regions',
          subtitle: 'Cities, districts and delivery fees',
          onTap: () => _showShippingSheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Security', title: 'Admin roles'),
        const SizedBox(height: 14),
        _SettingsTile(
          icon: Icons.admin_panel_settings_rounded,
          title: 'Manage staff roles',
          subtitle: 'Admin, operations, customer care',
          onTap: () => _showRoleSheet(context),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.history_rounded,
          title: 'Activity log',
          subtitle: 'Audit changes from admin accounts',
          onTap: () => _showActivitySheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        GlowButton(
          label: 'SIGN OUT ADMIN',
          icon: Icons.logout_rounded,
          expanded: true,
          isPrimary: false,
          onPressed: () => _signOut(context),
        ),
        const SizedBox(height: 72),
      ],
    );
  }

  void _showStoreProfile(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Store profile',
      children: const [
        _ConfigInput(label: 'Store name', value: 'Kinetic'),
        SizedBox(height: 12),
        _ConfigInput(label: 'Currency', value: 'VND'),
        SizedBox(height: 12),
        _ConfigInput(label: 'Support phone', value: '1900 0000'),
      ],
    );
  }

  void _showBannerSheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Home banners',
      children: const [
        _BannerConfig(label: 'Hero banner', status: 'Active'),
        SizedBox(height: 10),
        _BannerConfig(label: 'Street series block', status: 'Scheduled'),
        SizedBox(height: 10),
        _BannerConfig(label: 'Best seller rail', status: 'Active'),
      ],
    );
  }

  void _showShippingSheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Shipping rules',
      children: const [
        _ConfigInput(label: 'Standard fee', value: '0'),
        SizedBox(height: 12),
        _ConfigInput(label: 'Express fee', value: '30000'),
        SizedBox(height: 12),
        _ConfigInput(label: 'Supported cities', value: 'Ho Chi Minh, Ha Noi'),
      ],
    );
  }

  void _showRoleSheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Admin roles',
      children: const [
        _RoleTile(email: 'admin@kinetic.app', role: 'Owner'),
        SizedBox(height: 10),
        _RoleTile(email: 'ops@kinetic.app', role: 'Operations'),
        SizedBox(height: 10),
        _RoleTile(email: 'care@kinetic.app', role: 'Customer care'),
      ],
    );
  }

  void _showActivitySheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Activity log',
      children: const [
        _ActivityTile(text: 'admin@kinetic.app changed shipping fee'),
        SizedBox(height: 10),
        _ActivityTile(text: 'ops@kinetic.app confirmed #ORD-8821'),
        SizedBox(height: 10),
        _ActivityTile(text: 'care@kinetic.app blocked Liam W.'),
      ],
    );
  }

  void _showConfigSheet(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
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
              AdminSectionTitle(eyebrow: 'Settings', title: title),
              const SizedBox(height: 18),
              ...children,
              const SizedBox(height: 18),
              GlowButton(
                label: 'SAVE SETTINGS',
                icon: Icons.save_rounded,
                expanded: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Sign out admin',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Do you want to leave the admin area?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'SIGN OUT',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    await context.read<AuthService>().logout();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SectionCard(
        color: AppColors.surface2,
        child: Row(
          children: [
            Icon(icon, color: AppColors.neon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      child: Row(
        children: [
          Icon(icon, color: AppColors.neon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
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

class _ConfigInput extends StatelessWidget {
  const _ConfigInput({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _BannerConfig extends StatelessWidget {
  const _BannerConfig({required this.label, required this.status});

  final String label;
  final String status;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.image_rounded, color: AppColors.neon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          AdminStatusChip(label: status, color: AppColors.neon),
        ],
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({required this.email, required this.role});

  final String email;
  final String role;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.admin_panel_settings_rounded, color: AppColors.neon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              email,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          AdminStatusChip(label: role, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, color: AppColors.neon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
