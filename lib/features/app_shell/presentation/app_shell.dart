import 'package:flutter/material.dart';

import '../../../widgets/kinetic_bottom_nav.dart';

// SCREENS
import '../../home/presentation/home_screen.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../orders/presentation/pages/order_history_screen.dart';
import '../../profile/presentation/pages/user_profile_screen.dart';
import '../../editorial/presentation/editorial_screen.dart';
import '../../gallery/presentation/gallery_filter_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  void _navigateTo(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      /// HOME
      HomeScreen(
        onOpenEditorial: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditorialScreen()),
          );
        },

        /// 👉 chuyển sang tab Gallery (Admin nếu bạn muốn đổi)
        onOpenGallery: () => _navigateTo(1),
      ),

      /// ADMIN / DASHBOARD
      const DashboardScreen(),

      /// ORDERS
      const OrderHistoryScreen(),

      /// PROFILE
      const UserProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),

      extendBody: true,

      bottomNavigationBar: KineticBottomNav(
        currentIndex: currentIndex,
        onTap: _navigateTo,
      ),
    );
  }
}
