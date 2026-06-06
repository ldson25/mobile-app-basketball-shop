import 'dart:async';

import 'package:flutter/material.dart';

class AppLoadingService extends ChangeNotifier {
  Timer? _timer;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void show({Duration duration = const Duration(milliseconds: 320)}) {
    _timer?.cancel();
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
    _timer = Timer(duration, hide);
  }

  void hide() {
    _timer?.cancel();
    _timer = null;
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class AppLoadingNavigatorObserver extends NavigatorObserver {
  AppLoadingNavigatorObserver(this.loadingService);

  final AppLoadingService loadingService;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    loadingService.show();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    loadingService.show(duration: const Duration(milliseconds: 220));
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    loadingService.show();
  }
}
