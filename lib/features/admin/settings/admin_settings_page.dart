import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/glow_button.dart';
import '../../../widgets/section_card.dart';
import '../../auth/presentation/login.dart';
import '../presentation/widgets/admin_widgets.dart';
import '../voucher_management/admin_voucher_management_page.dart';

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
      title: 'CÀI ĐẶT\nADMIN',
      subtitle: 'Quyền truy cập, thanh toán, giao hàng và cấu hình cửa hàng',
      children: [
        const AdminMetricCard(
          label: 'Trạng thái hệ thống',
          value: 'Đang hoạt động',
          icon: Icons.verified_rounded,
          delta: 'Sẵn sàng tích hợp Firebase',
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Cửa hàng', title: 'Cấu hình app'),
        const SizedBox(height: 14),
        _SettingsSwitch(
          icon: Icons.construction_rounded,
          title: 'Chế độ bảo trì',
          subtitle: 'Tạm khóa luồng mua hàng của user',
          value: _maintenanceMode,
          onChanged: (value) => setState(() => _maintenanceMode = value),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.store_rounded,
          title: 'Hồ sơ cửa hàng',
          subtitle: 'Tên cửa hàng, tiền tệ, liên hệ hỗ trợ',
          onTap: () => _showStoreProfile(context),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.image_rounded,
          title: 'Banner trang chủ',
          subtitle: 'Hero banner, khối nội dung, thời gian hiển thị',
          onTap: () => _showBannerSheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Thanh toán', title: 'Phương thức thanh toán'),
        const SizedBox(height: 14),
        _SettingsSwitch(
          icon: Icons.money_rounded,
          title: 'Thanh toán khi nhận hàng',
          subtitle: 'Cho phép user thanh toán khi nhận đơn',
          value: _codEnabled,
          onChanged: (value) => setState(() => _codEnabled = value),
        ),
        const SizedBox(height: 12),
        _SettingsSwitch(
          icon: Icons.account_balance_rounded,
          title: 'Chuyển khoản ngân hàng',
          subtitle: 'Admin xác nhận thủ công sau khi chuyển khoản',
          value: _bankTransferEnabled,
          onChanged: (value) => setState(() => _bankTransferEnabled = value),
        ),
        const SizedBox(height: 12),
        _SettingsSwitch(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Ví điện tử',
          subtitle: 'Tích hợp MoMo, ZaloPay, VNPay',
          value: _eWalletEnabled,
          onChanged: (value) => setState(() => _eWalletEnabled = value),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.local_offer_rounded,
          title: 'Quan ly voucher',
          subtitle: 'Ma giam gia cho Member, VIP va tat ca user',
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
        const AdminSectionTitle(eyebrow: 'Giao hàng', title: 'Quy tắc vận chuyển'),
        const SizedBox(height: 14),
        _SettingsSwitch(
          icon: Icons.local_shipping_rounded,
          title: 'Miễn phí giao hàng tiêu chuẩn',
          subtitle: 'Chính sách mặc định tại Việt Nam',
          value: _freeShippingEnabled,
          onChanged: (value) => setState(() => _freeShippingEnabled = value),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.map_rounded,
          title: 'Khu vực hỗ trợ',
          subtitle: 'Tỉnh thành, quận huyện và phí giao hàng',
          onTap: () => _showShippingSheet(context),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        const AdminSectionTitle(eyebrow: 'Bảo mật', title: 'Quyền admin'),
        const SizedBox(height: 14),
        _SettingsTile(
          icon: Icons.admin_panel_settings_rounded,
          title: 'Quản lý quyền nhân sự',
          subtitle: 'Admin, vận hành, chăm sóc khách hàng',
          onTap: () => _showRoleSheet(context),
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.history_rounded,
          title: 'Nhật ký hoạt động',
          subtitle: 'Theo dõi thay đổi từ tài khoản admin',
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

  void _showStoreProfile(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Hồ sơ cửa hàng',
      children: const [
        _ConfigInput(label: 'Tên cửa hàng', value: 'Kinetic'),
        SizedBox(height: 12),
        _ConfigInput(label: 'Tiền tệ', value: 'VND'),
        SizedBox(height: 12),
        _ConfigInput(label: 'Số hỗ trợ', value: '1900 0000'),
      ],
    );
  }

  void _showBannerSheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Banner trang chủ',
      children: const [
        _BannerConfig(label: 'Hero banner', status: 'Đang bật'),
        SizedBox(height: 10),
        _BannerConfig(label: 'Khối Street series', status: 'Đã lên lịch'),
        SizedBox(height: 10),
        _BannerConfig(label: 'Dải bán chạy', status: 'Đang bật'),
      ],
    );
  }

  void _showShippingSheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Quy tắc giao hàng',
      children: const [
        _ConfigInput(label: 'Phí tiêu chuẩn', value: '0'),
        SizedBox(height: 12),
        _ConfigInput(label: 'Phí giao nhanh', value: '30000'),
        SizedBox(height: 12),
        _ConfigInput(label: 'Tỉnh thành hỗ trợ', value: 'TP. Hồ Chí Minh, Hà Nội'),
      ],
    );
  }

  void _showRoleSheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Quyền admin',
      children: const [
        _RoleTile(email: 'admin@kinetic.app', role: 'Chủ sở hữu'),
        SizedBox(height: 10),
        _RoleTile(email: 'ops@kinetic.app', role: 'Vận hành'),
        SizedBox(height: 10),
        _RoleTile(email: 'care@kinetic.app', role: 'CSKH'),
      ],
    );
  }

  void _showActivitySheet(BuildContext context) {
    _showConfigSheet(
      context,
      title: 'Nhật ký hoạt động',
      children: const [
        _ActivityTile(text: 'admin@kinetic.app đã đổi phí giao hàng'),
        SizedBox(height: 10),
        _ActivityTile(text: 'ops@kinetic.app đã xác nhận #ORD-8821'),
        SizedBox(height: 10),
        _ActivityTile(text: 'care@kinetic.app đã khóa Phạm An'),
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
              AdminSectionTitle(eyebrow: 'Cài đặt', title: title),
              const SizedBox(height: 18),
              ...children,
              const SizedBox(height: 18),
              GlowButton(
                label: 'LƯU CÀI ĐẶT',
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
          'Đăng xuất admin',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Bạn có muốn rời khỏi khu vực admin không?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('HỦY'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'ĐĂNG XUẤT',
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
