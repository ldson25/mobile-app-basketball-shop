import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/glow_button.dart';
import '../../widgets/section_card.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const String storeName = 'KINETIC FLAGSHIP';
  static const String address =
      '72 Le Thanh Ton, Ben Nghe, District 1, Ho Chi Minh City';
  static const double latitude = 10.7769;
  static const double longitude = 106.7009;
  static const LatLng _storePosition = LatLng(latitude, longitude);
  static final Set<Marker> _storeMarkers = {
    Marker(
      markerId: const MarkerId('kinetic_flagship'),
      position: _storePosition,
      infoWindow: const InfoWindow(
        title: storeName,
        snippet: address,
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'ABOUT US',
          style: TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSizes.pagePadding,
          12,
          AppSizes.pagePadding,
          48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 42,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Performance gear, basketball culture, and everyday training essentials built around the Kinetic community.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _storePosition,
                    zoom: 15.5,
                  ),
                  markers: _storeMarkers,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SectionCard(
              color: AppColors.surface2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _InfoRow(
                    icon: Icons.location_on_rounded,
                    label: 'Store address',
                    value: address,
                  ),
                  const SizedBox(height: 18),
                  const _InfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'Opening hours',
                    value: 'Mon - Sun / 09:00 - 21:30',
                  ),
                  const SizedBox(height: 18),
                  const _InfoRow(
                    icon: Icons.call_rounded,
                    label: 'Hotline',
                    value: '1900 0000',
                  ),
                  const SizedBox(height: 20),
                  GlowButton(
                    label: 'COPY ADDRESS',
                    icon: Icons.copy_rounded,
                    expanded: true,
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: address));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Address copied')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionCard(
              color: AppColors.surface2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OUR MISSION',
                    style: TextStyle(
                      color: AppColors.neon,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'We curate products for players who care about speed, control, durability, and style on every court.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.neon, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
