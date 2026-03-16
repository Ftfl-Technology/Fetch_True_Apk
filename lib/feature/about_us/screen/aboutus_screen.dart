import 'package:fetchtrue/feature/about_us/model/aboutus_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../repository/aboutus_service.dart';



class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _CancellationPolicyScreenState();
}

class _CancellationPolicyScreenState extends State<AboutUsScreen> {
  late Future<List<AboutUsModel>> _htmlFuture;

  @override
  void initState() {
    super.initState();
    _htmlFuture = AboutUsService().fetchContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'About Us', showBackButton: true),
      body: SafeArea(
        child: FutureBuilder<List<AboutUsModel>>(
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
