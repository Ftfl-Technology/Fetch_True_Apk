import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FinanceCostEfficientServiceWidget extends StatelessWidget {
  final String moduleId;
  const FinanceCostEfficientServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    // return BlocBuilder<ModuleByServiceBloc, ModuleByServiceState>(
    //   builder: (context, state) {
    //     if (state is ModuleByServiceLoading) {
    //       return SizedBox.shrink();
    //     }
    //
    //     if (state is ModuleByServiceLoaded) {
    //       return  Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Padding(
    //             padding:  EdgeInsets.only(
    //                 right: dimensions.screenHeight*0.010,
    //                 left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.020),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text('Cost Efficient', style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),
    //
    //                 Text('View All', style: textStyle12(context, color: CustomColor.finance),)
    //               ],
    //             ),
    //           ),
    //           10.height,
    //           SizedBox(
    //             height: dimensions.screenHeight * 0.314,
    //             child: ListView.builder(
    //               scrollDirection: Axis.horizontal,
    //               itemCount: state.model.data.length,
    //               padding: const EdgeInsets.symmetric(horizontal: 12),
    //               itemBuilder: (context, index) {
    //                 final data = state.model.data[index];
    //
    //                 return SizedBox(
    //                   width: dimensions.screenHeight*0.35,
    //                   child: CustomContainer(
    //                     color: Colors.white,
    //                     border: true,
    //                     padding: const EdgeInsets.all(8),
    //                     margin: EdgeInsets.only(right: 10),
    //                     child: Stack(
    //                       children: [
    //                         Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Expanded(
    //                               child: Container(
    //                                 decoration: BoxDecoration(
    //                                   border: Border.all(color: Colors.grey.shade200),
    //                                   borderRadius: BorderRadius.circular(10),
    //                                 ),
    //                                 child: CustomNetworkImage(
    //                                   imageUrl: data.thumbnailImage,
    //                                   fit: BoxFit.cover,
    //                                   child: Align(
    //                                     alignment: Alignment.topRight,
    //                                     child: FavoriteServiceButtonWidget(serviceId: ''),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             15.height,
    //
    //                             Row(
    //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 Expanded(
    //                                   child: Column(
    //                                     crossAxisAlignment: CrossAxisAlignment.start,
    //                                     children: [
    //                                       Text(data.serviceName, style: TextStyle(fontWeight: FontWeight.w500),),
    //                                       10.height,
    //                                       CustomContainer(
    //                                           border: true,
    //                                           color: Colors.white70,
    //                                           margin: EdgeInsets.zero,
    //                                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    //                                           child: Text(data.category.name, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,color: CustomColor.descriptionColor),)),
    //                                     ],
    //                                   ),
    //                                 ),
    //
    //                                 Column(
    //                                   spacing: 10,
    //                                   children: [
    //                                     CustomContainer(
    //                                         border: true,
    //                                         color: Colors.blue,
    //                                         margin: EdgeInsets.zero,
    //                                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    //                                         child: Text('Earn Up To ${data.franchiseDetails.commission}', style: TextStyle(fontSize: 10,color: CustomColor.whiteColor),)),
    //                                     Row(
    //                                       crossAxisAlignment: CrossAxisAlignment.center,
    //                                       mainAxisAlignment: MainAxisAlignment.center,
    //                                       children: [
    //                                         Icon(Icons.star,color: Colors.amber,size: 18,),
    //                                         Icon(Icons.star,color: Colors.amber,size: 18,),
    //                                         Icon(Icons.star,color: Colors.amber,size: 18,),
    //                                         Icon(Icons.star,color: Colors.amber,size: 18,),
    //                                         Icon(Icons.star,color: Colors.amber,size: 18,),
    //                                       ],
    //                                     ),
    //
    //                                   ],
    //                                 ),
    //
    //                               ],
    //                             ),
    //                             15.height,
    //
    //                             Column(
    //                               spacing: 5,
    //                               children: [
    //                                 Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: [
    //                                     Row(
    //                                       crossAxisAlignment: CrossAxisAlignment.start,
    //                                       spacing: 10,
    //                                       children: [
    //                                         Icon(Icons.currency_rupee,size: 16,),
    //                                         Column(
    //                                           crossAxisAlignment: CrossAxisAlignment.start,
    //                                           children: [
    //                                             Text('Loan Amount',style: TextStyle(fontSize: 12),),
    //                                             Text('Upto 20 Lac',style: TextStyle(fontSize: 12, color: Colors.grey),),
    //                                           ],
    //                                         )
    //                                       ],
    //                                     ),
    //                                     Row(
    //                                       crossAxisAlignment: CrossAxisAlignment.start,
    //                                       spacing: 10,
    //                                       children: [
    //                                         Icon(Icons.timer_outlined,size: 16,),
    //                                         Column(
    //                                           crossAxisAlignment: CrossAxisAlignment.start,
    //                                           children: [
    //                                             Text('Approval Time',style: TextStyle(fontSize: 12),),
    //                                             Text('24 Hours ',style: TextStyle(fontSize: 12, color: Colors.grey),),
    //                                           ],
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 ),
    //                                 Row(
    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                   children: [
    //                                     Row(
    //                                       crossAxisAlignment: CrossAxisAlignment.start,
    //                                       spacing: 10,
    //                                       children: [
    //                                         Icon(Icons.work_outline,size: 16,),
    //                                         Column(
    //                                           crossAxisAlignment: CrossAxisAlignment.start,
    //                                           children: [
    //                                             Text('Duration',style: TextStyle(fontSize: 12),),
    //                                             Text('12-60 Months',style: TextStyle(fontSize: 12, color: Colors.grey),),
    //                                           ],
    //                                         )
    //                                       ],
    //                                     ),
    //                                     Row(
    //                                       crossAxisAlignment: CrossAxisAlignment.start,
    //                                       spacing: 10,
    //                                       children: [
    //                                         Icon(Icons.auto_graph_rounded,size: 16,),
    //                                         Column(
    //                                           crossAxisAlignment: CrossAxisAlignment.start,
    //                                           children: [
    //                                             Text('Interest Rate',style: TextStyle(fontSize: 12),),
    //                                             Text('Starting 10.99%',style: TextStyle(fontSize: 12, color: Colors.grey),),
    //                                           ],
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ],
    //                             ),
    //
    //                           ],
    //                         ),
    //
    //                         Positioned(
    //                           top: 0,
    //                           left: 0,
    //                           child:  CustomContainer(
    //                               border: true,
    //                               color: Colors.green.withOpacity(0.1),
    //                               margin: EdgeInsets.zero,
    //                               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    //                               child: Text('Discount ${data.serviceDetails.packages.first.discount}', style: TextStyle(fontSize: 10,color: CustomColor.blackColor),)),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    //           )
    //         ],
    //       );
    //     }
    //
    //     if (state is ModuleByServiceError) {
    //       return Center(child: Text(state.message));
    //     }
    //
    //     return const SizedBox();
    //   },
    // );
    return SizedBox();
  }
}
