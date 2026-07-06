import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.88, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Substituir por Image.asset('assets/images/logo_reuse_sampa.png')
                // quando o arquivo de logo fornecido for adicionado ao projeto.
                _LogoMark(),
                const SizedBox(height: 18),
                Text('reuse\nsampa',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayMedium.copyWith(height: 0.95)),
                const SizedBox(height: 8),
                Text('dê novo uso, gere novos caminhos.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyText)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: CustomPaint(painter: _ReuseLogoPainter()),
    );
  }
}

/// Aproximação vetorial do símbolo da marca (seta circular + coração) para
/// que o app tenha uma marca funcionando mesmo antes do arquivo de logo
/// oficial (PNG/SVG fornecido pela equipe de design) ser adicionado aos
/// assets. Ver instruções no README, seção "Identidade visual".
class _ReuseLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final greenPaint = Paint()
      ..color = AppColors.mediumGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round;

    final orangePaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius * 0.82);
    canvas.drawArc(rect, -2.6, 2.4, false, greenPaint);
    canvas.drawArc(rect, 0.5, 2.4, false, orangePaint);

    final heartPaint = Paint()
      ..color = AppColors.darkGreen
      ..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width * 0.34;
    final cx = center.dx;
    final cy = center.dy + size.height * 0.02;
    path.moveTo(cx, cy + w * 0.55);
    path.cubicTo(cx - w, cy - w * 0.3, cx - w * 0.5, cy - w, cx, cy - w * 0.35);
    path.cubicTo(cx + w * 0.5, cy - w, cx + w, cy - w * 0.3, cx, cy + w * 0.55);
    canvas.drawPath(path, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
