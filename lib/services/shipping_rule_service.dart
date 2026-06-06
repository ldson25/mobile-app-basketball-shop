import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/shipping_rule_model.dart';
import 'admin_activity_log_service.dart';

class ShippingRuleService extends ChangeNotifier {
  ShippingRuleService({
    FirebaseFirestore? firestore,
    AdminActivityLogService? logService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logService = logService ?? AdminActivityLogService() {
    _subscribe();
  }

  final FirebaseFirestore _firestore;
  final AdminActivityLogService _logService;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  List<ShippingRuleModel> _rules = [];

  List<ShippingRuleModel> get rules => List.unmodifiable(_rules);
  List<ShippingRuleModel> get activeRules =>
      _rules.where((rule) => rule.isActive).toList();

  void _subscribe() {
    _subscription = _firestore
        .collection('shipping_rules')
        .orderBy('cost')
        .snapshots()
        .listen((snapshot) {
      _rules = snapshot.docs.map((doc) {
        return ShippingRuleModel.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
      notifyListeners();
    });
  }

  Future<void> saveRule(ShippingRuleModel rule) async {
    await _firestore.collection('shipping_rules').doc(rule.id).set(rule.toJson());
    await _logService.record(
      action: 'Saved shipping rule ${rule.name}',
      targetType: 'shipping_rule',
      targetId: rule.id,
    );
  }

  Future<void> seedDefaultRules() async {
    final defaults = [
      const ShippingRuleModel(
        id: 'free',
        name: 'Free shipping',
        method: 'free',
        cost: 0,
      ),
      const ShippingRuleModel(
        id: 'standard',
        name: 'Standard shipping',
        method: 'standard',
        cost: 30000,
      ),
    ];
    final batch = _firestore.batch();
    for (final rule in defaults) {
      batch.set(
        _firestore.collection('shipping_rules').doc(rule.id),
        rule.toJson(),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
    await _logService.record(action: 'Seeded shipping rules');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
