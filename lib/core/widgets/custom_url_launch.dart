import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void CustomUrlLaunch(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    print('Could not launch $url');
  }
}


void CopyUrl(String url,) async {
  await Clipboard.setData(ClipboardData(text: url));
  showCustomToast("Link copied successfully!");
}
