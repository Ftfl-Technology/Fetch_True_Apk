import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_amount_text.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../../franchise/screen/franchise_service_details_screen.dart';
import '../bloc/ai_hub_recommended_service/ai_hub_recommended_service_bloc.dart';
import '../bloc/ai_hub_recommended_service/ai_hub_recommended_service_state.dart';
import '../screen/ai_hub_service_details_screen.dart';

class AiHubLive24ServiceWidget extends StatelessWidget {
  final String moduleId;
  const AiHubLive24ServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<AiHubRecommendedServiceBloc, AiHubRecommendedServiceState>(
      builder: (context, state) {
        if (state is AiHubRecommendedServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is AiHubRecommendedServiceLoaded) {

          final recommendedList = state.data.data;

          if(recommendedList.isEmpty){
            return SizedBox.shrink();
          }

          return  Container(
            margin: EdgeInsets.only(top: 10),
            color: CustomColor.aiHub.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                 Column(
                   children: [
                     Text('Live in 24 hours', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
                       child: Text('The AI solution will be set up, activated, and ready to deliver value within one day.',
                         style: TextStyle(fontSize: 16,),textAlign: TextAlign.center,),
                     ),
                   ],
                 ),
                30.height,
                SizedBox(
                  height: dimensions.screenHeight * 0.35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendedList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      final data = recommendedList[index];

                      return SizedBox(
                        width: dimensions.screenHeight*0.36,
                        child: CustomContainer(
                          color: Color(0xFFF4F4F4),
                          border: true,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 10),
                          child: Stack(
                            alignment: AlignmentGeometry.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  Expanded(flex: 2,
                                    child: CustomNetworkImage(
                                      imageUrl: data.thumbnailImage,
                                      fit: BoxFit.cover,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: FavoriteServiceButtonWidget(serviceId: data.id)),

                                            SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(child: Container(color: Colors.grey.shade50,)),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipPath(
                                    clipper: RightTrapeziumClipper(),
                                    child: Container(
                                      padding: const EdgeInsets.only(right: 25,left: 10,top: 5,),
                                      color: Color(0xFFF4F4F4),
                                      child: Text(
                                        "${data.serviceName}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF4F4F4),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          5.height,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomContainer(
                                                  color: Colors.white,
                                                  margin: EdgeInsets.zero,
                                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                  child: Text(data.category.name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10),)),

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
                                            ],
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
                                                    10.height,
                                                    Text('Setup & Time',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: Colors.black),),
                                                    10.height,

                                                    Column(
                                                        spacing: 5,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: List.generate(data.keyValues.length,
                                                              (index) {
                                                            final tag = data.keyValues[index];
                                                            return Row(
                                                              spacing: 5,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                if(tag.icon!.isNotEmpty)
                                                                  Image.network(tag.icon.toString(),height: 10,),
                                                                Expanded(child: Text('${tag.key} ${tag.value}',style: TextStyle(fontSize: 10,color: Colors.grey.shade700),)),
                                                              ],
                                                            );
                                                          },)
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Column(
                                                spacing: 5,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  CustomContainer(
                                                    color: Color(0xFF89FF9B),
                                                    margin: EdgeInsets.zero,
                                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                    child: Text('Earn ${data.franchiseDetails.commission}',style: TextStyle(fontSize: 10),),),
                                                  CustomContainer(
                                                    color: Color(0xFFF5F8FF),
                                                    margin: EdgeInsets.zero,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text('Starting from',style: TextStyle(fontSize: 12,color: Colors.grey),),
                                                        CustomAmountText(amount: data.serviceDetails.packages.first.discountedPrice.toStringAsFixed(0), fontSize: 16,fontWeight: FontWeight.w500),
                                                        Row(
                                                          spacing: 5,
                                                          children: [
                                                            CustomAmountText(amount: data.serviceDetails.packages.first.price.toStringAsFixed(0), fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey.shade700,isLineThrough: true),
                                                            Text('(${data.serviceDetails.packages.first.discount}% Off)', style: TextStyle(fontSize: 10,color: CustomColor.appColor),),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AiHubServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),));
                          },
                        ),
                      );
                    },
                  ),
                ),
                20.height,
              ],
            ),
          );
        }

        if (state is AiHubRecommendedServiceError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}