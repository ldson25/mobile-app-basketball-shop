import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenEditorial;
  final VoidCallback onOpenGallery;

  const HomeScreen({
    super.key,
    required this.onOpenEditorial,
    required this.onOpenGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("KINETIC MENU")),
            ListTile(
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'KINETIC',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.volt,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      height: 360,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.white.withOpacity(0.04),
                          ],
                        ),
                        color: Colors.black,
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: RadialGradient(
                                  center: const Alignment(0, -0.9),
                                  radius: 1.0,
                                  colors: [
                                    Colors.white.withOpacity(0.22),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 18,
                            top: 18,
                            child: Text(
                              'VOLUME 01: THE LEGACY',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.volt,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 18,
                            bottom: 24,
                            child: Text(
                              'BEYOND\nTHE COURT',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontSize: 40,
                                height: 0.9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'ABOUT KINETIC',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'THE KINETIC\nSTORY',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 34,
                        height: 0.95,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Founded in the heart of the city\'s concrete canyons, KINETIC wasn\'t born in a boardroom. It was born on the blacktop. We started with a singular mission: to merge the raw energy of street basketball with high-performance engineering.',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        height: 1.65,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppButton(
                      text: 'READ OUR MANIFESTO',
                      onTap: onOpenEditorial,
                      primary: true,
                      height: 48,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 22,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'BALL IS LIFE',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A curated archive of the moments, players, and culture that define the kinetic movement.',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3A1600), Color(0xFF080808)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'THE GOLDEN ERA',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.volt,
                              fontWeight: FontWeight.w700,
                              fontSize: 9,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'GRAVITY IS A\nSUGGESTION',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 0.92,
                              fontSize: 24,
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
                            height: 140,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'ORIGINS',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    AppCard(
                      color: AppColors.volt,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'THE EVOLUTION OF THE SIGNATURE SHOE',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'READ ARTICLE  →',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2436),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'THREAD & TECH',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'JOIN THE REGISTRY',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get early access to editorial drops and signature athlete collaborations.',
                      style: GoogleFonts.inter(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(hintText: 'EMAIL ADDRESS'),
                    ),
                    const SizedBox(height: 18),
                    AppButton(
                      text: 'SUBSCRIBE',
                      primary: false,
                      onTap: onOpenGallery,
                      height: 48,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'KINETIC',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.volt,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
