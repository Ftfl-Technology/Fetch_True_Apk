
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../package/screen/package_screen.dart';

class OfferDialogWidget extends StatelessWidget {
  const OfferDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: CustomColor.whiteColor,
              child: Icon(Icons.close, color: CustomColor.appColor, size: 16,),
            ),
          ),
        ),
        10.height,

        CustomContainer(
          color: CustomColor.whiteColor,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: dimensions.screenHeight*0.05,),
              Text(
                '🎉 Welcome Offer!',
                style: textStyle18(context, color: CustomColor.appColor),
              ),
              SizedBox(height: dimensions.screenHeight*0.05,),
             50.height,
              _buildAssuranceSection(context),
              SizedBox(height: dimensions.screenHeight*0.1,),
            ],
          ),
        ),
      ],
    );
  }
}


Widget _buildAssuranceSection(BuildContext context) {
  final userSession = Provider.of<UserSession>(context);
  return CustomContainer(
    border: true,
    color: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Image.asset('assets/package/packageBuyImg.png',)),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'We assure you  ',
                          style: textStyle14(context)),
                      TextSpan(
                        text: '5X Return ',
                        style: textStyle16(context,
                            color: CustomColor.appColor),
                      ),
                    ]),
                  ),
                  10.height,
                  Text(
                    'If you earn less than our assured earnings, we’ll refund up to 5X your initial amount',
                    style: textStyle12(context,
                        color: CustomColor.descriptionColor),
                    textAlign: TextAlign.right,
                  ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomAmountText(amount: '7,00,000', fontSize: 16,fontWeight: FontWeight.w500,),
                      10.width,
                      CustomContainer(
                        color: CustomColor.appColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Text(
                          'Buy Now',
                          style: textStyle14(context,
                              color: CustomColor.whiteColor),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),));
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
