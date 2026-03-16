import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/finance/bloc/finance_popular_service/finance_popular_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../bloc/finance_popular_service/finance_popular_service_state.dart';
import '../screen/finance_service_details_screen.dart';


class FinanceBestSellingServiceWidget extends StatelessWidget {
  final String moduleId;
  const FinanceBestSellingServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<FinancePopularServiceBloc, FinancePopularServiceState>(
      builder: (context, state) {
        if (state is FinancePopularServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is FinancePopularServiceLoaded) {

          final popularList = state.data.data;

          if(popularList.isEmpty){
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
                    Text('Best Selling', style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),

                    // Text('View All', style: textStyle12(context, color: CustomColor.finance),)
                  ],
                ),
              ),
              10.height,
              SizedBox(
                height: dimensions.screenHeight * 0.32,
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
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [


                                        Container(
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.black38,
                                                shape: BoxShape.circle
                                            ),
                                            child: FavoriteServiceButtonWidget(serviceId: data.serviceId)),
                                      ],
                                    ),
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

                                      CustomContainer(
                                          border: false,
                                          color: Colors.grey.shade50,
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                          child: Text(data.category.name, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: CustomColor.descriptionColor),)),
                                    ],
                                  ),
                                ),

                                Column(
                                  spacing: 10,
                                  children: [
                                    CustomContainer(
                                        border: false,
                                        color: Color(0xFFDEE8FF),
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                        child: Text('Earn Up To ${data.franchiseDetails.commission}', style: TextStyle(fontSize: 10,color: CustomColor.blackColor),)),

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

                              ],
                            ),
                            10.height,


                            GridView.builder(
                              itemCount: data.keyValues.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                  childAspectRatio: 1/0.25
                              ),
                              itemBuilder: (context, index) {
                                final list = data.keyValues[index];
                                return Row(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // if(list.icon != null)
                                    //   Image.network(list.icon.toString(),height: 18,),
                                    if (list.icon != null && list.icon!.isNotEmpty)
                                      Image.network(
                                        list.icon!,
                                        height: 18,
                                        width: 18,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const SizedBox(
                                            height: 18,
                                            width: 18,
                                          );
                                        },
                                      ),


                                    Column(
                                      children: [
                                        if(list.key != null)
                                          Text(list.key.toString(), style: TextStyle(fontSize: 12),),

                                        if(list.value != null)
                                          Text(list.value, style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                      ],
                                    )
                                  ],
                                );
                              },)
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FinanceServiceDetailsScreen(
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

        if (state is FinancePopularServiceError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
