import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../model/package_model.dart';

class PackageBenefitsScreen extends StatelessWidget {
  final PackageModel package;
  final String planKey;
  const PackageBenefitsScreen({super.key, required this.package, required this.planKey,});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: "Benefits", showBackButton: true,),
      body: SafeArea(child:
      Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(Icons.wallet, color: CustomColor.appColor,),
                    Text('Up to 15%\nRevenue Share', style: textStyle12(context, color: CustomColor.descriptionColor),textAlign: TextAlign.center,),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.info, color: CustomColor.appColor,),
                    Text('Standard\nTemplate', style: textStyle12(context, color: CustomColor.descriptionColor),textAlign: TextAlign.center,),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.timelapse_outlined, color: CustomColor.appColor,),
                    Text('Support\nWithin 3-6 hrs', style: textStyle12(context, color: CustomColor.descriptionColor),textAlign: TextAlign.center,),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: CustomContainer(
              border: true,
              color: CustomColor.whiteColor,
              child: SingleChildScrollView(
                  child: Html(
                    data: package.description[planKey] ?? "",
                  ),
              ),
            ),
          ),
        ],
      )
      ),
    );
  }
}
