import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';

class PackagePaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const PackagePaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
  });

  @override
  State<PackagePaymentWebViewScreen> createState() =>
      _PackagePaymentWebViewScreenState();
}

class _PackagePaymentWebViewScreenState
    extends State<PackagePaymentWebViewScreen> {
  InAppWebViewController? webViewController;
  final ValueNotifier<double> progressNotifier = ValueNotifier(0.0);
  bool isPaymentHandled = false;

  @override
  void dispose() {
    progressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final encodedUrl = Uri.encodeFull(widget.paymentUrl);
    final uri = Uri.tryParse(encodedUrl);

    if (uri == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackBar(context, 'Invalid Payment URL');
        Navigator.pop(context);
      });
      return const SizedBox();
    }

    return Scaffold(

      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri.uri(uri)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  allowUniversalAccessFromFileURLs: true,
                  mediaPlaybackRequiresUserGesture: false,
                  cacheEnabled: true,
                  transparentBackground: true,
                ),
                android: AndroidInAppWebViewOptions(
                  mixedContentMode:
                  AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  useHybridComposition: false,
                  safeBrowsingEnabled: false,
                  allowFileAccess: true,
                  allowContentAccess: true,
                ),
              ),

              // ✅ Progress update via ValueNotifier
              onProgressChanged: (controller, progressValue) {
                progressNotifier.value = progressValue / 100;
              },

              // ✅ Payment success/failure detection
              onLoadStop: (controller, url) async {
                final currentUrl = url?.toString().toLowerCase() ?? "";
                debugPrint("🌐 Loaded: $currentUrl");

                if (isPaymentHandled) return;

                // ✅ SUCCESS
                if (currentUrl.contains("paysuccess")) {
                  isPaymentHandled = true;

                  debugPrint("✅ PAYMENT SUCCESS DETECTED");

                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                }

                // ❌ FAILURE
                else if (currentUrl.contains("failure") ||
                    currentUrl.contains("failed") ||
                    currentUrl.contains("cancel")) {
                  isPaymentHandled = true;

                  debugPrint("❌ PAYMENT FAILED");

                  if (mounted) {
                    Navigator.pop(context, false);
                  }
                }
              },


              // ✅ Handle UPI or external links
              shouldOverrideUrlLoading: (controller, action) async {
                final url = action.request.url?.toString() ?? "";
                if (url.startsWith("upi://")) {
                  try {
                    await launchUrlString(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    showCustomSnackBar(context, "UPI app not found");
                  }
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },

              // ✅ Error handling
              onReceivedError: (controller, request, error) {
                final desc = error.description.toLowerCase();
                if (desc.contains("orb") || desc.contains("blocked")) return;

                debugPrint(
                    "❌ Error loading URL: ${request.url} → ${error.description}");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showCustomSnackBar(context, "Error loading payment page");
                });
              },
            ),

            // ✅ Reactive progress bar (no setState)
            ValueListenableBuilder<double>(
              valueListenable: progressNotifier,
              builder: (context, progress, _) {
                if (progress < 1.0) {
                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
//