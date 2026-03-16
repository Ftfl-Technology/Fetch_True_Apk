import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/it_service/bloc/it_top_trending_service/it_top_trending_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_amount_text.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../bloc/it_top_trending_service/it_top_trending_service_state.dart';
import '../screen/it_service_details_screen.dart';


class ItTopTrendingServiceWidget extends StatelessWidget {
  final String moduleId;
  const ItTopTrendingServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<ItTopTrendingServiceBloc, ItTopTrendingServiceState>(
      builder: (context, state) {
        if (state is ItTopTrendingServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is ItTopTrendingServiceLoaded) {

          final topTrendingList = state.data.data;
          if(topTrendingList.isEmpty){
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
                    Text('Top Trending', style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),

                    // Text('View All', style: textStyle12(context, color: CustomColor.greyColor),)
                  ],
                ),
              ),
              10.height,
              SizedBox(
                height: dimensions.screenHeight * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topTrendingList.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final data = topTrendingList[index];

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

        if (state is ItTopTrendingServiceError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
