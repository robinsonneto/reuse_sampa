import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';

class _OnboardPage {
  final IconData icon;
  final String title;
  final String description;
  const _OnboardPage(this.icon, this.title, this.description);
}

const _pages = [
  _OnboardPage(
    Icons.recycling_rounded,
    'Objetos ganham\nnova vida',
    'Veja tudo o que está disponível gratuitamente nos Ecopontos da sua região.',
  ),
  _OnboardPage(
    Icons.place_rounded,
    'Encontre um\nEcoponto perto de você',
    'Consulte endereço, horário de funcionamento e trace a rota até lá.',
  ),
  _OnboardPage(
    Icons.event_available_rounded,
    'Reserve e retire\nem até 4 horas',
    'Garanta o item por algumas horas enquanto você se organiza para buscá-lo.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  void _finish() => context.go(AppRoutes.home);

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextButton(
                  onPressed: _finish,
                  child: Text('Pular', style: AppTextStyles.label.copyWith(color: AppColors.greyText)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            color: AppColors.beigeSoft,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 64, color: AppColors.mediumGreen),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(page.title, textAlign: TextAlign.center, style: AppTextStyles.displayMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.greyText),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: const WormEffect(
                dotHeight: 7,
                dotWidth: 7,
                activeDotColor: AppColors.darkGreen,
                dotColor: AppColors.beigeDark,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: PrimaryButton(
                label: isLast ? 'Começar a explorar' : 'Próximo',
                icon: isLast ? Icons.arrow_forward_rounded : null,
                onPressed: () {
                  if (isLast) {
                    _finish();
                  } else {
                    _controller.nextPage(duration: AppDurations.medium, curve: Curves.easeOut);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
