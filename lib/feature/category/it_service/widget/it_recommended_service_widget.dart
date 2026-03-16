import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/feature/category/it_service/bloc/it_recommended_service/it_recommended_service_bloc.dart';
import 'package:fetchtrue/feature/favorite/widget/favorite_service_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../bloc/it_recommended_service/it_recommended_service_state.dart';
import '../screen/it_service_details_screen.dart';


class ItRecommendedServiceWidget extends StatelessWidget {
  final String moduleId;
  const ItRecommendedServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<ItRecommendedServiceBloc, ItRecommendedServiceState>(
      builder: (context, state) {
        if (state is ItRecommendedServiceLoading) {
          return const ItRecommendedServiceShimmer();

        }

        if (state is ItRecommendedServiceLoaded) {

          final recommendedList = state.data.data;

          if(recommendedList.isEmpty){
            return SizedBox.shrink();
          }

          return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(
                    right: dimensions.screenHeight*0.010,
                    left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.020),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recommended For You ', style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),

                    // Text('View All', style: textStyle12(context, color: CustomColor.greyColor),)
                  ],
                ),
              ),
              10.height,
              SizedBox(
                height: dimensions.screenHeight * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedList.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final data = recommendedList[index];

                    return SizedBox(
                      width: dimensions.screenHeight*0.35,
                      child: InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color(0xFFE2E9F1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )
                          ),
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomNetworkImage(
                                  imageUrl: data.thumbnailImage,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                shape: BoxShape.circle
                                            ),
                                            child: FavoriteServiceButtonWidget(serviceId: data.id)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              10.height,

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data.serviceName, style: TextStyle(fontWeight: FontWeight.w500),),
                                        5.height,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomContainer(
                                                border: false,
                                                color: Colors.white,
                                                margin: EdgeInsets.zero,
                                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                child: Text(data.category.name, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,color: CustomColor.descriptionColor),)),
                                            Row(
                                              spacing: 10,
                                              children: [
                                                CustomContainer(
                                                    border: true,
                                                    color: Colors.blue,
                                                    margin: EdgeInsets.zero,
                                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                    child: Text('Earn Up To ${data.franchiseDetails.commission}', style: TextStyle(fontSize: 10,color: CustomColor.whiteColor,fontWeight: FontWeight.w500),)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              10.height,

                              if (data.keyValues.isNotEmpty)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    // First item
                                    if (data.keyValues.length > 0)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (data.keyValues[0].icon?.isNotEmpty == true)
                                            Image.network(
                                              data.keyValues[0].icon.toString(),
                                              height: 12,
                                            ),

                                          const SizedBox(width: 5),

                                          Text(
                                            data.keyValues[0].value,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),

                                    // Second item
                                    if (data.keyValues.length > 1)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (data.keyValues[1].icon?.isNotEmpty == true)
                                            Image.network(
                                              data.keyValues[1].icon.toString(),
                                              height: 12,
                                            ),

                                          const SizedBox(width: 5),

                                          Text(
                                            data.keyValues[1].value,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),


                              10.height,

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        spacing: 2,
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
                                                  size: 18,
                                                  color: Colors.amber,
                                                );
                                              } else if (index < rating && rating % 1 != 0) {
                                                // half star
                                                return const Icon(
                                                  Icons.star_half,
                                                  size: 18,
                                                  color: Colors.amber,
                                                );
                                              } else {
                                                // empty star
                                                return const Icon(
                                                  Icons.star_border,
                                                  size: 18,
                                                  color: Colors.amber,
                                                );
                                              }
                                            }),
                                          ),

                                          Row(
                                            spacing: 5,
                                            children: [
                                               Icon(Icons.account_circle_outlined, size: 12, color: Colors.grey.shade700,),
                                              Text(
                                                '${data.totalReviews}+ Reviews',
                                                style:  TextStyle(fontSize: 12,color: Colors.grey.shade700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  CustomContainer(
                                    color: Colors.white,
                                    margin: EdgeInsets.zero,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Starting from',style: TextStyle(fontSize: 10, color: Colors.grey),),
                                        CustomAmountText(amount: data.serviceDetails.packages.first.discountedPrice.toStringAsFixed(0), fontSize: 16,fontWeight: FontWeight.w500),
                                        Row(
                                          spacing: 5,
                                          children: [
                                            CustomAmountText(amount: data.serviceDetails.packages.first.price.toStringAsFixed(0),color: Colors.grey.shade700, fontSize: 12,fontWeight: FontWeight.w500,isLineThrough: true),
                                            Text('(${ data.serviceDetails.packages.first.discount}% Off)', style: TextStyle(fontSize: 12,color: CustomColor.appColor),)

                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ItServiceDetailsScreen(
                            serviceId: data.id,
                            serviceName: data.serviceName,
                          ),));
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }

        if (state is ItRecommendedServiceError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}


class ItRecommendedServiceShimmer extends StatelessWidget {
  const ItRecommendedServiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: dimensions.screenHeight * 0.010,
            right: dimensions.screenHeight * 0.010,
            top: dimensions.screenHeight * 0.020,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              shimmerBox(height: 16, width: 120),
              shimmerBox(height: 12, width: 60),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: dimensions.screenHeight * 0.35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: dimensions.screenHeight * 0.35,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// IMAGE
                      shimmerBox(
                        height: dimensions.screenHeight * 0.18,
                        width: double.infinity,
                        radius: 15,
                      ),

                      const SizedBox(height: 10),

                      /// SERVICE NAME
                      shimmerBox(height: 14, width: double.infinity),

                      const SizedBox(height: 6),

                      /// CATEGORY + COMMISSION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          shimmerBox(height: 12, width: 80),
                          shimmerBox(height: 12, width: 100),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// KEY VALUES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          shimmerBox(height: 10, width: 70),
                          shimmerBox(height: 10, width: 70),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// RATING + PRICE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmerBox(height: 14, width: 90),
                              const SizedBox(height: 4),
                              shimmerBox(height: 10, width: 60),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              shimmerBox(height: 10, width: 70),
                              const SizedBox(height: 4),
                              shimmerBox(height: 16, width: 60),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget shimmerBox({
    required double height,
    required double width,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
