import 'package:doanltdd/features/discover/discover.dart';
import 'package:doanltdd/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/kinetic_bottom_nav.dart';
import '../../homeuser/homeuser.dart';
import '../../orderhistory/orderhistory.dart';
import '../../menudrawer/menudrawer.dart';
import '../../../services/auth_service.dart'; // import service thật

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget?> _screenCache = List<Widget?>.filled(4, null);

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<bool> _requireAuth() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isAuthenticated) return true;

    final shouldLogin = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu đăng nhập'),
        content: const Text('Bạn cần đăng nhập để thực hiện chức năng này.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Để sau'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );

    if (shouldLogin == true) {
      // Điều hướng tới màn hình login
      final result = await Navigator.pushNamed(context, '/login');
      if (result == true) {
        setState(() {});
        return true;
      }
    }
    return false;
  }

  void _onTabTapped(int index) {
    final requiresAuth = (index == 2 || index == 3);
    if (requiresAuth) {
      _requireAuth().then((success) {
        if (success && mounted) {
          setState(() => currentIndex = index);
        }
      });
    } else {
      setState(() => currentIndex = index);
    }
  }

  void _onMenuItemSelected(int index) {
    final requiresAuth = (index == 2 || index == 3);
    if (requiresAuth) {
      _requireAuth().then((success) {
        if (success && mounted) {
          setState(() => currentIndex = index);
          _scaffoldKey.currentState?.closeDrawer();
        }
      });
    } else {
      setState(() => currentIndex = index);
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenCache[currentIndex] ??= _buildScreen(currentIndex);
    final screens = List<Widget>.generate(
      4,
      (index) => _screenCache[index] ?? const SizedBox.shrink(),
    );
    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(index: currentIndex, children: screens),
      extendBody: true,
      bottomNavigationBar: KineticBottomNav(
        currentIndex: currentIndex,
        onTap: _onTabTapped,
      ),
      drawer: MenuDrawer(onMenuItemTap: _onMenuItemSelected),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeUserScreen(onMenuTap: openDrawer, onRequireAuth: _requireAuth);
      case 1:
        return DiscoverScreen(onMenuTap: openDrawer, onRequireAuth: _requireAuth);
      case 2:
        return OrderHistoryScreen(onMenuTap: openDrawer);
      case 3:
        return ProfileScreen(onMenuTap: openDrawer);
      default:
        return HomeUserScreen(onMenuTap: openDrawer, onRequireAuth: _requireAuth);
    }
  }
}
