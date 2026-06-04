import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider, Provider;
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/presentation/admin_shell.dart';
import 'features/app_shell/presentation/app_shell.dart';
import 'features/auth/presentation/login.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'services/favorites_service.dart';
import 'services/order_service.dart';
import 'services/shipping_address_service.dart';
import 'services/voucher_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (_) => ShippingAddressService()),
        ChangeNotifierProvider(create: (_) => VoucherService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kinetic',
        theme: AppTheme.darkTheme,
        home: const AppShell(),
        routes: {
          AdminShell.routeName: (_) => const AdminShell(),
          '/login': (_) => const LoginScreen(),
        },
      ),
    );
  }
}
