import 'package:doanltdd/features/discover/discover.dart';
import 'package:doanltdd/features/homeuser/homeuser.dart';
import 'package:doanltdd/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/sign_up_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/app_shell/presentation/app_shell.dart';
import 'features/auth/presentation/login.dart';
import 'features/homeuser/homeuser.dart';
import 'features/discover/discover.dart';
import 'features/orderhistory/orderhistory.dart';
import 'features/profile/profile.dart';
import 'features/cart/mycart.dart';
import '../services/cart_service.dart';
import '../services/favorites_service.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KineticApp());
}

class KineticApp extends StatelessWidget {
  const KineticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create:  (_) => FavoritesService()),
        ChangeNotifierProvider(create:  (_) => OrderService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kinetic',
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    if (authService.isAuthenticated) {
      return const AppShell();
    }
    
    return const LoginScreen();
  }
}
