import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/business/bloc/business_popular_service/business_popular_service_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/custom_log_emoji.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../bloc/business_popular_service/business_popular_service_state.dart';
import '../screen/business_service_details_screen.dart';


class BusinessHighDemandServiceWidget extends StatelessWidget {
  final String moduleId;
  const BusinessHighDemandServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<BusinessPopularServiceBloc, BusinessPopularServiceState>(
      builder: (context, state) {
        if (state is BusinessPopularServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is BusinessPopularServiceLoaded) {

          final popularList = state.data.data;

          if(popularList.isEmpty){
            return SizedBox.shrink();
          }

          return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('High Demand', style: TextStyle(fontSize: 16, color: CustomColor.business, fontWeight: FontWeight.w600),),

                    // CustomContainer(
                    //   color: CustomColor.business,
                    //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    //   child: Row(
                    //     spacing: 5,
                    //     children: [
                    //       Text('View All', style: textStyle12(context, color: Colors.white),),
                    //       Icon(Icons.arrow_forward_ios, color: Colors.white,size: 14,)
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              10.height,
              SizedBox(
                height: dimensions.screenHeight * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularList.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final data = popularList[index];

                    return SizedBox(
                      width: dimensions.screenHeight*0.38,
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: dimensions.screenWidth*0.2,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE6E6E6),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Row(
                                              children:  [
                                                Icon(Icons.verified, color: CustomColor.business, size: 10),
                                                SizedBox(width: 6),
                                                Text(
                                                  "Trusted",
                                                  style: TextStyle(fontSize: 10,color: CustomColor.business),
                                                ),
                                              ],
                                            ),
                                          ),
                                          FavoriteServiceButtonWidget(serviceId: data.serviceId),
                                        ],
                                      ),
                                      // Align(
                                      //   alignment: Alignment.bottomRight,
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //         color: CustomColor.whiteColor,
                                      //         borderRadius: BorderRadius.only(
                                      //           topLeft: Radius.circular(12),
                                      //         )
                                      //     ),
                                      //     child: Container(
                                      //       padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                      //       margin: EdgeInsets.all(5),
                                      //       decoration: BoxDecoration(
                                      //           color: CustomColor.business,
                                      //           borderRadius: BorderRadius.only(
                                      //             topLeft: Radius.circular(10),
                                      //           )
                                      //       ),
                                      //       child: Text('${CustomLogEmoji.star} ${data.averageRating}', style: TextStyle(fontSize: 12,color: CustomColor.whiteColor),),
                                      //     ),
                                      //   ),
                                      // ),


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
                                      Text(data.serviceName, style: TextStyle(fontWeight: FontWeight.w600),),
                                      Text(data.category.name, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,color: CustomColor.descriptionColor),),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('--EARN UP TO--', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),),
                                    Text(data.franchiseDetails.commission, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: CustomColor.greenColor),),
                                  ],
                                ),
                              ],
                            ),
                            15.height,

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if(data.franchiseDetails.investmentRange.isNotEmpty)
                                    _InfoColumn(title: 'Investment', value: '${data.franchiseDetails.investmentRange.first.range.toString()} ${data.franchiseDetails.investmentRange.first.parameters.toString()}'),
                                  Container(color: Colors.grey,width: 1,height: 35,),

                                  if(data.franchiseDetails.monthlyEarnPotential.isNotEmpty)
                                    _InfoColumn(title: 'Earnings', value: '${data.franchiseDetails.monthlyEarnPotential.first.range.toString()} ${data.franchiseDetails.monthlyEarnPotential.first.parameters.toString()}'),
                                  Container(color: Colors.grey,width: 1,height: 35,),

                                  if( data.serviceDetails.roi.isNotEmpty)
                                    _InfoColumn(title: 'ROI', value: data.serviceDetails.roi.first),
                                ],
                              ),
                            ),

                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessServiceDetailsScreen(
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

        if (state is BusinessPopularServiceError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const _InfoColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: CustomColor.business),
        ),
      ],
    );
  }
}