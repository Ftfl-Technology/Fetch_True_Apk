import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../core/widgets/custom_appbar.dart';

class CashfreePaymentScreen extends StatefulWidget {
  final String url;
  final VoidCallback onPaymentSuccess; // callback
  const CashfreePaymentScreen({super.key, required this.url, required this.onPaymentSuccess});

  @override
  State<CashfreePaymentScreen> createState() => _CashfreePaymentScreenState();
}

class _CashfreePaymentScreenState extends State<CashfreePaymentScreen> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStop: (controller, uri) {
            final currentUrl = uri.toString();

            if (currentUrl.contains("response")) {
              print('✅ Payment Success');

              widget.onPaymentSuccess();

              Future.delayed(Duration(seconds: 3), () {Navigator.pop(context, true);});
            }
        
            if (currentUrl.contains("failed")) {
              showCustomSnackBar(context, '❌ Payment Failed');

              Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(context, false); // Go back
              });
            }
          },
        ),
      ),
    );
  }
}
