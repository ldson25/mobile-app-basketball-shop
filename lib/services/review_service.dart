import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/review_model.dart';

class ReviewService extends ChangeNotifier {
  ReviewService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Stream<List<ReviewModel>> watchProductReviews(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ReviewModel.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    });
  }

  Future<void> addReview({
    required String productId,
    required int rating,
    required String comment,
    required String userName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('User must be signed in to review a product.');
    }
    final canReview = await _hasDeliveredOrderForProduct(
      uid: user.uid,
      productId: productId,
    );
    if (!canReview) {
      throw StateError('Only delivered orders can review this product.');
    }

    final reviewRef = _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .doc();
    final review = ReviewModel(
      id: reviewRef.id,
      productId: productId,
      userId: user.uid,
      userName: userName.trim().isEmpty ? 'User' : userName.trim(),
      rating: rating.clamp(1, 5).toInt(),
      comment: comment.trim(),
      createdAt: DateTime.now(),
    );

    await reviewRef.set(review.toJson());
  }

  Future<bool> _hasDeliveredOrderForProduct({
    required String uid,
    required String productId,
  }) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: 'delivered')
        .get();

    for (final doc in snapshot.docs) {
      final items = doc.data()['items'];
      if (items is! List) continue;
      for (final item in items) {
        if (item is Map && item['productId']?.toString() == productId) {
          return true;
        }
      }
    }
    return false;
  }
}
