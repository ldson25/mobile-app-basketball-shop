import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/app_config_model.dart';
import 'admin_activity_log_service.dart';

class AppConfigService extends ChangeNotifier {
  AppConfigService({
    FirebaseFirestore? firestore,
    AdminActivityLogService? logService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logService = logService ?? AdminActivityLogService() {
    _subscribe();
  }

  final FirebaseFirestore _firestore;
  final AdminActivityLogService _logService;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;
  AppConfigModel _config = const AppConfigModel();

  AppConfigModel get config => _config;

  void _subscribe() {
    _subscription = _firestore
        .collection('app_config')
        .doc('settings')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        _config = AppConfigModel.fromJson(snapshot.data()!);
      }
      notifyListeners();
    });
  }

  Future<void> saveConfig(AppConfigModel config) async {
    _config = config;
    notifyListeners();
    await _firestore.collection('app_config').doc('settings').set(config.toJson());
    await _logService.record(
      action: 'Updated app config',
      targetType: 'app_config',
      targetId: 'settings',
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
