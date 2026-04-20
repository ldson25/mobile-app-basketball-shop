import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../auth/presentation/sign_up_screen.dart';

class EditorialScreen extends StatelessWidget {
  const EditorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background.withOpacity(0.92),
            title: Row(
              children: [
                Text(
                  'KINETIC',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.volt,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 520,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        AppColors.background,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'VOLUME 01: THE LEGACY',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.volt,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'BEYOND\nTHE COURT',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 54,
                          height: 0.92,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.outline.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'ABOUT KINETIC',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'THE KINETIC STORY',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 40,
                          height: 0.95,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Founded in the heart of the city\'s concrete canyons, KINETIC wasn\'t born in a boardroom. It was born on the blacktop. We started with a singular mission: to merge the raw energy of street basketball with high-performance engineering that defies the status quo.',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Our journey began in 2018, experimenting with lightweight polymers and asymmetric structural supports in a garage. Today, we are a global movement of players who demand gear as dynamic as their crossover.',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        text: 'READ OUR MANIFESTO',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        ),
                        height: 50,
                      ),
                      const SizedBox(height: 22),
                      Container(
                        height: 240,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'BALL IS LIFE',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A curated archive of the moments, players, and culture that define the kinetic movement.',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A1600), Color(0xFF090909)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'THE GOLDEN ERA',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.volt,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'GRAVITY IS A\nSUGGESTION',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 34,
                                height: 0.92,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 160,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.all(18),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  'ORIGINS',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.volt,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.article_outlined,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'THE EVOLUTION OF THE SIGNATURE SHOE',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                                height: 0.95,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'READ ARTICLE →',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B233A),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'THREAD & TECH',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'JOIN THE REGISTRY',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get early access to editorial drops and signature athlete collaborations.',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const TextField(
                        decoration: InputDecoration(hintText: 'EMAIL ADDRESS'),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'SUBSCRIBE',
                        primary: false,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        ),
                        height: 48,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'KINETIC',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.volt,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Redefining performance through the lens of urban basketball culture. More than a brand. A movement.',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
