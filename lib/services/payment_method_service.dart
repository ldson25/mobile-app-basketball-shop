import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/payment_method_model.dart';

class PaymentMethodService extends ChangeNotifier {
  PaymentMethodService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance {
    _auth.authStateChanges().listen((user) {
      _subscription?.cancel();
      _methods = [];
      if (user == null) {
        notifyListeners();
        return;
      }
      _subscribe(user.uid);
      ensureCodMethod();
    });
  }

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  List<PaymentMethodModel> _methods = [];

  List<PaymentMethodModel> get methods => List.unmodifiable(_methods);
  String? get _uid => _auth.currentUser?.uid;

  void _subscribe(String uid) {
    _subscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('payment_methods')
        .snapshots()
        .listen((snapshot) {
      _methods = snapshot.docs.map((doc) {
        return PaymentMethodModel.fromJson({...doc.data(), 'id': doc.id});
      }).toList()
        ..sort((a, b) {
          if (a.isDefault == b.isDefault) return a.label.compareTo(b.label);
          return a.isDefault ? -1 : 1;
        });
      notifyListeners();
    });
  }

  Future<void> ensureCodMethod() async {
    final uid = _uid;
    if (uid == null) return;

    final method = PaymentMethodModel(
      id: 'cod',
      userId: uid,
      type: PaymentMethodType.cash,
      label: 'Thanh toan khi nhan hang',
      provider: 'COD',
      maskedNumber: '',
      isDefault: true,
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('payment_methods')
        .doc(method.id)
        .set(method.toJson(), SetOptions(merge: true));
  }

  Future<void> setDefault(String methodId) async {
    final uid = _uid;
    if (uid == null) return;

    final collection =
        _firestore.collection('users').doc(uid).collection('payment_methods');
    final snapshot = await collection.get();
    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': doc.id == methodId});
    }
    await batch.commit();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
