import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/theme/app_colors.dart';

class MomoPaymentWebViewScreen extends StatefulWidget {
  const MomoPaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
  });

  final String paymentUrl;

  @override
  State<MomoPaymentWebViewScreen> createState() => _MomoPaymentWebViewScreenState();
}

class _MomoPaymentWebViewScreenState extends State<MomoPaymentWebViewScreen> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => setState(() => _progress = progress),
          onNavigationRequest: (request) {
            _handlePaymentCallback(request.url);
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            final url = change.url;
            if (url != null) _handlePaymentCallback(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentCallback(String url) {
    if (_completed) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final resultCode = uri.queryParameters['resultCode'];
    if (resultCode == null) return;

    if (resultCode == '0' || resultCode == '9000') {
      _completed = true;
      Navigator.pop(context, true);
      return;
    }

    _completed = true;
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        title: const Text('Thanh toan MoMo'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'XONG',
              style: TextStyle(
                color: AppColors.neon,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_progress < 100)
            LinearProgressIndicator(
              value: _progress / 100,
              color: AppColors.neon,
              backgroundColor: AppColors.surface2,
            ),
        ],
      ),
    );
  }
}
