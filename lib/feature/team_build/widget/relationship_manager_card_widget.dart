

import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RelationshipManagerCardWidget extends StatelessWidget {
 final ImageProvider<Object>? backgroundImage;
 final double? radius;
 final String? name;
 final String? phone;
 final String? id;
 final String? address;
 final String? level;
 final bool? status;
  const RelationshipManagerCardWidget({super.key, this.backgroundImage, this.name, this.phone, this.id, this.level, this.address, this.radius, this.status});

  @override
  Widget build(BuildContext context) {
   Dimensions dimensions = Dimensions(context);
    return CustomContainer(
      border: false,
      borderColor: CustomColor.appColor,
      color: Colors.white,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CustomContainer(
            color: Colors.blue.shade50,
            child: Column(
              children: [
                CustomContainer(
                  height: 50,
                  margin: EdgeInsets.zero,
                  assetsImg: 'assets/image/manager_back_card.jpg',
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: status == true ? Colors.grey :CustomColor.appColor,
                             borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(level!, style: textStyle12(context, color: CustomColor.whiteColor),)),
                    ],
                  ),
                ),
                5.height,
                CustomContainer(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Id ${id ?? '#XXXXX'}', style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                      SizedBox(height: dimensions.screenHeight*0.11,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        decoration: BoxDecoration(
                            color: CustomColor.appColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Contact Us', style: textStyle12(context, color: CustomColor.appColor),),

                            Row(
                              spacing: 20,
                              children: [
                                InkWell(
                                    onTap: () => ContactHelper.call('+91${phone}'),
                                    child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),

                                InkWell(
                                    onTap: () => ContactHelper.whatsapp('+91${phone}', 'Hello ${name}!'),
                                    child: Image.asset(CustomIcon.whatsappIcon, height: 25,color: CustomColor.greenColor,)),

                              ],
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                )
              ],
            ),
          ),

          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               40.height,
               Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
                 padding: EdgeInsets.all(5),
                 child: Container(
                   height: 80,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     shape: BoxShape.circle,
                     image: DecorationImage(
                       image: backgroundImage ??  AssetImage(CustomImage.nullImage),
                       fit: BoxFit.cover,
                     ),

                   ),
                 ),
               ),

                Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Text('Relationship Manager', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                 Text(name?? 'Guest',style: TextStyle(fontSize: 16,color: Colors.grey.shade700),),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}




class RelationshipManagerCardShimmer extends StatelessWidget {
  const RelationshipManagerCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      border: false,
      borderColor: CustomColor.appColor,
      color: Colors.white,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 15, left: 10, right: 10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 100, height: 10),
                      8.height,
                      ShimmerBox(width: 120, height: 10),
                      8.height,
                      ShimmerBox(width: 140, height: 10),
                    ],
                  )
                ],
              ),
              const Divider(),
              10.height,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerBox(
                    width: 160,
                    height: 25,
                  ),
                  Row(
                    children: [
                      ShimmerBox(width: 25, height: 25,),
                      30.width,
                      ShimmerBox(width: 25, height: 25,),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
