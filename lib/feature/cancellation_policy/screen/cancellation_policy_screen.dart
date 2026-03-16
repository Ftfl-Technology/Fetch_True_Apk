import 'package:fetchtrue/feature/cancellation_policy/model/cancellationpolicy_model.dart';
import 'package:fetchtrue/feature/refund_policy/model/refundpolicy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../repository/cancellationpolicy_service.dart';



class CancellationPolicyScreen extends StatefulWidget {
  const CancellationPolicyScreen({super.key});

  @override
  State<CancellationPolicyScreen> createState() => _CancellationPolicyScreenState();
}

class _CancellationPolicyScreenState extends State<CancellationPolicyScreen> {
  late Future<List<CancellationPolicyModel>> _htmlFuture;

  @override
  void initState() {
    super.initState();
    _htmlFuture = CancellationPolicyService().fetchContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Cancellation Policy', showBackButton: true),
      body: SafeArea(
        child: FutureBuilder<List<CancellationPolicyModel>>(
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
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              separatorBuilder: (_, __) => const Divider(),
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
