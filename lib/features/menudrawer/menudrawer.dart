import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../about/about_us.dart';
import '../cart/mycart.dart';
import '../auth/presentation/login.dart';

class MenuDrawer extends StatelessWidget {
  final Function(int) onMenuItemTap;

  const MenuDrawer({super.key, required this.onMenuItemTap});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final avatarUrl = user?.avatarUrl;
    final isLoggedIn = authService.isAuthenticated;

    return Drawer(
      backgroundColor: AppColors.surface2,
      child: SafeArea(
        child: Column(
          children: [
            // User Header - Dynamic from AuthService
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.neon, width: 2),
                    ),
                    child: ClipOval(
                      child: isLoggedIn && avatarUrl != null
                          ? avatarUrl.startsWith('http')
                                ? Image.network(
                                    avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const _DrawerAvatarFallback(),
                                  )
                                : Image.file(
                                    File(avatarUrl),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const _DrawerAvatarFallback(),
                                  )
                          : Image.asset(
                              'assets/images/profile/avatar.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const _DrawerAvatarFallback(),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isLoggedIn
                                    ? (user?.fullName.toUpperCase() ?? 'KHÁCH')
                                    : 'KHÁCH',
                                style: const TextStyle(
                                  fontFamily: 'Space Grotesk',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Nút Đăng nhập / Đăng xuất
                            GestureDetector(
                              onTap: () async {
                                if (isLoggedIn) {
                                  // Đăng xuất
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: AppColors.surface,
                                      title: const Text(
                                        'Đăng xuất',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: const Text(
                                        'Bạn có chắc muốn đăng xuất?',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('HỦY'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text(
                                            'ĐĂNG XUẤT',
                                            style: TextStyle(
                                              color: AppColors.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await authService.logout();
                                    // Đóng drawer và refresh lại UI
                                    Navigator.pop(context);
                                  }
                                } else {
                                  // Đăng nhập: điều hướng sang màn hình login và chờ kết quả
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                  if (result == true) {
                                    // Đăng nhập thành công, drawer sẽ tự rebuild nhờ Provider
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.neon,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isLoggedIn ? 'ĐĂNG XUẤT' : 'ĐĂNG NHẬP',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.background,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLoggedIn ? (user?.email ?? '') : 'Chưa đăng nhập',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isLoggedIn) const SizedBox(height: 4),
                        if (isLoggedIn)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.neon.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              user?.membershipLabel ?? 'MEMBER',
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: AppColors.neon,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Menu Items
            _MenuDrawerItem(
              icon: Icons.home,
              label: 'Trang chủ',
              onTap: () => onMenuItemTap(0),
            ),
            _MenuDrawerItem(
              icon: Icons.search,
              label: 'Khám phá',
              onTap: () => onMenuItemTap(1),
            ),
            _MenuDrawerItem(
              icon: Icons.shopping_bag,
              label: 'Giỏ hàng',
              onTap: () {
                final rootNavigator = Navigator.of(
                  context,
                  rootNavigator: true,
                );
                Navigator.pop(context);
                rootNavigator.push(
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            _MenuDrawerItem(
              icon: Icons.person,
              label: 'Hồ sơ',
              onTap: () => onMenuItemTap(3),
            ),
            const Divider(color: AppColors.border, height: 32),
            // Other Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'KHÁC',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _MenuDrawerItem(
              icon: Icons.settings,
              label: 'Cài đặt',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng sẽ được bổ sung sau'),
                  ),
                );
              },
            ),
            _MenuDrawerItem(
              icon: Icons.help_outline,
              label: 'Hỗ trợ',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng sẽ được bổ sung sau'),
                  ),
                );
              },
            ),
            _MenuDrawerItem(
              icon: Icons.info_outline,
              label: 'Về chúng tôi',
              onTap: () {
                final rootNavigator = Navigator.of(
                  context,
                  rootNavigator: true,
                );
                Navigator.pop(context);
                rootNavigator.push(
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerAvatarFallback extends StatelessWidget {
  const _DrawerAvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: const Icon(Icons.person, size: 30, color: Colors.grey),
    );
  }
}

class _MenuDrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuDrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.neon),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      trailing: label != 'Đăng xuất'
          ? const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
