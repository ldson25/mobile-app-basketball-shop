class AdminActivityLogModel {
  final String id;
  final String actorId;
  final String actorEmail;
  final String action;
  final String targetType;
  final String targetId;
  final DateTime createdAt;

  const AdminActivityLogModel({
    required this.id,
    required this.actorId,
    required this.actorEmail,
    required this.action,
    this.targetType = '',
    this.targetId = '',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actorId': actorId,
      'actorEmail': actorEmail,
      'action': action,
      'targetType': targetType,
      'targetId': targetId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AdminActivityLogModel.fromJson(Map<String, dynamic> json) {
    return AdminActivityLogModel(
      id: (json['id'] ?? '').toString(),
      actorId: (json['actorId'] ?? '').toString(),
      actorEmail: (json['actorEmail'] ?? '').toString(),
      action: (json['action'] ?? '').toString(),
      targetType: (json['targetType'] ?? '').toString(),
      targetId: (json['targetId'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
