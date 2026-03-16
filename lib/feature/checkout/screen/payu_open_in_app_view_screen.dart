import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';

void openInAppWebView(
    BuildContext context,
    String paymentUrl,
    VoidCallback onPaymentSuccess,
    ) {
  final uri = Uri.tryParse(paymentUrl);

  if (uri == null) {
    showCustomToast('Invalid Payment URL');
    return;
  }

  bool isPaymentHandled = false;

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri.uri(uri)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                ),
              ),

              onLoadStop: (controller, url) async {
                final currentUrl = url?.toString() ?? "";
                debugPrint("CURRENT URL: $currentUrl");

                /// ✅ Payment Success
                if (!isPaymentHandled &&
                    (currentUrl.contains("paySuccess") ||
                        currentUrl.contains("payment-success") ||
                        currentUrl.contains("response"))) {

                  isPaymentHandled = true;

                  Navigator.pop(context); // Close WebView
                  onPaymentSuccess(); // Callback
                }

                /// ❌ Payment Failed
                if (!isPaymentHandled &&
                    (currentUrl.contains("payFailure") ||
                        currentUrl.contains("failed") ||
                        currentUrl.contains("cancel"))) {

                  isPaymentHandled = true;
                  Navigator.pop(context);
                  showCustomToast("Payment Failed");
                }
              },

              shouldOverrideUrlLoading:
                  (controller, navigationAction) async {
                final url =
                    navigationAction.request.url?.toString() ?? "";

                if (url.startsWith("upi://")) {
                  try {
                    await launchUrlString(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (_) {
                    showCustomToast("UPI app not found");
                  }
                  return NavigationActionPolicy.CANCEL;
                }

                return NavigationActionPolicy.ALLOW;
              },

              onReceivedError: (controller, request, error) {
                if (!isPaymentHandled) {
                  showCustomToast(
                    "Error loading URL: ${error.description}",
                  );
                }
              },
            ),
          ),
        ),
      ),
    ),
  );
}
