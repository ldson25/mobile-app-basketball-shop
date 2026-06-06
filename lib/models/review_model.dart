class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: (json['id'] ?? '').toString(),
      productId: (json['productId'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
      rating: json['rating'] is int
          ? json['rating'] as int
          : int.tryParse((json['rating'] ?? '0').toString()) ?? 0,
      comment: (json['comment'] ?? '').toString(),
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

DateTime _parseDate(dynamic value) {
  if (value is DateTime) return value;
  return DateTime.tryParse((value ?? '').toString()) ?? DateTime.now();
}
