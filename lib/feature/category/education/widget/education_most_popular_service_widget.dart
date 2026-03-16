import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/education/bloc/education_popular_service/education_popular_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_amount_text.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../../it_service/screen/it_service_details_screen.dart';
import '../bloc/education_popular_service/education_popular_service_state.dart';
import '../screen/education_service_details_screen.dart';

class EducationMostPopularServiceWidget extends StatelessWidget {
  final String moduleId;
  final String? headline;
  const EducationMostPopularServiceWidget({super.key, required this.moduleId, this.headline});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<EducationPopularServiceBloc, EducationPopularServiceState>(
      builder: (context, state) {
        if (state is EducationPopularServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is EducationPopularServiceLoaded) {

          final popularList = state.data.data;
          if(popularList.isEmpty){
            return SizedBox.shrink();
          }

          return  Container(
            color: Color(0xFFEFEDFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.only(
                      right: dimensions.screenHeight*0.010,
                      left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(headline!, style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),

                      // Row(
                      //   spacing: 5,
                      //   children: [
                      //     Text('View All', style: textStyle12(context, color: CustomColor.blackColor),),
                      //     Icon(Icons.arrow_forward_ios, color: CustomColor.blackColor,size: 14,)
                      //   ],
                      // )
                    ],
                  ),
                ),
                10.height,
                SizedBox(
                  height: dimensions.screenHeight * 0.35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      final data = popularList[index];

                      return SizedBox(
                        width: dimensions.screenWidth*0.9,
                        child: CustomContainer(
                          color: Colors.white,
                          border: true,
                          padding: const EdgeInsets.all(8),
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CustomNetworkImage(
                                    imageUrl: data.thumbnailImage,
                                    fit: BoxFit.cover,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            spacing: 5,
                                            children: [
                                              Icon(Icons.verified, color: Colors.blue, size: 14),
                                              Text('Trusted',style: TextStyle(fontSize: 10,color: CustomColor.education,fontWeight: FontWeight.w500),)
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: FavoriteServiceButtonWidget(serviceId: data.serviceId)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              10.height,

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${data.serviceName}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                        10.height,
                                        Row(
                                          spacing: 15,
                                          children: [
                                            CustomContainer(
                                                margin: EdgeInsets.zero,
                                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                child: Text(data.category.name, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10,color: Colors.grey.shade700),)),
                                            CustomContainer(
                                              margin: EdgeInsets.zero,
                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                              child: Row(
                                                spacing: 5,
                                                children: [
                                                  Icon(Icons.circle, color: CustomColor.greenColor,size: 10,),
                                                  Text('Online mode', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10,color: Colors.grey.shade700),),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    spacing: 5,
                                    children: [
                                      CustomContainer(
                                          color: CustomColor.education,
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                          margin: EdgeInsets.zero,
                                          child: Text('Earn Up To ${data.franchiseDetails.commission}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.white),)),
                                    ],
                                  ),
                                ],
                              ),

                              10.height,

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      if(data.keyValues.isNotEmpty)
                                        Image.network(data.keyValues[0].icon,height: 14,),
                                      if(data.keyValues.isNotEmpty)
                                        Text('${data.keyValues[0].value}', style: TextStyle(fontSize: 10,color: Colors.grey.shade600),),
                                    ],
                                  ),

                                  Row(
                                    spacing: 5,
                                    children: [
                                      if(data.keyValues.isNotEmpty)
                                        Image.network(data.keyValues[1].icon,height: 14,),
                                      if(data.keyValues.isNotEmpty)
                                        Text('${data.keyValues[1].value}', style: TextStyle(fontSize: 10,color: Colors.grey.shade600),),
                                    ],
                                  ),
                                ],
                              ),

                              10.height,


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    spacing: 5,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        spacing: 4,
                                        children: List.generate(5, (index) {
                                          final rating = data.averageRating; // e.g. 3.5

                                          if (index < rating.floor()) {
                                            // full star
                                            return const Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.amber,
                                            );
                                          } else if (index < rating && rating % 1 != 0) {
                                            // half star
                                            return const Icon(
                                              Icons.star_half,
                                              size: 16,
                                              color: Colors.amber,
                                            );
                                          } else {
                                            // empty star
                                            return const Icon(
                                              Icons.star_border,
                                              size: 16,
                                              color: Colors.amber,
                                            );
                                          }
                                        }),
                                      ),
                                      Row(
                                        spacing: 5,
                                        children: [
                                          Icon(Icons.account_circle_outlined, size: 12,color: Colors.grey.shade600,),
                                          Text('${data.totalReviews}+ Reviews', style: TextStyle(fontSize: 10, color: Colors.grey.shade600),)
                                        ],
                                      ),
                                    ],
                                  ),

                                  if (data.packages.isNotEmpty)
                                    CustomContainer(
                                      color: Color(0xFFF7F7F7),
                                      margin: EdgeInsets.zero,
                                      child: Column(
                                        children: [
                                          CustomAmountText(amount: data.packages.first.discountedPrice.toStringAsFixed(0), fontSize: 16,fontWeight: FontWeight.w500),
                                          Row(
                                            spacing: 5,
                                            children: [
                                              CustomAmountText(amount: data.packages.first.price.toStringAsFixed(0), color: Colors.grey.shade700,fontSize: 12,fontWeight: FontWeight.w400,isLineThrough: true),
                                              Text('(${data.packages.first.discount}% Off)', style: TextStyle(fontSize: 12, color: CustomColor.appColor),),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                ],
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EducationServiceDetailsScreen(
                              serviceName: data.serviceName,
                              serviceId: data.serviceId,
                            ),));
                          },
                        ),
                      );
                    },
                  ),
                ),
                10.height,
              ],
            ),
          );
        }

        if (state is EducationPopularServiceError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
