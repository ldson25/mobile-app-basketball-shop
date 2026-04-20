import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_button.dart';

class GalleryFilterScreen extends StatefulWidget {
  const GalleryFilterScreen({super.key});

  @override
  State<GalleryFilterScreen> createState() => _GalleryFilterScreenState();
}

class _GalleryFilterScreenState extends State<GalleryFilterScreen> {
  RangeValues price = const RangeValues(120, 280);
  String brand = 'Kinetic';
  String size = '10';
  String surface = 'Indoor Court';
  String ankle = 'Mid';
  String fit = 'Standard';
  String material = 'Dri-FIT';
  String color = 'Volt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.close, color: AppColors.volt),
                    ),
                    Expanded(
                      child: Text(
                        'KINETIC GALLERY',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.volt,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh, color: AppColors.volt),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'FILTERS',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.volt,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'REFINE YOUR\nPERFORMANCE.',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    fontSize: 46,
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 28),
                _sectionHeader(
                  'PRICE RANGE',
                  '\$${price.start.round()} — \$${price.end.round()}',
                ),
                RangeSlider(
                  values: price,
                  min: 0,
                  max: 500,
                  activeColor: AppColors.volt,
                  inactiveColor: AppColors.surface3,
                  onChanged: (value) => setState(() => price = value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_muted('\$0'), _muted('\$500+')],
                ),
                const SizedBox(height: 28),
                _title('BRAND'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ['Kinetic', 'Nike', 'Jordan', 'Adidas']
                      .map(
                        (e) => _choice(
                          e,
                          brand == e,
                          () => setState(() => brand = e),
                          width: 150,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 28),
                _title('SIZE (US MEN\'S)'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      [
                            '8',
                            '8.5',
                            '9',
                            '9.5',
                            '10',
                            '10.5',
                            '11',
                            '11.5',
                            '12',
                            '13',
                            '14',
                            '15',
                          ]
                          .map(
                            (e) => _choice(
                              e,
                              size == e,
                              () => setState(() => size = e),
                              width: 66,
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 26),
                _dividerTitle('FOOTWEAR SPECS'),
                const SizedBox(height: 18),
                _sub('PLAYING SURFACE'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _choice(
                        'Indoor Court',
                        surface == 'Indoor Court',
                        () => setState(() => surface = 'Indoor Court'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _choice(
                        'Outdoor Blacktop',
                        surface == 'Outdoor Blacktop',
                        () => setState(() => surface = 'Outdoor Blacktop'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _sub('ANKLE SUPPORT'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _choice(
                        'Low',
                        ankle == 'Low',
                        () => setState(() => ankle = 'Low'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _choice(
                        'Mid',
                        ankle == 'Mid',
                        () => setState(() => ankle = 'Mid'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _choice(
                        'High',
                        ankle == 'High',
                        () => setState(() => ankle = 'High'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                _dividerTitle('APPAREL SPECS'),
                const SizedBox(height: 18),
                _sub('FIT STYLE'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _choice(
                        'Standard',
                        fit == 'Standard',
                        () => setState(() => fit = 'Standard'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _choice(
                        'Slim',
                        fit == 'Slim',
                        () => setState(() => fit = 'Slim'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _choice(
                        'Oversized',
                        fit == 'Oversized',
                        () => setState(() => fit = 'Oversized'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _sub('MATERIAL TECHNOLOGY'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _choice(
                        'Dri-FIT',
                        material == 'Dri-FIT',
                        () => setState(() => material = 'Dri-FIT'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _choice(
                        'Fleece',
                        material == 'Fleece',
                        () => setState(() => material = 'Fleece'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                _title('SIGNATURE COLORS'),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _colorDot(
                      'Volt',
                      AppColors.volt,
                      color == 'Volt',
                      () => setState(() => color = 'Volt'),
                    ),
                    const SizedBox(width: 16),
                    _colorDot(
                      'Black',
                      AppColors.surface3,
                      color == 'Black',
                      () => setState(() => color = 'Black'),
                    ),
                    const SizedBox(width: 16),
                    _colorDot(
                      'White',
                      Colors.white,
                      color == 'White',
                      () => setState(() => color = 'White'),
                    ),
                    const SizedBox(width: 16),
                    _colorDot(
                      'Red',
                      const Color(0xFFFF7B5A),
                      color == 'Red',
                      () => setState(() => color = 'Red'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -18,
                        bottom: -20,
                        child: Transform.rotate(
                          angle: -0.18,
                          child: Container(
                            width: 210,
                            height: 170,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'MATCHED FOR\nSPEED.',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                                fontSize: 30,
                                height: 0.92,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '12 RESULTS FOUND',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.volt,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'RESET',
                        primary: false,
                        onTap: _reset,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        text: 'APPLY FILTERS',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Filters applied')),
                          );
                        },
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

  void _reset() {
    setState(() {
      price = const RangeValues(120, 280);
      brand = 'Kinetic';
      size = '10';
      surface = 'Indoor Court';
      ankle = 'Mid';
      fit = 'Standard';
      material = 'Dri-FIT';
      color = 'Volt';
    });
  }

  Widget _sectionHeader(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _title(left),
        Text(
          right,
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.volt,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 20,
        letterSpacing: 1.4,
      ),
    );
  }

  Widget _sub(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        color: Colors.white70,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 1.6,
      ),
    );
  }

  Widget _muted(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        color: Colors.white38,
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _dividerTitle(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outline.withOpacity(0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.outline.withOpacity(0.2))),
      ],
    );
  }

  Widget _choice(
    String text,
    bool active,
    VoidCallback onTap, {
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.volt.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active
                ? AppColors.volt
                : AppColors.outline.withOpacity(0.25),
            width: active ? 2 : 1,
          ),
        ),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            color: active ? AppColors.volt : Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _colorDot(
    String label,
    Color dotColor,
    bool active,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? AppColors.volt : Colors.white10,
                width: active ? 3 : 1,
              ),
            ),
            child: active
                ? Icon(
                    Icons.check,
                    color: dotColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              color: active ? Colors.white : Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
