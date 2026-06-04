import 'package:flutter/material.dart';

import '../models/shipping_address_model.dart';

class ShippingAddressService extends ChangeNotifier {
  static final ShippingAddressService _instance =
      ShippingAddressService._internal();
  factory ShippingAddressService() => _instance;
  ShippingAddressService._internal();

  final List<ShippingAddressModel> _addresses = [];

  List<ShippingAddressModel> get addresses => List.unmodifiable(_addresses);

  ShippingAddressModel? get defaultAddress {
    if (_addresses.isEmpty) return null;
    return _addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => _addresses.first,
    );
  }

  void addAddress(ShippingAddressModel address) {
    final shouldBeDefault = _addresses.isEmpty || address.isDefault;
    if (shouldBeDefault) {
      _clearDefault();
    }

    _addresses.add(address.copyWith(isDefault: shouldBeDefault));
    notifyListeners();
  }

  void updateAddress(ShippingAddressModel address) {
    final index = _addresses.indexWhere((item) => item.id == address.id);
    if (index == -1) return;

    if (address.isDefault) {
      _clearDefault();
    }

    _addresses[index] = address;
    notifyListeners();
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
  }

  void setDefault(String id) {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: _addresses[i].id == id);
    }
    notifyListeners();
  }

  void _clearDefault() {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: false);
    }
  }
}
