import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/banner_model.dart';
import 'admin_activity_log_service.dart';

class BannerService extends ChangeNotifier {
  BannerService({
    FirebaseFirestore? firestore,
    AdminActivityLogService? logService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logService = logService ?? AdminActivityLogService() {
    _subscribe();
  }

  final FirebaseFirestore _firestore;
  final AdminActivityLogService _logService;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  List<BannerModel> _banners = [];

  List<BannerModel> get banners => List.unmodifiable(_banners);
  List<BannerModel> get activeBanners =>
      _banners.where((banner) => banner.isActive).toList();

  void _subscribe() {
    _subscription = _firestore
        .collection('banners')
        .orderBy('sortOrder')
        .snapshots()
        .listen((snapshot) {
      _banners = snapshot.docs.map((doc) {
        return BannerModel.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
      notifyListeners();
    });
  }

  Future<void> saveBanner(BannerModel banner) async {
    await _firestore.collection('banners').doc(banner.id).set(banner.toJson());
    await _logService.record(
      action: 'Saved banner ${banner.title}',
      targetType: 'banner',
      targetId: banner.id,
    );
  }

  Future<void> toggleBanner(String id) async {
    BannerModel? banner;
    for (final item in _banners) {
      if (item.id == id) {
        banner = item;
        break;
      }
    }
    if (banner == null) return;
    await saveBanner(
      BannerModel(
        id: banner.id,
        title: banner.title,
        subtitle: banner.subtitle,
        imageUrl: banner.imageUrl,
        imageAsset: banner.imageAsset,
        productId: banner.productId,
        isActive: !banner.isActive,
        sortOrder: banner.sortOrder,
      ),
    );
  }

  Future<void> seedDefaultBanners() async {
    final defaults = [
      const BannerModel(
        id: 'home_editorial',
        title: 'Street series',
        subtitle: 'Nhan de xem bo suu tap noi bat.',
        sortOrder: 1,
      ),
    ];
    final batch = _firestore.batch();
    for (final banner in defaults) {
      batch.set(
        _firestore.collection('banners').doc(banner.id),
        banner.toJson(),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
    await _logService.record(action: 'Seeded home banners');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
