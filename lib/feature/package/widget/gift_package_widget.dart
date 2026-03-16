import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

// Constants
const List<Map<String, dynamic>> kWelcomeGift = [
  {'gift': 'Branded T-shirt', 'icon': CupertinoIcons.tag},
  {'gift': 'Laptop Bag', 'icon': Icons.laptop},
  {'gift': 'Notebook', 'icon': CupertinoIcons.book},
  {'gift': 'Pen', 'icon': CupertinoIcons.pencil},
  {'gift': 'Water Bottle', 'icon': CupertinoIcons.drop},
  {'gift': 'Branded T-shirt', 'icon': CupertinoIcons.tag},
  {'gift': 'Lanyard & ID Holder', 'icon': CupertinoIcons.person_crop_circle},
  {'gift': 'Booklet', 'icon': CupertinoIcons.doc_text},
];

class GiftPackageWidget extends StatelessWidget {
  const GiftPackageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            Icon(CupertinoIcons.gift, size: 16,color: CustomColor.greenColor,),
            10.width,
            Text(
              'Welcome Gift',
              style: textStyle12(context, color: CustomColor.appColor),
            ),
          ],
        ),
        10.height,
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: kWelcomeGift.map((giftItem) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: CustomColor.whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(giftItem['icon'], size: 16, color: CustomColor.appColor),
                  5.width,
                  Text(giftItem['gift'], style: textStyle12(context, color: Colors.grey.shade600, fontWeight: FontWeight.w400)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
