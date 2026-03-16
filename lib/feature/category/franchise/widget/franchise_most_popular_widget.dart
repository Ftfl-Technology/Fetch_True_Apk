import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../bloc/franchise_popular_service/franchise_popular_service_bloc.dart';
import '../bloc/franchise_popular_service/franchise_popular_service_state.dart';
import '../screen/franchise_service_details_screen.dart';

class FranchiseMostPopularWidget extends StatelessWidget {
  final String moduleId;
  final String? headline;
  const FranchiseMostPopularWidget({super.key, required this.moduleId, this.headline});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<FranchisePopularServiceBloc, FranchisePopularServiceState>(
      builder: (context, state) {
        if (state is FranchisePopularServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is FranchisePopularServiceLoaded) {

          final services = state.data.data;

          if (services.isEmpty) {
            return SizedBox.shrink();
          }

          return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.03),
                child: Text(headline!, style: textStyle14(context),),
              ),
              10.height,

              SizedBox(
                height: dimensions.screenHeight * 0.347,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final data = services[index];
                    return SizedBox(
                      width: dimensions.screenHeight*0.4,
                      child: CustomContainer(
                        color: Color(0xFFE1E1E1),
                        // assetsImg: 'assets/image/franchise_card_img.jpg',
                        border: true,
                        padding: const EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 10),
                        gradient: LinearGradient(
                            begin: AlignmentGeometry.topCenter,
                            end: AlignmentGeometry.bottomCenter,
                            colors: [
                              Color(0xFFE9947C),
                              Color(0xFFE1A696),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 🔹 Image
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CustomNetworkImage(
                                  imageUrl: data.thumbnailImage.toString(),
                                  fit: BoxFit.cover,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomContainer(
                                          color: Colors.white,
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(5),
                                          child: Icon(Icons.verified_user_outlined, size: 15,color: CustomColor.appColor,),
                                        ),


                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: CircleAvatar(
                                                  backgroundColor: Colors.black38,
                                                  child: FavoriteServiceButtonWidget(serviceId: data.serviceId,)),
                                            ),


                                          ],
                                        ),
                                      ],
                                    ),
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
                                      Text(
                                        data.serviceName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white),
                                      ),
                                      4.height,
                                      Text(
                                          data.category.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:  TextStyle(fontSize: 10,color: Colors.white)
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  spacing: 5,
                                  children: [
                                    CustomContainer(
                                      color: Color(0xFF548AFE),
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                      child: Text('Earn Up To ${data.franchiseDetails?.commission}',
                                        style: TextStyle(fontSize: 8, color: Colors.white,fontWeight: FontWeight.w500),),
                                    ),

                                    if(data.franchiseDetails.franchiseModel.first.discount!=0)
                                      CustomContainer(
                                        color: Color(0xFF76FF8B),
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 2),
                                        child: Text(
                                          '${data.franchiseDetails.franchiseModel.first.discount}% OFF',
                                          style: TextStyle(fontSize: 8, color: Colors.black,fontWeight: FontWeight.w500),),
                                      ),
                                  ],
                                )
                              ],
                            ),

                            Row(
                              spacing: 10,
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

                                // 👤 Reviews Count
                                Row(
                                  spacing: 5,
                                  children: [
                                    const Icon(Icons.account_circle_outlined, size: 12,color: Colors.black,),
                                    Text(
                                      '${data.totalReviews}+ Reviews',
                                      style: const TextStyle(fontSize: 10,color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            10.height,

                            CustomContainer(
                              margin: EdgeInsets.zero,
                             color: Color(0xFFFFFFFF).withOpacity(0.19) ,
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildInfoCard(
                                      amount: '${data.franchiseDetails.monthlyEarnPotential.first.range} ${data.franchiseDetails.monthlyEarnPotential.first.parameters}',
                                      des: 'Monthly\nEarning'
                                  ),

                                  Container(
                                    height: 40,width: 1,
                                    color: Colors.grey,
                                  ),

                                  _buildInfoCard(
                                      amount: '${data.franchiseDetails.investmentRange.first.range} ${data.franchiseDetails.investmentRange.first.parameters}',
                                      des: 'Investment\nRange'
                                  ),

                                  Container(
                                    height: 40,width: 1,
                                    color: Colors.grey,
                                  ),
                                  _buildInfoCard(
                                      amount: '${data.franchiseDetails.areaRequired}',
                                      // amount: '${data.franchiseDetails.investmentRange.first.range}',
                                      des: 'Area\nRequired'
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseServiceDetailsScreen(
                            serviceName: data.serviceName,
                            serviceId: data.serviceId,
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

        if (state is FranchisePopularServiceError) {
          print('Franchise Requirement Service Error ${state.message}');
          return SizedBox.shrink();
        }

        return const SizedBox();
      },
    );
  }
}

Widget _buildInfoCard({required String amount, required String des,}){
  return Column(
    children: [
      Text(amount, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,color: Colors.white),),
      5.height,
      Text(des, style: TextStyle(fontSize: 10,color: Colors.white),textAlign: TextAlign.center,)
    ],
  );
}