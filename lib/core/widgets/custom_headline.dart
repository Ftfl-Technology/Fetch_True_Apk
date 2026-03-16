import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../costants/text_style.dart';

class CustomHeadline extends StatelessWidget {
  final String? headline;
  final VoidCallback? onTap;
  final bool? viewSeeAll;
  const CustomHeadline({super.key, this.headline, this.onTap, this.viewSeeAll= true});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(headline??'Headline', style: textStyle14(context),),
          if (viewSeeAll!)InkWell(
              onTap: onTap,
              child: Row(
                spacing: 5,
                children: [
                  Text('', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                  Icon(Icons.arrow_forward_ios, size: 12,)
                ],
              )),
        ],
      ),
    );
  }
}
