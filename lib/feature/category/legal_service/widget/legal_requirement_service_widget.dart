import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/legal_service/bloc/legal_recommended_service/legal_recommended_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_amount_text.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../bloc/legal_recommended_service/legal_recommended_service_state.dart';
import '../screen/legal_service_details_screen.dart';


class LegalRequirementServiceWidget extends StatelessWidget {
  final String moduleId;
  const LegalRequirementServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<LegalRecommendedServiceBloc, LegalRecommendedServiceState>(
      builder: (context, state) {
        if (state is LegalRecommendedServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is LegalRecommendedServiceLoaded) {

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Recommended', style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),

                    // Text('View All', style: textStyle12(context, color: CustomColor.legal),)
                  ],
                ),
              ),
              10.height,
              SizedBox(
                height: dimensions.screenHeight * 0.38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedList.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {

                    final data = recommendedList[index];

                    return SizedBox(
                      width: dimensions.screenWidth*0.9,
                      child: CustomContainer(
                        color: Color(0xFFF9F5EE),
                        border: true,
                        padding: const EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomNetworkImage(
                                imageUrl: data.thumbnailImage,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(10),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomContainer(
                                        border: true,
                                        color: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                        child: Row(
                                          spacing: 5,
                                          children: [
                                            Icon(Icons.verified_user_outlined,size: 12,color: Colors.blue,),
                                            Text('Trusted', style: TextStyle(fontSize: 10,color: Colors.blue, fontWeight: FontWeight.w500),),
                                          ],
                                        ),),
                                      10.width,
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.black38,
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
                                      Text(data.serviceName, style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                      10.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomContainer(
                                              color: Colors.white70,
                                              margin: EdgeInsets.zero,
                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                              child: Text(data.category.name, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: CustomColor.descriptionColor),)),
                                          Row(
                                           spacing: 10,
                                            children: [
                                              CustomContainer(
                                                  color: Color(0xFF548AFE),
                                                  margin: EdgeInsets.zero,
                                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                  child: Text('Earn Up To ${data.franchiseDetails.commission}', style: TextStyle(fontSize: 10,color: CustomColor.whiteColor),)),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            15.height,

                            if (data.keyValues.isNotEmpty) ...[
                              Row(
                                spacing: 10,
                                children: List.generate(
                                  data.keyValues.length > 2 ? 2 : data.keyValues.length,
                                      (i) => Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          spacing: 6,
                                          children: [

                                        Image.network(
                                          data.keyValues[i].icon,
                                          height: 12,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.image_not_supported_outlined,
                                              size: 12,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            data.keyValues[i].value,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              overflow: TextOverflow.clip
                                            ),
                                          ),
                                        ),
                                                                              ],
                                                                            ),
                                      ),
                                ),
                              ),
                            ],
                            10.height,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Reviews', style: TextStyle(fontSize: 10,),),
                                    Column(
                                      spacing: 2,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ⭐ Rating Stars
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

                                        // 👤 Reviews Count
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomContainer(
                                        color: Color(0xFFBC9958),
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        child: Text('${data.serviceDetails.packages.isNotEmpty
                                            ? data.serviceDetails.packages.first.discount
                                            : 0}% OFF', style: TextStyle(fontSize: 10,color: CustomColor.whiteColor),)),
                                    Text('Starting from',style: TextStyle(fontSize: 10, color: Colors.grey.shade700),),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        CustomAmountText(amount: '${data.serviceDetails.packages.isNotEmpty
                                            ? data.serviceDetails.packages.first.price.toStringAsFixed(0)
                                            : 0}',color: Colors.grey.shade700, fontSize: 14,fontWeight: FontWeight.w400,isLineThrough: true),
                                        CustomAmountText(amount: '${data.serviceDetails.packages.isNotEmpty
                                            ? data.serviceDetails.packages.first.discountedPrice.toStringAsFixed(0)
                                            : 0}', fontSize: 20,fontWeight: FontWeight.w500),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )

                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LegalServiceDetailsScreen(
                            serviceName: data.serviceName,
                            serviceId: data.id,
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

        if (state is LegalRecommendedServiceError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
