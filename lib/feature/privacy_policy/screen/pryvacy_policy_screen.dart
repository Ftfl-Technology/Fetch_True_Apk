import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/privacypolicy_model.dart';
import '../repository/privacypolicy_service.dart';


class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late Future<List<PrivacyPolicyModel>> _htmlFuture;

  @override
  void initState() {
    super.initState();
    _htmlFuture = PrivacyPolicyService().fetchContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Privacy & Policy', showBackButton: true),
      body: SafeArea(
        child: FutureBuilder<List<PrivacyPolicyModel>>(
          future: _htmlFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final dataList = snapshot.data ?? [];

            return ListView.separated(
              itemCount: dataList.length,
              separatorBuilder: (_, __) => const Divider(),
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final policy = dataList[index];
                return Html(data: policy.content);
              },
            );
          },
        ),
      ),
    );
  }
}
