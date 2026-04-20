import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool earlyAccess = false;
  bool agreeTerms = true;

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
              _buildField('FULL NAME', 'Enter your name'),
              const SizedBox(height: 22),
              _buildField('EMAIL ADDRESS', 'player@kinetic.app'),
              const SizedBox(height: 22),
              _buildField('PASSWORD', 'Minimum 8 characters', obscure: true),
              const SizedBox(height: 22),
              _buildField('CONFIRM PASSWORD', 'Repeat password', obscure: true),
              const SizedBox(height: 28),
              CheckboxListTile(
                value: earlyAccess,
                onChanged: (v) => setState(() => earlyAccess = v ?? false),
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
                value: agreeTerms,
                onChanged: (v) => setState(() => agreeTerms = v ?? false),
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
              AppButton(
                text: 'CREATE ACCOUNT',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account created (demo)')),
                  );
                },
                height: 72,
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'ALREADY HAVE AN ACCOUNT? SIGN IN',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Text(
                  'KINETIC',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white10,
                    fontWeight: FontWeight.w800,
                    fontSize: 42,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, {bool obscure = false}) {
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
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(hintText: hint),
          style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
