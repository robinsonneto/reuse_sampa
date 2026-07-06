import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

/// Leitura de QR Code impresso na etiqueta física do item no Ecoponto.
///
/// Convenção sugerida para o conteúdo do QR: uma URL de deep link, por
/// exemplo `https://reusesampa.prefeitura.sp.gov.br/item/{itemId}`, ou —
/// mais simples para gerar internamente — apenas o `itemId` puro. O código
/// abaixo trata os dois casos.
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'reuse_sampa_qr');
  QRViewController? _controller;
  bool _handled = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final raw = scanData.code;
      if (raw == null || _handled) return;
      _handled = true;
      _controller?.pauseCamera();

      String itemId = raw.trim();
      final uri = Uri.tryParse(raw);
      if (uri != null && uri.pathSegments.isNotEmpty && uri.pathSegments.contains('item')) {
        final idx = uri.pathSegments.indexOf('item');
        if (idx + 1 < uri.pathSegments.length) {
          itemId = uri.pathSegments[idx + 1];
        }
      }

      if (mounted) context.replace(AppRoutes.itemDetailPath(itemId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Ler QR Code do item'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: AppColors.mediumGreen,
              borderRadius: AppRadius.lg,
              borderLength: 32,
              borderWidth: 8,
              cutOutSize: 260,
            ),
          ),
          Positioned(
            bottom: 48,
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            child: Text(
              'Aponte a câmera para o QR Code na etiqueta do item para ver os detalhes.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
