import 'package:flutter/material.dart';

import '../../../widgets/kinetic_bottom_nav.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../editorial/presentation/editorial_screen.dart';
import '../../gallery/presentation/gallery_filter_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../products/presentation/add_product_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        onOpenEditorial: () => setState(() => currentIndex = 3),
        onOpenGallery: () => setState(() => currentIndex = 1),
      ),
      const GalleryFilterScreen(),
      const AddProductScreen(),
      const EditorialScreen(),
      const DashboardScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      extendBody: true,
      bottomNavigationBar: KineticBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
