import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
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
                      child: avatarUrl != null
                          ? avatarUrl.startsWith('http')
                              ? Image.network(
                                  avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const _DrawerAvatarFallback(),
                                )
                              : Image.file(
                                  File(avatarUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
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
                        Text(
                          user?.fullName.toUpperCase() ?? 'GUEST USER',
                          style: const TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'Not signed in',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user?.isEarlyAccess ?? false)
                          const SizedBox(height: 4),
                        if (user?.isEarlyAccess ?? false)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.neon.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'ELITE',
                              style: TextStyle(
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
              label: 'Home',
              onTap: () => onMenuItemTap(0),
            ),
            _MenuDrawerItem(
              icon: Icons.search,
              label: 'Discover',
              onTap: () => onMenuItemTap(1),
            ),
            _MenuDrawerItem(
              icon: Icons.shopping_bag,
              label: 'My Cart',
              onTap: () {
                final rootNavigator = Navigator.of(context, rootNavigator: true);
                Navigator.pop(context);
                rootNavigator.push(
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            _MenuDrawerItem(
              icon: Icons.person,
              label: 'Profile',
              onTap: () => onMenuItemTap(3),
            ),
            const Divider(color: AppColors.border, height: 32),
            // Other Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'OTHER',
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
              label: 'Settings',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon!')),
                );
              },
            ),
            _MenuDrawerItem(
              icon: Icons.help_outline,
              label: 'Support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon!')),
                );
              },
            ),
            _MenuDrawerItem(
              icon: Icons.info_outline,
              label: 'About Us',
              onTap: () {
                final rootNavigator = Navigator.of(context, rootNavigator: true);
                Navigator.pop(context);
                rootNavigator.push(
                  MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                );
              },
            ),
            const Spacer(),
            // Sign Out button at bottom
            const Divider(color: AppColors.border),
            _MenuDrawerItem(
              icon: Icons.logout,
              label: 'Sign Out',
              onTap: () async {
                final rootNavigator = Navigator.of(context, rootNavigator: true);
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );

                // Close drawer first
                Navigator.pop(context);

                // Show confirmation dialog
                final confirm = await showDialog<bool>(
                  context: rootNavigator.context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Are you sure you want to sign out?',
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

                if (confirm == true) {
                  await authService.logout();

                  // Navigate to login screen and remove all previous screens
                  rootNavigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
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
      child: const Icon(
        Icons.person,
        size: 30,
        color: Colors.grey,
      ),
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
      trailing: label != 'Sign Out'
          ? const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
