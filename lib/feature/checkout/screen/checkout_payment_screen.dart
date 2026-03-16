import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  final String amount;
  final String customerId;
  final String name;
  final String email;
  final String phone;

  const CheckoutPaymentScreen({
    super.key,
    required this.amount,
    required this.customerId,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    final postData = {
      "amount": widget.amount,
      "customerId": widget.customerId,
      "customerName": widget.name,
      "customerEmail": widget.email,
      "customerPhone": widget.phone,
    };

    final String postJson = jsonEncode(postData);
    final Uint8List bodyBytes = Uint8List.fromList(utf8.encode(postJson));

    return Scaffold(
      appBar: AppBar(title:  Text("Checkout Payment")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://biz-booster.vercel.app/api/payment/generate-payment-link"),
          method: 'POST',
          body: bodyBytes,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) {
          print("Page loaded: $url");
        },
        onLoadError: (controller, url, code, message) {
          print("Load error: $message");
        },
      ),
    );
  }
}
