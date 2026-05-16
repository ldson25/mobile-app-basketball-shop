import 'package:doanltdd/features/discover/discover.dart';
import 'package:doanltdd/features/profile/profile.dart';
import 'package:flutter/material.dart';
import '../../../widgets/kinetic_bottom_nav.dart';
import '../../homeuser/homeuser.dart';
import '../../discover/discover.dart';
import '../../orderhistory/orderhistory.dart';
import '../../profile/profile.dart';
import '../../menudrawer/menudrawer.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeUserScreen(onMenuTap: openDrawer), 
      DiscoverScreen(onMenuTap: openDrawer),
      OrderHistoryScreen(onMenuTap: openDrawer), 
      ProfileScreen(onMenuTap: openDrawer), 
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(index: currentIndex, children: screens),
      extendBody: true,
      bottomNavigationBar: KineticBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
      drawer: MenuDrawer(
        onMenuItemTap: (index) {
          setState(() {
            currentIndex = index;
          });
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }
}