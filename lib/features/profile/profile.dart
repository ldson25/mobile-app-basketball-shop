// lib/features/profile/profile.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import '../cart/mycart.dart';
import '../favorites/favorites.dart';
import '../shipping_adresses/shipping_adresses.dart';
import '../payment/payment.dart';
import '../auth/presentation/login.dart';
import '../vouchers/voucher_wallet_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onMenuTap;

  const ProfileScreen({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // Force rebuild on theme change
    return Scaffold(
      appBar: _CustomAppBar(onMenuTap: onMenuTap),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const _ProfileHeader(),
              const SizedBox(height: 40),
              _NavigationMenu(onMenuTap: onMenuTap),
              const SizedBox(height: 40),
              const _SignOutButton(),
              const SizedBox(height: 112),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(179),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onMenuTap,
                icon: Icon(Icons.menu, color: AppColors.textPrimary),
              ),
              Text(
                'HỒ SƠ',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                  color: AppColors.neon,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  Future<void> _showAvatarSourceSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'CẬP NHẬT ẢNH ĐẠI DIỆN',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _AvatarSourceTile(
                  icon: Icons.photo_library_rounded,
                  label: 'Chọn từ thư viện',
                  onTap: () {
                    Navigator.pop(context);
                    _pickAvatar(context, ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 10),
                _AvatarSourceTile(
                  icon: Icons.photo_camera_rounded,
                  label: 'Chụp ảnh mới',
                  onTap: () {
                    Navigator.pop(context);
                    _pickAvatar(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAvatar(BuildContext context, ImageSource source) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final picker = ImagePicker();

    try {
      final image = await picker.pickImage(
        source: source,
        maxWidth: 900,
        maxHeight: 900,
        imageQuality: 85,
      );

      if (image == null) return;

      authService.updateAvatar(image.path);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể cập nhật ảnh đại diện')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final avatarUrl = user?.avatarUrl;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.neon,
                  width: 4,
                ),
              ),
              child: ClipOval(
                child: avatarUrl != null
                    ? avatarUrl.startsWith('http')
                        ? Image.network(
                            avatarUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const _AvatarFallback(),
                          )
                        : Image.file(
                            File(avatarUrl),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const _AvatarFallback(),
                          )
                    : Image.asset(
                        'assets/images/profile/avatar.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const _AvatarFallback(),
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showAvatarSourceSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.neon,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          user?.fullName.toUpperCase() ?? 'KHÁCH',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user?.email ?? 'Chưa có email',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neon.withAlpha(51),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.neon),
          ),
          child: Text(
            user?.membershipLabel ?? 'MEMBER',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: AppColors.neon,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showAvatarSourceSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.neon,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'SỬA HỒ SƠ',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: AppColors.background,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavigationMenu extends StatelessWidget {
  final VoidCallback onMenuTap;

  const _NavigationMenu({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Icons.favorite,
          label: 'Yêu thích',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesScreen(onMenuTap: onMenuTap),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _MenuItem(
          icon: Icons.location_on,
          label: 'Địa chỉ giao hàng',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShippingAddressesScreen(onMenuTap: onMenuTap),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _MenuItem(
          icon: Icons.credit_card,
          label: 'Phương thức thanh toán',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentMethodsScreen(onMenuTap: onMenuTap),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _MenuItem(
          icon: Icons.local_offer_rounded,
          label: 'Voucher của tôi',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VoucherWalletScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _MenuItem(
          icon: Icons.settings,
          label: 'Cài đặt',
          onTap: () => _showProfileSettings(context),
        ),
      ],
    );
  }

  void _showProfileSettings(BuildContext context) {
    final auth = context.read<AuthService>();
    final user = auth.currentUser;
    if (user == null) return;

    final nameController = TextEditingController(text: user.fullName);
    final phoneController = TextEditingController(text: user.phoneNumber ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
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
              Text(
                'CAI DAT TAI KHOAN',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(labelText: 'Ho ten'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(labelText: 'So dien thoai'),
              ),
              const SizedBox(height: 12),
              Consumer<ThemeService>(
                builder: (context, themeService, child) {
                  return SwitchListTile(
                    value: !themeService.isLightMode,
                    onChanged: (val) => themeService.setLightMode(!val),
                    activeThumbColor: AppColors.neon,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Dark mode',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      'Bật/tắt giao diện tối',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<AuthService>().updateProfile(
                          fullName: nameController.text,
                          phoneNumber: phoneController.text,
                        );
                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('LUU'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.neon,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        // Show confirmation dialog
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text(
              'Đăng xuất',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: Text(
              'Bạn có chắc muốn đăng xuất?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('HỦY'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'ĐĂNG XUẤT',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await authService.logout();
          if (!context.mounted) return;
          // Navigate to login screen and remove all previous screens
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border.withAlpha(51)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: 18,
              color: AppColors.error,
            ),
            const SizedBox(width: 8),
            Text(
              'ĐĂNG XUẤT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Container(
      color: AppColors.surface2,
      child: const Icon(
        Icons.person,
        size: 60,
        color: Colors.grey,
      ),
    );
  }
}

class _AvatarSourceTile extends StatelessWidget {
  const _AvatarSourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.neon,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.background),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
    );
  }
}
