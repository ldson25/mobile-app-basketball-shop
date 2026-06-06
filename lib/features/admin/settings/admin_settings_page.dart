import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/app_config_model.dart';
import '../../../models/banner_model.dart';
import '../../../models/shipping_rule_model.dart';
import '../../../services/admin_activity_log_service.dart';
import '../../../services/app_config_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/banner_service.dart';
import '../../../services/shipping_rule_service.dart';
import '../../../services/theme_service.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../../auth/presentation/login.dart';
import '../presentation/widgets/admin_widgets.dart';
import '../voucher_management/admin_voucher_management_page.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final configService = context.watch<AppConfigService>();
    final config = configService.config;

    return AdminPageScaffold(
      title: 'CÀI ĐẶT\nADMIN',
      subtitle: 'Cấu hình app, thanh toán, vận chuyển và log admin',
      trailing: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.neon),
      ),
      children: [
        AdminMetricCard(
          label: 'Trạng thái hệ thống',
          value: config.maintenanceMode ? 'bảo trì' : 'Đang hoạt động',
          icon: Icons.verified_rounded,
          delta: 'Tu app_config/settings',
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'App', title: 'Cấu hình chung'),
        const SizedBox(height: 14),
        _ThemeModeSwitch(),
        const SizedBox(height: 12),
        _SettingsSwitch(
          icon: Icons.construction_rounded,
          title: 'Maintenance mode',
          subtitle: 'Tạm khóa lượng mua hàng của user',
          value: config.maintenanceMode,
          onChanged: (value) =>
              _saveConfig(context, config.copyWith(maintenanceMode: value)),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(
          eyebrow: 'Thanh toán',
          title: 'Cổng thanh toán',
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
          icon: Icons.money_rounded,
          title: 'COD',
          subtitle: 'Cho phép thanh toán khi nhận hàng',
          value: config.codEnabled,
          onChanged: (value) =>
              _saveConfig(context, config.copyWith(codEnabled: value)),
        ),
        const SizedBox(height: 12),
        _SettingsSwitch(
          icon: Icons.account_balance_rounded,
          title: 'Chuyển khoản',
          subtitle: 'bật/tắt phương thức chuyển khoản',
          value: config.bankTransferEnabled,
          onChanged: (value) =>
              _saveConfig(context, config.copyWith(bankTransferEnabled: value)),
        ),
        const SizedBox(height: 12),
        _SettingsSwitch(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Ví điện tử',
          subtitle: 'bật/tắt ví điện tử, MoMo làm sau',
          value: config.eWalletEnabled,
          onChanged: (value) =>
              _saveConfig(context, config.copyWith(eWalletEnabled: value)),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.local_offer_rounded,
          title: 'Quản lý voucher',
          subtitle: 'Mã giảm giá và trạng thái voucher',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminVoucherManagementPage(),
              ),
            );
          },
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Giao hàng', title: 'Shipping rules'),
        const SizedBox(height: 14),
        _SettingsSwitch(
          icon: Icons.local_shipping_rounded,
          title: 'Free shipping',
          subtitle: 'bật/tắt miễn phí giao hàng',
          value: config.freeShippingEnabled,
          onChanged: (value) =>
              _saveConfig(context, config.copyWith(freeShippingEnabled: value)),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.map_rounded,
          title: 'Quản lý shipping rules',
          subtitle: 'Đọc từ collection shipping_rules',
          onTap: () => _showShippingSheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Nội dung', title: 'Banner và log'),
        const SizedBox(height: 14),
        _SettingsTile(
          icon: Icons.image_rounded,
          title: 'Banner management',
          subtitle: 'Đọc từ collection banners',
          onTap: () => _showBannerSheet(context),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.history_rounded,
          title: 'Admin activity logs',
          subtitle: 'Theo dõi thay đổi từ admin_logs',
          onTap: () => _showActivitySheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        GlowButton(
          label: 'ĐĂNG XUẤT ADMIN',
          icon: Icons.logout_rounded,
          expanded: true,
          isPrimary: false,
          onPressed: () => _signOut(context),
        ),
        const SizedBox(height: 72),
      ],
    );
  }

  Future<void> _saveConfig(BuildContext context, AppConfigModel config) {
    return context.read<AppConfigService>().saveConfig(config);
  }

  void _showShippingSheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Shipping rules',
      child: Consumer<ShippingRuleService>(
        builder: (context, service, child) {
          if (service.rules.isEmpty) {
            return GlowButton(
              label: 'TẠO RULE MẶC ĐỊNH',
              icon: Icons.cloud_upload_rounded,
              expanded: true,
              onPressed: service.seedDefaultRules,
            );
          }
          return Column(
            children: service.rules
                .map(
                  (rule) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ShippingRuleTile(rule: rule),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  void _showBannerSheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Banners',
      child: Consumer<BannerService>(
        builder: (context, service, child) {
          if (service.banners.isEmpty) {
            return GlowButton(
              label: 'TẠO BANNER MẶC ĐỊNH',
              icon: Icons.cloud_upload_rounded,
              expanded: true,
              onPressed: service.seedDefaultBanners,
            );
          }
          return Column(
            children: service.banners
                .map(
                  (banner) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _BannerConfig(
                      banner: banner,
                      onToggle: () => service.toggleBanner(banner.id),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  void _showActivitySheet(BuildContext context) {
    context.read<AdminActivityLogService>().ensureSubscribed();
    _showConfigSheet(
      context,
      title: 'Admin logs',
      child: Consumer<AdminActivityLogService>(
        builder: (context, service, child) {
          if (service.logs.isEmpty) {
            return const _EmptyConfigText(text: 'Chưa có admin log.');
          }
          return Column(
            children: service.logs
                .map(
                  (log) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ActivityTile(
                      text: '${log.actorEmail}: ${log.action}',
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  void _showConfigSheet(
    BuildContext context, {
    required String title,
    required Widget child,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminSectionTitle(eyebrow: 'Cấu hình', title: title),
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await context.read<AuthService>().logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}

class _ThemeModeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    return _SettingsSwitch(
      icon: Icons.light_mode_rounded,
      title: 'Light mode',
      subtitle: 'bật/tắt giao diện sáng cho admin và user',
      value: themeService.isLightMode,
      onChanged: themeService.setLightMode,
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

class _ShippingRuleTile extends StatelessWidget {
  const _ShippingRuleTile({required this.rule});

  final ShippingRuleModel rule;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showShippingRuleEditor(context, rule),
      child: SectionCard(
        color: AppColors.surface2,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.local_shipping_rounded, color: AppColors.neon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${rule.name} - ${rule.cost.round()}d',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            AdminStatusChip(
              label: rule.isActive ? 'On' : 'Off',
              color: rule.isActive ? AppColors.neon : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _showShippingRuleEditor(BuildContext context, ShippingRuleModel rule) {
    final nameController = TextEditingController(text: rule.name);
    final costController = TextEditingController(
      text: rule.cost.round().toString(),
    );
    var active = rule.isActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdminSectionTitle(eyebrow: 'Shipping', title: rule.method),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(labelText: 'Ten rule'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: costController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Phi giao hang',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: active,
                    onChanged: (value) => setState(() => active = value),
                    activeThumbColor: AppColors.neon,
                    title: const Text(
                      'Dang bat',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlowButton(
                    label: 'LUU SHIPPING RULE',
                    icon: Icons.save_rounded,
                    expanded: true,
                    onPressed: () {
                      context.read<ShippingRuleService>().saveRule(
                        ShippingRuleModel(
                          id: rule.id,
                          name: nameController.text.trim(),
                          method: rule.method,
                          cost:
                              double.tryParse(costController.text.trim()) ??
                              rule.cost,
                          area: rule.area,
                          isActive: active,
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BannerConfig extends StatelessWidget {
  const _BannerConfig({required this.banner, required this.onToggle});

  final BannerModel banner;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBannerEditor(context, banner),
      child: SectionCard(
        color: AppColors.surface2,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.image_rounded, color: AppColors.neon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                banner.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Switch(
              value: banner.isActive,
              onChanged: (_) => onToggle(),
              activeThumbColor: AppColors.neon,
            ),
          ],
        ),
      ),
    );
  }

  void _showBannerEditor(BuildContext context, BannerModel banner) {
    final titleController = TextEditingController(text: banner.title);
    final subtitleController = TextEditingController(text: banner.subtitle);
    final productIdController = TextEditingController(text: banner.productId);
    final sortController = TextEditingController(
      text: banner.sortOrder.toString(),
    );
    var active = banner.isActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdminSectionTitle(eyebrow: 'Banner', title: banner.id),
                  const SizedBox(height: 16),
                  _SheetInput(label: 'Title', controller: titleController),
                  const SizedBox(height: 12),
                  _SheetInput(
                    label: 'Subtitle',
                    controller: subtitleController,
                  ),
                  const SizedBox(height: 12),
                  _SheetInput(
                    label: 'Product ID',
                    controller: productIdController,
                  ),
                  const SizedBox(height: 12),
                  _SheetInput(label: 'Sort order', controller: sortController),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: active,
                    onChanged: (value) => setState(() => active = value),
                    activeThumbColor: AppColors.neon,
                    title: const Text(
                      'Dang bat',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlowButton(
                    label: 'LƯU BANNER',
                    icon: Icons.save_rounded,
                    expanded: true,
                    onPressed: () {
                      context.read<BannerService>().saveBanner(
                        BannerModel(
                          id: banner.id,
                          title: titleController.text.trim(),
                          subtitle: subtitleController.text.trim(),
                          imageUrl: banner.imageUrl,
                          imageAsset: banner.imageAsset,
                          productId: productIdController.text.trim(),
                          isActive: active,
                          sortOrder:
                              int.tryParse(sortController.text.trim()) ??
                              banner.sortOrder,
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  const _SheetInput({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label),
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
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyConfigText extends StatelessWidget {
  const _EmptyConfigText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface2,
      child: Text(text, style: const TextStyle(color: AppColors.textSecondary)),
    );
  }
}
