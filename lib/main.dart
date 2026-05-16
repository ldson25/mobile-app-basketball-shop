import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider, Provider;
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/presentation/admin_shell.dart';
import 'features/app_shell/presentation/app_shell.dart';
import 'features/auth/presentation/login.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'services/favorites_service.dart';
import 'services/order_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: KineticApp()));
}

class KineticApp extends StatelessWidget {
  const KineticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => FavoritesService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kinetic',
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
        routes: {
          AdminShell.routeName: (_) => const AdminShell(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser;

    if (authService.isAuthenticated) {
      if (currentUser?.isAdmin ?? false) {
        return const AdminShell();
      }

      return const AppShell();
    }

    return const LoginScreen();
  }
}
