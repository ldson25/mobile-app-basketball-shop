enum UserRole {
  user,
  admin,
}

enum MembershipTier {
  member,
  vip,
}

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime createdAt;
  final UserRole role;
  final MembershipTier membershipTier;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    required this.createdAt,
    this.role = UserRole.user,
    this.membershipTier = MembershipTier.member,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isVip => membershipTier == MembershipTier.vip;
  String get membershipLabel => isVip ? 'VIP MEMBER' : 'MEMBER';

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    DateTime? createdAt,
    UserRole? role,
    MembershipTier? membershipTier,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      membershipTier: membershipTier ?? this.membershipTier,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'role': role.name,
      'membershipTier': membershipTier.name,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleName = json['role'] as String?;
    final membershipName = json['membershipTier'] as String?;

    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      role: UserRole.values.firstWhere(
        (role) => role.name == roleName,
        orElse: () => UserRole.user,
      ),
      membershipTier: MembershipTier.values.firstWhere(
        (tier) => tier.name == membershipName,
        orElse: () => MembershipTier.member,
      ),
    );
  }
}
