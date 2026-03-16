import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';

import '../model/terms_conditions_model.dart';
import '../repository/terms_conditions_service.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  late Future<TermsConditionsModel> _termsFuture;

  @override
  void initState() {
    super.initState();
    _termsFuture = TermsConditionsService().fetchTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Terms & Conditions', showBackButton: true),
      body: SafeArea(
        child: FutureBuilder<TermsConditionsModel>(
          future: _termsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final terms = snapshot.data!;
            return  SingleChildScrollView(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: Html(data: terms.content));
          },
        ),
      ),
    );
  }
}
