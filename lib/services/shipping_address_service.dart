import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/shipping_address_model.dart';

class ShippingAddressService extends ChangeNotifier {
  static final ShippingAddressService _instance =
      ShippingAddressService._internal();
  factory ShippingAddressService() => _instance;

  ShippingAddressService._internal() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _subscription?.cancel();
      _addresses = [];
      if (user == null) {
        notifyListeners();
        return;
      }
      _subscribe(user.uid);
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  List<ShippingAddressModel> _addresses = [];

  List<ShippingAddressModel> get addresses => List.unmodifiable(_addresses);

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _addressesRef {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('addresses');
  }

  ShippingAddressModel? get defaultAddress {
    if (_addresses.isEmpty) return null;
    return _addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => _addresses.first,
    );
  }

  void _subscribe(String uid) {
    _subscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .listen((snapshot) {
      _addresses = snapshot.docs.map((doc) {
        final data = doc.data();
        return ShippingAddressModel.fromJson({
          ...data,
          'id': data['id'] ?? doc.id,
        });
      }).toList();
      notifyListeners();
    });
  }

  void addAddress(ShippingAddressModel address) {
    final shouldBeDefault = _addresses.isEmpty || address.isDefault;
    if (shouldBeDefault) {
      _clearDefault();
    }

    final nextAddress = address.copyWith(isDefault: shouldBeDefault);
    _addresses.add(nextAddress);
    notifyListeners();
    _syncDefaults();
    _addressesRef?.doc(nextAddress.id).set(nextAddress.toJson());
  }

  void updateAddress(ShippingAddressModel address) {
    final index = _addresses.indexWhere((item) => item.id == address.id);
    if (index == -1) return;

    if (address.isDefault) {
      _clearDefault();
    }

    _addresses[index] = address;
    notifyListeners();
    _syncDefaults();
    _addressesRef?.doc(address.id).set(address.toJson());
  }

  void removeAddress(String id) {
    final wasDefault = _addresses.any(
      (address) => address.id == id && address.isDefault,
    );
    _addresses.removeWhere((address) => address.id == id);

    if (wasDefault && _addresses.isNotEmpty) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }

    notifyListeners();
    _addressesRef?.doc(id).delete();
    _syncDefaults();
  }

  void setDefault(String id) {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: _addresses[i].id == id);
    }
    notifyListeners();
    _syncDefaults();
  }

  void _clearDefault() {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: false);
    }
  }

  void _syncDefaults() {
    final ref = _addressesRef;
    if (ref == null) return;
    for (final address in _addresses) {
      ref.doc(address.id).set(address.toJson());
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
