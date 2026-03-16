import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class PDFWebViewDownloadScreen extends StatefulWidget {
  const PDFWebViewDownloadScreen({super.key});

  @override
  State<PDFWebViewDownloadScreen> createState() => _PDFWebViewDownloadScreenState();
}

class _PDFWebViewDownloadScreenState extends State<PDFWebViewDownloadScreen> {
  final String pdfUrl = 'https://biz-booster.vercel.app/api/invoice/688e017466837b75578f7e74';

  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice Viewer")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(pdfUrl)), // ✅ FIX 1
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onDownloadStartRequest: (controller, DownloadStartRequest req) async {
          final url = req.url.toString();
          final filename = url.split('/').last;
          final dir = await getExternalStorageDirectory();
          final filePath = "${dir!.path}/$filename";

          try {
            final client = HttpClient();
            final request = await client.getUrl(Uri.parse(url));
            final response = await request.close();
            final bytes = await consolidateHttpClientResponseBytes(response);
            final file = File(filePath);
            await file.writeAsBytes(bytes);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Downloaded to $filePath")),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Download failed: $e")),
            );
          }
        },
      ),
    );
  }
}
