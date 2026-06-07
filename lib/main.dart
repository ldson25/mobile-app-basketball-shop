import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider, Consumer, Provider;
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/presentation/admin_shell.dart';
import 'features/app_shell/presentation/app_shell.dart';
import 'features/auth/presentation/login.dart';
import 'services/auth_service.dart';
import 'services/admin_activity_log_service.dart';
import 'services/app_config_service.dart';
import 'services/app_loading_service.dart';
import 'services/banner_service.dart';
import 'services/cart_service.dart';
import 'services/favorites_service.dart';
import 'services/order_service.dart';
import 'services/payment_method_service.dart';
import 'services/product_service.dart';
import 'services/review_service.dart';
import 'services/shipping_address_service.dart';
import 'services/shipping_rule_service.dart';
import 'services/theme_service.dart';
import 'services/voucher_service.dart';
import 'services/chatbot_service.dart';
import 'widgets/app_loading_overlay.dart';
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
        ChangeNotifierProvider(create: (_) => AdminActivityLogService()),
        ChangeNotifierProvider(create: (_) => AppConfigService()),
        ChangeNotifierProvider(create: (_) => AppLoadingService()),
        ChangeNotifierProvider(create: (_) => BannerService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => FavoritesService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
        ChangeNotifierProvider(create: (_) => PaymentMethodService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => ReviewService()),
        ChangeNotifierProvider(create: (_) => ShippingAddressService()),
        ChangeNotifierProvider(create: (_) => ShippingRuleService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => VoucherService()),
        ChangeNotifierProvider(create: (_) => ChatbotService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kinetic',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            navigatorObservers: [
              AppLoadingNavigatorObserver(context.read<AppLoadingService>()),
            ],
            builder: (context, child) {
              return AppLoadingOverlay(child: child ?? const SizedBox.shrink());
            },
            home: const AppShell(),
            routes: {
              AdminShell.routeName: (_) => const AdminShell(),
              '/login': (_) => const LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
