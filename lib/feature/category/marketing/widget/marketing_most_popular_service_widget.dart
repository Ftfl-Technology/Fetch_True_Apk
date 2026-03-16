import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/feature/category/marketing/bloc/marketing_popular_service/marketing_popular_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../bloc/marketing_popular_service/marketing_popular_service_state.dart';
import '../screen/marketing_details_screen.dart';


class MarketingMostPopularServiceWidget extends StatelessWidget {
  final String moduleId;
  const MarketingMostPopularServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<MarketingPopularServiceBloc, MarketingPopularServiceState>(
      builder: (context, state) {
        if (state is MarketingPopularServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is MarketingPopularServiceLoaded) {

          final popularServices = state.data.data;

          if(popularServices.isEmpty){
            return SizedBox.shrink();
          }


          return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(
                    right: dimensions.screenHeight*0.010,
                    left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Most Popular', style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),
                    //
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
                  itemCount: popularServices.length,
                  // itemCount: state.model.data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final data = popularServices[index];

                    return SizedBox(
                      width: dimensions.screenHeight*0.39,
                      child: CustomContainer(
                        color: Colors.white,
                        border: true,
                        padding: const EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            Column(
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
                                                child: FavoriteServiceButtonWidget(serviceId: data.serviceId)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                15.height,

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data.serviceName, style: TextStyle(fontWeight: FontWeight.w500),),
                                          Text(data.category.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.grey),),
                                        ],
                                      ),
                                    ),

                                    if(data.franchiseDetails.commission.isNotEmpty)
                                      CustomContainer(
                                          border: true,
                                          color: Color(0xFF548AFE),
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          margin: EdgeInsets.zero,
                                          child: Text('Earn Up To ${data.franchiseDetails.commission}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.white),)),
                                  ],
                                ),
                                10.height,


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          if(data.keyValues.isNotEmpty)
                                            Column(
                                              children: List.generate(
                                                data.keyValues.length > 2 ? 2 : data.keyValues.length,
                                                    (index) {
                                                  final keyValue = data.keyValues[index];
                                                  return Padding(
                                                    padding: const EdgeInsets.only(right: 10),
                                                    child: Row(
                                                      spacing: 5,
                                                      children: [
                                                        Image.network(keyValue.icon, height: 15),
                                                        Text(
                                                          keyValue.value,
                                                          style: const TextStyle(fontSize: 10),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                          10.height,
                                          Flex(
                                            direction: data.keyValues.isEmpty ?Axis.vertical: Axis.horizontal,
                                            spacing: 10,
                                            children: [
                                              Row(
                                                spacing: 1,
                                                children: List.generate(5, (index) {
                                                  final rating = data.averageRating; // e.g. 3.5

                                                  if (index < rating.floor()) {
                                                    // full star
                                                    return const Icon(
                                                      Icons.star,
                                                      size: 14,
                                                      color: Colors.amber,
                                                    );
                                                  } else if (index < rating && rating % 1 != 0) {
                                                    // half star
                                                    return const Icon(
                                                      Icons.star_half,
                                                      size: 14,
                                                      color: Colors.amber,
                                                    );
                                                  } else {
                                                    // empty star
                                                    return const Icon(
                                                      Icons.star_border,
                                                      size: 14,
                                                      color: Colors.amber,
                                                    );
                                                  }
                                                }),
                                              ),

                                              Row(
                                                spacing: 5,
                                                children: [
                                                  const Icon(Icons.account_circle_outlined, size: 12),
                                                  Text(
                                                    '${data.totalReviews}+ Reviews',
                                                    style: const TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                    CustomContainer(
                                      color: Color(0xFFF5F8FF),
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Text('Starting from', style: TextStyle(fontSize: 10,color: Colors.grey),),
                                          CustomAmountText(amount: data.packages.first.discountedPrice.toStringAsFixed(0), fontSize: 16,fontWeight: FontWeight.w500),
                                          Row(
                                            spacing: 10,
                                            children: [
                                              CustomAmountText(amount: data.packages.first.price.toStringAsFixed(0), fontSize: 12,fontWeight: FontWeight.w400,isLineThrough: true),
                                              Text('(${data.packages.first.discount}% Off)', style: TextStyle(fontSize: 10,color: CustomColor.marketing),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),

                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey,width: 0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(Icons.verified_user_outlined, color: Colors.blue, size: 14),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MarketingDetailsScreen(
                            serviceId: data.serviceId,
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

        if (state is MarketingPopularServiceError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}


