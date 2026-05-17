import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String adminEmail = 'admin@kinetic.app';

  UserModel? _currentUser;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  // Đăng nhập
  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Demo validation
    if (email.isNotEmpty && password.isNotEmpty) {
      final normalizedEmail = email.trim().toLowerCase();
      final role = normalizedEmail == adminEmail
          ? UserRole.admin
          : UserRole.user;

      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: normalizedEmail,
        fullName: normalizedEmail.split('@')[0],
        createdAt: DateTime.now(),
        role: role,
        membershipTier: MembershipTier.member,
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Đăng ký
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    bool isEarlyAccess = false,
  }) async {
    // Validate
    if (fullName.isEmpty) {
      throw Exception('Please enter your full name');
    }
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Please enter a valid email');
    }
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email.trim().toLowerCase(),
      fullName: fullName,
      createdAt: DateTime.now(),
      role: UserRole.user,
      membershipTier:
          isEarlyAccess ? MembershipTier.vip : MembershipTier.member,
    );
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  // Đăng xuất
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Update user profile
  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateAvatar(String avatarPath) {
    final user = _currentUser;
    if (user == null) return;

    _currentUser = user.copyWith(avatarUrl: avatarPath);
    notifyListeners();
  }

  // Check if user is logged in
  Future<bool> checkAuthStatus() async {
    // Check saved token/session here
    // For demo, return false
    return _isAuthenticated;
  }
}
