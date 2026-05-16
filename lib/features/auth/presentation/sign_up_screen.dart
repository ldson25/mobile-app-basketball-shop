import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../app_shell/presentation/app_shell.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _earlyAccess = false;
  bool _agreeTerms = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleSignUp() async {
    if (_fullNameController.text.isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      _showError('Please enter a valid email address');
      return;
    }
    
    if (_passwordController.text.length < 8) {
      _showError('Password must be at least 8 characters');
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }
    
    if (!_agreeTerms) {
      _showError('Please agree to the Terms of Service');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      final success = await authService.signUp(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        isEarlyAccess: _earlyAccess,
      );

      if (success) {
        // Navigate to AppShell
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppShell()),
          (route) => false,
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.volt),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'SIGN UP',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.volt,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.09),
                      Colors.transparent,
                      AppColors.background,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'CREATE PROFILE',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 56,
                  height: 0.92,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'CREATE ',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 44,
                    height: 0.92,
                  ),
                  children: [
                    TextSpan(
                      text: 'PROFILE',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.volt,
                        fontWeight: FontWeight.w800,
                        fontSize: 44,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Join the elite tier for exclusive drops and performance insights.',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),
              _buildField('FULL NAME', 'Enter your name', _fullNameController),
              const SizedBox(height: 22),
              _buildField('EMAIL ADDRESS', 'player@kinetic.app', _emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 22),
              _buildField('PASSWORD', 'Minimum 8 characters', _passwordController,
                  obscure: true, isPassword: true),
              const SizedBox(height: 22),
              _buildField('CONFIRM PASSWORD', 'Repeat password', _confirmPasswordController,
                  obscure: true, isConfirmPassword: true),
              const SizedBox(height: 28),
              CheckboxListTile(
                value: _earlyAccess,
                onChanged: (v) => setState(() => _earlyAccess = v ?? false),
                activeColor: AppColors.volt,
                checkColor: Colors.black,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Sign up for early access to product drops',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _agreeTerms,
                onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                activeColor: AppColors.volt,
                checkColor: Colors.black,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'I agree to the Terms of Service and Privacy Policy',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.volt,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    textStyle: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                    elevation: 0,
                    disabledBackgroundColor: AppColors.border,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : const Text('CREATE ACCOUNT'),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'ALREADY HAVE AN ACCOUNT? ',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                      children: [
                        TextSpan(
                          text: 'SIGN IN',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.neon,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
            suffixIcon: (isPassword || isConfirmPassword)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        if (isPassword) {
                          _obscurePassword = !_obscurePassword;
                        } else if (isConfirmPassword) {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        }
                      });
                    },
                    icon: Icon(
                      (isPassword ? _obscurePassword : _obscureConfirmPassword)
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}