import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FranchiseCommissionScreen extends StatelessWidget {
  final String commission;
  final String t_and_c;
  const FranchiseCommissionScreen({super.key, required this.commission, required this.t_and_c});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Franchise Commission',showBackButton: true,),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomContainer(
            border: true,
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Franchise Commission',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Earn Up to ${commission}',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
          
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Terms & Conditions',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: CustomColor.appColor),),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Html(data: t_and_c, style: {
                "p": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  lineHeight: LineHeight.number(1.4),
                ),
                "li": Style(
                ),
                "table": Style(
                ),
                "th": Style(
                ),
                "td": Style(
                ),
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "br": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                )
              },),
            ),
          )
        ],
      ),
    );
  }
}
