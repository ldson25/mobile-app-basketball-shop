import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/admin_navigation_provider.dart';
import '../customer_management/customer_management_page.dart';
import '../dashboard/admin_dashboard_page.dart';
import '../order_management/admin_order_management_page.dart';
import '../product_management/admin_product_management_page.dart';
import '../settings/admin_settings_page.dart';
import 'admin_bottom_nav.dart';

class AdminShell extends ConsumerWidget {
  const AdminShell({super.key});

  static const routeName = '/admin';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminTabIndexProvider);

    const pages = <Widget>[
      AdminDashboardPage(),
      AdminProductManagementPage(),
      AdminOrderManagementPage(),
      AdminCustomerManagementPage(),
      AdminSettingsPage(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(adminTabIndexProvider.notifier).state = index,
      ),
    );
  }
}
