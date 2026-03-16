import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  /// 📧 Open Gmail app if available, else open Gmail web
  Future<void> _openEmail(BuildContext context) async {
    const String email = 'info@fetchtrue.com';
    const String subject = 'Support Request';
    const String body = 'Hello FetchTrue Team,';

    final Uri gmailWebUri = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=$subject&body=$body',
    );

    try {
      // Gmail app intent (works even if mailto fails)
      final androidGmailUri = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=$subject&body=$body',
      );

      // 🔹 Try opening Gmail app explicitly
      bool launched = await launchUrl(
        androidGmailUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // 🔸 If app not opened, open Gmail Web fallback
        await launchUrl(gmailWebUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching Gmail: $e");
      try {
        await launchUrl(gmailWebUri, mode: LaunchMode.externalApplication);
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open email.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Help & Support', showBackButton: true),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Image.asset(CustomImage.inviteImage),
              50.height,

              /// Email Section
              Text('Contact us through email', style: textStyle16(context)),
              Text(
                'You can send us email through',
                style: textStyle12(context, color: CustomColor.descriptionColor),
              ),
              InkWell(
                onTap: () => _openEmail(context),
                child: Text(
                  'info@fetchtrue.com',
                  style: textStyle14(context, color: CustomColor.appColor),
                ),
              ),
              Text(
                'Typically the support team send you any feedback in 2 hours',
                style: textStyle14(context, fontWeight: FontWeight.w400),
              ),
              20.height,

              /// Phone Section
              Text('Contact us through phone', style: textStyle16(context)),
              Text(
                'Contact us through our customer care number',
                style: textStyle12(context, color: CustomColor.descriptionColor),
              ),
              Text(
                '+91 8989207770',
                style: textStyle14(context, color: CustomColor.blackColor),
              ),
              Text(
                'Talk with our customer support executive at any time',
                style: textStyle14(context, fontWeight: FontWeight.w400),
              ),
              20.height,

              Row(
                children: [
                  Expanded(
                    child: CustomContainer(
                      color: CustomColor.appColor.withOpacity(0.2),
                      onTap: () => _openEmail(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: CustomColor.appColor),
                          8.width,
                          Text(
                            'Email',
                            style: textStyle14(context, color: CustomColor.appColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomContainer(
                      onTap: () {
                        ContactHelper.call('918989207770');
                      },
                      color: CustomColor.appColor.withOpacity(0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call, color: CustomColor.appColor),
                          8.width,
                          Text(
                            'Call',
                            style: textStyle14(context, color: CustomColor.appColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
