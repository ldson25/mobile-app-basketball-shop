import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/section_card.dart';
import '../../../../widgets/kinetic_bottom_nav.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
        ),
        title: const Text(
          'MY KINETIC',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.pagePadding,
          16,
          AppSizes.pagePadding,
          32,
        ),
        children: [
          // ── Avatar ──
          const _ProfileHeader(),
          const SizedBox(height: 24),

          // ── Stats ──
          const _StatsRow(),
          const SizedBox(height: 20),

          // ── Loyalty Progress ──
          const _LoyaltyCard(),
          const SizedBox(height: 20),

          // ── Menu ──
          const _MenuList(),
          const SizedBox(height: 20),

          // ── Sign Out ──
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 16,
            ),
            label: const Text(
              'SIGN OUT',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 1.6,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.border.withOpacity(0.2)),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 18),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.neon, width: 3),
                color: Colors.black,
              ),
              child: ClipOval(
                child: Container(
                  color: AppColors.surface3,
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.textMuted,
                    size: 54,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.neon,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Alex Rivera',
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.neon,
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              ),
              child: const Text(
                'ELITE MEMBER',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'LVL 42',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    const stats = [
      _Stat(value: '12', label: 'ORDERS'),
      _Stat(value: '48', label: 'LIKED'),
      _Stat(value: '2.4k', label: 'POINTS'),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: SectionCard(
            child: Column(
              children: [
                Text(
                  s.value,
                  style: const TextStyle(
                    color: AppColors.neon,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Stat {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});
}

class _LoyaltyCard extends StatelessWidget {
  const _LoyaltyCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      color: AppColors.surface3,
      child: Stack(
        children: [
          const Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.workspace_premium_rounded,
                size: 100,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEXT MILESTONE',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'KINETIC PRO',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '600 ',
                          style: TextStyle(
                            color: AppColors.neon,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: 'PTS TO GO',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                child: LinearProgressIndicator(
                  value: 0.75,
                  minHeight: 8,
                  backgroundColor: Colors.black,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.neon,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    const items = [
      _MenuItem(icon: Icons.shopping_cart_rounded, label: 'My Orders'),
      _MenuItem(icon: Icons.favorite_rounded, label: 'Favorites'),
      _MenuItem(icon: Icons.location_on_rounded, label: 'Shipping Addresses'),
      _MenuItem(icon: Icons.credit_card_rounded, label: 'Payment Methods'),
      _MenuItem(icon: Icons.settings_rounded, label: 'Settings'),
    ];

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SectionCard(
                child: Row(
                  children: [
                    Icon(item.icon, color: AppColors.neon, size: 22),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}
