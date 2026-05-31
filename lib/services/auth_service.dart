import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsign;
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  
  AuthService._internal() {
    // Tự động lắng nghe trạng thái đăng nhập của Firebase
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _currentUser = null;
        _isAuthenticated = false;
        notifyListeners();
      } else {
        // Nếu Firebase báo đã login, tiến hành lấy thêm data (tên, role) từ Firestore
        _loadUserData(user.uid);
      }
    });
  }

  static const String adminEmail = 'admin@kinetic.app';

  UserModel? _currentUser;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  // ---------------------------------------------------------
  // 1. Tải thông tin User từ Cloud Firestore
  // ---------------------------------------------------------
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        _currentUser = UserModel.fromJson(doc.data()!);
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Lỗi khi tải thông tin user: $e");
    }
  }

  // ---------------------------------------------------------
  // 2. Đăng nhập bằng Email & Password
  // ---------------------------------------------------------
  Future<bool> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      if (userCredential.user != null) {
        await _loadUserData(userCredential.user!.uid);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint("Lỗi đăng nhập Firebase: ${e.code}");
      return false; // Có thể throw Exception để bắt ở UI
    }
  }

  // ---------------------------------------------------------
  // 3. Đăng ký tài khoản mới
  // ---------------------------------------------------------
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    bool isEarlyAccess = false,
  }) async {
    if (password != confirmPassword) {
      throw Exception('Mật khẩu xác nhận không khớp');
    }

    try {
      // BƯỚC 1: Tạo tài khoản trên Firebase Authentication
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // BƯỚC 2: Tạo model UserModel của riêng app mình
        final normalizedEmail = email.trim().toLowerCase();
        
        // Phân quyền: Cứ ai đăng ký bằng admin@kinetic.app thì là admin
        final role = normalizedEmail == adminEmail ? UserRole.admin : UserRole.user;

        final newUser = UserModel(
          id: firebaseUser.uid, // Dùng đúng UID của Firebase làm ID
          email: normalizedEmail,
          fullName: fullName,
          createdAt: DateTime.now(),
          role: role,
          membershipTier: isEarlyAccess ? MembershipTier.vip : MembershipTier.member,
        );

        // BƯỚC 3: Lưu thêm thông tin (Họ tên, role, VIP) vào Cloud Firestore collection 'users'
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid) // doc() chính là UID
            .set(newUser.toJson());
        
        _currentUser = newUser;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Lỗi đăng ký: $e");
      throw Exception('Không thể tạo tài khoản: $e');
    }
  }

  // ---------------------------------------------------------
  // 4. Đăng xuất
  // ---------------------------------------------------------
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut(); // Firebase tự lo việc xóa session
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // 5. Cập nhật thông tin khác
  // ---------------------------------------------------------
  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> updateAvatar(String avatarPath) async {
    final user = _currentUser;
    if (user == null) return;

    // TODO: Upload ảnh thực tế lên Firebase Storage sau.
    // Tạm thời update local path vào Firestore.
    _currentUser = user.copyWith(avatarUrl: avatarPath);
    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
      'avatarUrl': avatarPath
    });
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    return _isAuthenticated;
  }

  // ---------------------------------------------------------
  // 6. Đăng nhập bằng Google
  // ---------------------------------------------------------
  Future<bool> signInWithGoogle() async {
    try {
      // 1. Kích hoạt luồng đăng nhập Google
      final gsign.GoogleSignInAccount? googleUser = await gsign.GoogleSignIn().signIn();
      if (googleUser == null) return false; // Người dùng bấm Hủy

      // 2. Lấy thông tin xác thực
      final gsign.GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Đăng nhập vào Firebase
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 4. Kiểm tra xem user này đã có trong Database chưa
        final doc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
        
        if (!doc.exists) {
          // Lần đầu đăng nhập bằng Google -> Tạo mới profile
          final newUser = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            fullName: firebaseUser.displayName ?? 'Người dùng Google',
            avatarUrl: firebaseUser.photoURL,
            createdAt: DateTime.now(),
            role: UserRole.user,
            membershipTier: MembershipTier.member,
          );
          await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set(newUser.toJson());
          _currentUser = newUser;
        } else {
          // Đã có tài khoản -> Load thông tin
          _currentUser = UserModel.fromJson(doc.data()!);
        }
        
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Lỗi đăng nhập Google: $e");
      return false;
    }
  }
}
