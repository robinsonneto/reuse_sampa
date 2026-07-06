import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

/// Banner rotativo da Home — usado para campanhas, avisos de mutirões de
/// coleta, ou destaques editoriais da Prefeitura. Autoplay a cada 5s.
class RotatingBanner extends StatefulWidget {
  final List<BannerItem> items;

  const RotatingBanner({super.key, required this.items});

  @override
  State<RotatingBanner> createState() => _RotatingBannerState();
}

class _RotatingBannerState extends State<RotatingBanner> {
  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(AppDurations.bannerAutoplay, (_) {
      if (!mounted || widget.items.isEmpty) return;
      _page = (_page + 1) % widget.items.length;
      _controller.animateToPage(_page,
          duration: AppDurations.medium, curve: Curves.easeInOutCubic);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: item.gradient,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.title,
                              style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                          const SizedBox(height: 6),
                          Text(item.subtitle,
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Icon(item.icon, size: 52, color: Colors.white.withOpacity(0.85)),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SmoothPageIndicator(
          controller: _controller,
          count: widget.items.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            spacing: 6,
            activeDotColor: AppColors.mediumGreen,
            dotColor: AppColors.beigeDark,
          ),
        ),
      ],
    );
  }
}
