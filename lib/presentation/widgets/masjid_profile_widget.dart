import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../data/models/masjid_profile_model.dart';
import '../../data/services/masjid_profile_service.dart';

class MasjidProfileWidget extends StatefulWidget {
  final VoidCallback? onEditPressed;

  const MasjidProfileWidget({
    super.key,
    this.onEditPressed,
  });

  @override
  State<MasjidProfileWidget> createState() => _MasjidProfileWidgetState();
}

class _MasjidProfileWidgetState extends State<MasjidProfileWidget>
    with TickerProviderStateMixin {
  final _service = MasjidProfileService();
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _carouselController;
  late PageController _pageController;
  int _currentPhotoIndex = 0;

  // List of available photos (assets dan URLs)
  final List<String> _photoAssets = [
    'assets/images/anshor.JPG',
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Carousel auto-scroll controller
    _pageController = PageController(initialPage: 0);
    _carouselController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _carouselController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MasjidProfile>(
      future: _service.getMasjidProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        final profile = snapshot.data ??
            MasjidProfile(
              nama: 'Masjid Jami Baitul Anshor',
              deskripsi: 'Sistem Informasi Manajemen Aset Masjid',
              alamat: 'Jl. Gading Tutuka 2, Jakarta',
              mapsUrl: 'https://maps.app.goo.gl/7gKdnbmiUNkNBdh18',
            );

        return GestureDetector(
          onTap: () async {
            final uri = Uri.parse(profile.mapsUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo Carousel Section
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppSpacing.radiusXl),
                            topRight: Radius.circular(AppSpacing.radiusXl),
                          ),
                          child: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              onPageChanged: (index) {
                                setState(() => _currentPhotoIndex = index);
                              },
                              itemCount: _photoAssets.length,
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  _photoAssets[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildPhotoPlaceholder(),
                                );
                              },
                            ),
                          ),
                        ),
                        // Carousel indicators
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _photoAssets.length,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPhotoIndex == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(
                                    _currentPhotoIndex == index ? 1 : 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.nama,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            profile.deskripsi,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          // Location with icon
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.8),
                                size: 14,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  profile.alamat,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          // Maps indicator
                          Row(
                            children: [
                              Icon(
                                Icons.map,
                                color: Colors.white.withOpacity(0.7),
                                size: 12,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Tap untuk buka di Google Maps',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Edit button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onEditPressed,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
      ),
      child: Center(
        child: Icon(
          Icons.mosque,
          color: Colors.white.withOpacity(0.5),
          size: 60,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated rotating circle with logo
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating outer circle
                  RotationTransition(
                    turns: _rotationController,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  // Static circle with opacity
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                  ),
                  // Pulsing center with logo
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0)
                        .animate(_scaleController),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.mosque,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Loading text
            Text(
              'Memuat profil masjid...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
