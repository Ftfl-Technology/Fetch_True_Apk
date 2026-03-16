
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../core/widgets/custom_appbar.dart';

class PaymentScreen extends StatefulWidget {
  final String url;

  const PaymentScreen({super.key, required this.url});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  String? selectedUrl;
  InAppWebViewController? webViewController;


  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(title: 'payment',),
      body: Center(
        child: Stack(
          children: [
             InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStop: (controller, uri) {
                final currentUrl = uri.toString();
                if (currentUrl.contains("response")) {
                 // new screen status payment screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("✅ Payment Success")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  final String fromPage;

  MyInAppBrowser({required  this.fromPage});

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
      // showDialog(
      //   con,
      //   barrierDismissible: false,
      //   builder: (BuildContext context) {
      //     return WillPopScope(
      //       onWillPop: () async => false,
      //       child: const AlertDialog(
      //         contentPadding: EdgeInsets.all(Dimensions.paddingSizeSmall),
      //         content: PaymentFailedDialog(),
      //       ),
      //     );
      //   },
      // );

    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
    // print("Started at: " + response.startTime.toString() + "ms ---> duration: " + response.duration.toString() + "ms " + (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) async {
    if (kDebugMode) {
      print("inside_page_redirect");
    }
    // printLog("url:$url");
    if(_canRedirect) {
      bool isSuccess = url.contains('response');
      // bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl);
      // bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl);


      if (kDebugMode) {
        print('This_called_1::::$url');
      }
      if (isSuccess) {
        _canRedirect = false;
        close();
      }

      if (isSuccess) {
        print('Callback funtions');
      }
    }
  }
}




