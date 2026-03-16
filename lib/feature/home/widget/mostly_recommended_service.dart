import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_network_mage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../category/ai_hub/screen/ai_hub_service_details_screen.dart';
import '../../category/business/screen/business_service_details_screen.dart';
import '../../category/education/screen/education_service_details_screen.dart';
import '../../category/finance/screen/finance_service_details_screen.dart';
import '../../category/franchise/screen/franchise_service_details_screen.dart';
import '../../category/it_service/screen/it_service_details_screen.dart';
import '../../category/legal_service/screen/legal_service_details_screen.dart';
import '../../category/marketing/screen/marketing_details_screen.dart';
import '../../category/ondemand/screen/on_demand_service_details_screen.dart';
import '../../favorite/widget/favorite_service_button_widget.dart';
import '../bloc/mostly_recommended/mostly_recommended_bloc.dart';
import '../bloc/mostly_recommended/mostly_recommended_state.dart';
import 'package:flutter/material.dart';


class MostlyRecommendedService extends StatelessWidget {
  const MostlyRecommendedService({super.key});

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return BlocBuilder<MostlyRecommendedBloc, MostlyRecommendedState>(
      builder: (context, state) {

        if (state is MostlyRecommendedLoading) {
          return  SizedBox.shrink();
        }

        if (state is MostlyRecommendedLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.03),
                child: Text('Recommended for you', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              ),
              SizedBox(
                height: dimensions.screenHeight*0.345,
                child: ListView.builder(
                  itemCount: state.services.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    final data = state.services[index];

                   return  CustomContainer(
                     color: Color(0xFFD8E0F0).withOpacity(0.6),
                     width: dimensions.screenWidth*0.9,
                     child: Column(
                       children: [
                         Expanded(child: CustomNetworkImage(
                             borderRadius: BorderRadius.circular(10),
                             imageUrl: data.service.thumbnailImage,
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
                                           child: FavoriteServiceButtonWidget(serviceId: data.id,)),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                         ),
                         ),

                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Expanded(child: Text('${data.service.serviceName}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),)),
                                   CustomContainer(
                                       color: Colors.green.shade100,
                                       margin: EdgeInsets.zero,
                                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                       child:
                                       Text('Earn Up To ${data.franchiseDetails.commission}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400, color: Colors.black),)),
                                 ],
                               ),
                               10.height,

                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Row(
                                     spacing: 10,
                                     crossAxisAlignment: CrossAxisAlignment.end,
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       CustomContainer(
                                           color: CustomColor.appColor,
                                           margin: EdgeInsets.zero,
                                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                                           child: Text('${data.service.category.module.name}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: Colors.white),),
                                       ),
                                       Text(data.service.category.name, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: Colors.grey.shade700),)
                                     ],
                                   ),

                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.end,
                                     children: [
                                       Row(
                                         spacing: 4,
                                         children: List.generate(5, (index) {
                                           final rating = data.service.averageRating; // e.g. 3.5

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
                                            Icon(Icons.account_circle_outlined, size: 12,color: Colors.grey.shade700,),
                                           Text(
                                             '${data.service.totalReviews}+ Reviews',
                                             style:  TextStyle(fontSize: 10,color: Colors.grey.shade700),
                                           ),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ),

                         if(['6822e02de8235364b35df1ae', '6822e075e8235364b35df1b4', '6822dfd5e8235364b35df1a2', '6822dfefe8235364b35df1a5', '6822e018e8235364b35df1ab','6822e05ee8235364b35df1b1'].contains(data.service.category.module.id))
                           CustomContainer(
                             color: Colors.white,
                             margin: EdgeInsets.zero,
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: List.generate(data.service.keyValues.length, (index) {
                                     final keyValue = data.service.keyValues[index];
                                     return Row(
                                       spacing: 5,
                                       children: [
                                         if(keyValue.icon.isNotEmpty)
                                           Image.network(keyValue.icon.toString(), height: 10,),
                                         if(keyValue.key.isNotEmpty)
                                           Text(keyValue.key.toString(), style: TextStyle(fontSize: 10),),
                                         if(keyValue.value.isNotEmpty)
                                           Text(keyValue.value,style: TextStyle(fontSize: 10),),
                                       ],
                                     );
                                   },),
                                 ),

                                 if(data.service.packages.isNotEmpty)
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.end,
                                     children: [
                                       CustomContainer(
                                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                           margin: EdgeInsets.zero,
                                           color: Colors.green.shade500,
                                           child: Text('${data.service.packages.first.discount}% Off', style: TextStyle(fontSize: 10,color: Colors.white, fontWeight: FontWeight.w500),)),
                                       Row(
                                         spacing: 5,
                                         children: [
                                           CustomAmountText(amount: '${data.service.packages.first.price.toStringAsFixed(0)}',color: Colors.grey.shade700,isLineThrough: true),
                                           CustomAmountText(amount: '${data.service.packages.first.discountedPrice.toStringAsFixed(0)}',fontSize: 18,fontWeight: FontWeight.w500),
                                         ],
                                       )
                                     ],
                                   )
                               ],
                             ),
                           ),

                         if(['6822e003e8235364b35df1a8',].contains(data.service.category.module.id))
                           GridView.builder(
                             itemCount: data.service.keyValues.length,
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
                               final list = data.service.keyValues[index];
                               return Row(
                                 spacing: 5,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   if (isValidUrl(list.icon))
                                     Image.network(
                                       list.icon!,
                                       height: 18,
                                       errorBuilder: (_, __, ___) => const SizedBox(),
                                     ),


                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       if ((list.key ?? '').trim().isNotEmpty)
                                         Text(
                                           list.key!,
                                           style: const TextStyle(fontSize: 12),
                                         ),

                                       if(list.value != null)
                                         Text(list.value, style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                     ],
                                   )
                                 ],
                               );
                             },),

                         if(['6822dfbce8235364b35df19f','68b2caf72ff3f8a31bf7bb8f'].contains(data.service.category.module.id))
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 if(data.franchiseDetails.investmentRange!.id.isNotEmpty)
                                   _InfoColumn(title: 'Investment', value: '${data.franchiseDetails.investmentRange!.range} ${data.franchiseDetails.investmentRange!.parameters}'),

                                 if(data.franchiseDetails.monthlyEarnPotential!.id.isNotEmpty)
                                 Container(color: Colors.grey,width: 1,height: 35,),

                                 if(data.franchiseDetails.monthlyEarnPotential!.id.isNotEmpty)
                                   _InfoColumn(title: 'Earnings', value: '${data.franchiseDetails.monthlyEarnPotential!.range.toString()} ${data.franchiseDetails.monthlyEarnPotential!.parameters.toString()}'),

                                 if (data.franchiseDetails.areaRequired != null &&
                                     data.franchiseDetails.areaRequired!.isNotEmpty)
                                 Container(color: Colors.grey,width: 1,height: 35,),

                                 if (data.franchiseDetails.areaRequired != null &&
                                     data.franchiseDetails.areaRequired!.isNotEmpty)
                                   _InfoColumn(
                                     title: 'Area Required',
                                     value: data.franchiseDetails.areaRequired!,
                                   ),

                               ],
                             ),
                           ),
                       ],
                     ),
                     onTap: () {
                       switch (data.service.category.module.id) {
                         case "68b2caf72ff3f8a31bf7bb8f":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => FranchiseServiceDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         case "6822dfd5e8235364b35df1a2":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => MarketingDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         case "6822dfbce8235364b35df19f":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => BusinessServiceDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         case "6822dfd5e8235364b35df1a2":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => EducationServiceDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         case "6822dfefe8235364b35df1a5":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => LegalServiceDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         case "6822e003e8235364b35df1a8":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => FinanceServiceDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         case "6822e075e8235364b35df1b4":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => AiHubServiceDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         case "6822e018e8235364b35df1ab":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => ItServiceDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         case "6822e05ee8235364b35df1b1":
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => OnDemandServiceDetailsScreen(
                                 serviceId: data.service.id,
                                 serviceName: data.service.serviceName,
                               ),
                             ),
                           );
                           break;

                         default:
                           showCustomSnackBar(context,'Module not supported');
                       }
                     },
                   );
                  },
                ),
              ),
            ],
          );
        }

        if (state is MostlyRecommendedError) {
          debugPrint('Recommended Error ${state.message}');
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
      Text(amount, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
      5.height,
      Text(des, style: TextStyle(fontSize: 10,color: Colors.grey.shade700),textAlign: TextAlign.center,)
    ],
  );
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

bool isValidUrl(String? url) {
  if (url == null) return false;
  final uri = Uri.tryParse(url);
  return uri != null && uri.hasAbsolutePath && (uri.scheme == 'http' || uri.scheme == 'https');
}