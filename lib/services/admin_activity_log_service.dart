import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/admin_activity_log_model.dart';

class AdminActivityLogService extends ChangeNotifier {
  static final AdminActivityLogService _instance =
      AdminActivityLogService._internal();
  factory AdminActivityLogService() => _instance;

  AdminActivityLogService._internal()
      : _firestore = FirebaseFirestore.instance,
        _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  List<AdminActivityLogModel> _logs = [];

  List<AdminActivityLogModel> get logs => List.unmodifiable(_logs);

  void ensureSubscribed() {
    if (_subscription != null) return;
    _subscription = _firestore
        .collection('admin_logs')
        .orderBy('createdAt', descending: true)
        .limit(40)
        .snapshots()
        .listen((snapshot) {
      _logs = snapshot.docs.map((doc) {
        return AdminActivityLogModel.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
      notifyListeners();
    }, onError: (_) {});
  }

  Future<void> record({
    required String action,
    String targetType = '',
    String targetId = '',
  }) async {
    final user = _auth.currentUser;
    final ref = _firestore.collection('admin_logs').doc();
    final log = AdminActivityLogModel(
      id: ref.id,
      actorId: user?.uid ?? 'system',
      actorEmail: user?.email ?? 'unknown',
      action: action,
      targetType: targetType,
      targetId: targetId,
      createdAt: DateTime.now(),
    );
    await ref.set(log.toJson());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
