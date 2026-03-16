import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../../../core/widgets/custom_search_icon.dart';
import '../../../core/widgets/shimmer_box.dart';
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
import '../../service/bloc/service/service_bloc.dart';
import '../../service/bloc/service/service_event.dart';
import '../../service/bloc/service/service_state.dart';
import '../../service/repository/service_repository.dart';


class SearchScreen extends StatefulWidget {
  final String moduleId;
  const SearchScreen({super.key, required this.moduleId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 10,),
      body: Column(
        children: [
          // 🔍 Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Hero(
                    tag: "searchBarHero",
                    child: Material(
                      color: Colors.transparent,
                      child: CustomContainer(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.screenWidth * 0.030,
                          vertical: dimensions.screenHeight * 0.01,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'Search here...',
                                  hintStyle: textStyle14(context, fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),
                            CustomSearchIcon(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                10.width,
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
              ],
            ),
          ),

          BlocProvider(
        create: (_) => ServiceBloc(ServiceRepository())..add(GetServices()),
            child: BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                if (state is ServiceLoading) {
                  return _ShimmerList();
                } else if (state is ServiceLoaded) {

                  final filteredByModule = (widget.moduleId.isEmpty) ? state.services
                      : state.services.where((service) =>
                     service.category.module == widget.moduleId).toList();

                  final services = filteredByModule.where((service) {
                    return service.serviceName.toLowerCase().contains(searchQuery);
                  }).toList();



                  if (services.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(CustomImage.emptyCart, height: 80),
                        const Text('No Service')
                      ],
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final data = services[index];

                        return CustomContainer(
                          border: false,
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(top: 10),
                          gradient: LinearGradient(
                              begin: AlignmentGeometry.topCenter,
                              end: AlignmentGeometry.bottomCenter,
                              colors: [
                                Colors.white,
                                Color(0xFFD8E0F0).withOpacity(0.6),
                              ]),
                          onTap: () {
                            switch (data.category!.module) {
                              case "68b2caf72ff3f8a31bf7bb8f":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FranchiseServiceDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              case "6822dfd5e8235364b35df1a2":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MarketingDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              case "6822dfbce8235364b35df19f":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BusinessServiceDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              case "6822dfd5e8235364b35df1a2":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EducationServiceDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              case "6822dfefe8235364b35df1a5":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LegalServiceDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              case "6822e003e8235364b35df1a8":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FinanceServiceDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              case "6822e075e8235364b35df1b4":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AiHubServiceDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              case "6822e018e8235364b35df1ab":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ItServiceDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              case "6822e05ee8235364b35df1b1":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OnDemandServiceDetailsScreen(
                                      serviceId: data.id,
                                      serviceName: data.serviceName,
                                    ),
                                  ),
                                );
                                break;

                              default:
                                showCustomSnackBar(context,'Module not supported');
                            }
                          },
                          child: Column(
                            children: [
                              CustomNetworkImage(
                                height: dimensions.screenHeight * 0.18,
                                margin: EdgeInsets.zero,
                                imageUrl: data.thumbnailImage,
                                fit: BoxFit.fill,
                                borderRadius: BorderRadius.circular(10),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomContainer(
                                        color: Colors.white,
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.all(5),
                                        child: Icon(Icons.verified_user_outlined, size: 14,color: CustomColor.appColor,),),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FavoriteServiceButtonWidget(serviceId: data.id,),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  10.height,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          spacing: 5,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data.serviceName, style: TextStyle(fontWeight: FontWeight.w600),overflow: TextOverflow.clip, maxLines: 2,),
                                            CustomContainer(
                                              color: CustomColor.appColor,
                                              margin: EdgeInsets.zero,
                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                              child: Text('Earn Up To ${data.franchiseDetails.commission}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.white),),),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        spacing: 5,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
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
                                          Row(
                                            spacing: 5,
                                            children: [
                                              Icon(Icons.account_circle_outlined, size: 12,color: Colors.grey.shade600,),
                                              Text('${data.totalReviews}+ Reviews', style: TextStyle(fontSize: 10, color: Colors.grey.shade600),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              10.height,

                              if(['6822e02de8235364b35df1ae', '6822e075e8235364b35df1b4', '6822dfd5e8235364b35df1a2', '6822dfefe8235364b35df1a5', '6822e018e8235364b35df1ab','6822e05ee8235364b35df1b1'].contains(data.category.module))
                                CustomContainer(
                                  color: Colors.white,
                                  margin: EdgeInsets.zero,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(data.keyValues.length, (index) {
                                          final keyValue = data.keyValues[index];
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

                                      if(data.serviceDetails.packages.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          CustomContainer(
                                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                              margin: EdgeInsets.zero,
                                              color: Colors.green.shade500,
                                              child: Text('${data.serviceDetails.packages.first.discount.toStringAsFixed(0)}% Off', style: TextStyle(fontSize: 10,color: Colors.white, fontWeight: FontWeight.w500),)),
                                          Row(
                                            spacing: 5,
                                            children: [
                                              CustomAmountText(amount: '${data.serviceDetails.packages.first.price.toStringAsFixed(0)}',color: Colors.grey.shade700,isLineThrough: true),
                                              CustomAmountText(amount: '${data.serviceDetails.packages.first.discountedPrice.toStringAsFixed(0)}',fontSize: 18,fontWeight: FontWeight.w500),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),

                              if(['6822e003e8235364b35df1a8',].contains(data.category.module))
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

                              if(['6822dfbce8235364b35df19f','68b2caf72ff3f8a31bf7bb8f'].contains(data.category.module))
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if(data.franchiseDetails.investmentRange.isNotEmpty)
                                      _InfoColumn(title: 'Investment', value: '${data.franchiseDetails.investmentRange.first.range.toString()} ${data.franchiseDetails.investmentRange.first.parameters.toString()}'),
                                      if(data.franchiseDetails.investmentRange.isNotEmpty)
                                      Container(color: Colors.grey,width: 1,height: 35,),

                                      if(data.franchiseDetails.monthlyEarnPotential.isNotEmpty)
                                      _InfoColumn(title: 'Earnings', value: '${data.franchiseDetails.monthlyEarnPotential.first.range.toString()} ${data.franchiseDetails.monthlyEarnPotential.first.parameters.toString()}'),

                                      if( data.serviceDetails.roi.isNotEmpty)
                                      Container(color: Colors.grey,width: 1,height: 35,),

                                      if( data.serviceDetails.roi.isNotEmpty)
                                      _InfoColumn(title: 'ROI', value: data.serviceDetails.roi.first),

                                      if(data.franchiseDetails.areaRequired.isNotEmpty)
                                        Container(color: Colors.grey,width: 1,height: 35,),

                                      if(data.franchiseDetails.areaRequired.isNotEmpty)
                                        _InfoColumn(title: 'Area Required', value: data.franchiseDetails.areaRequired),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is ServiceError) {
                  return Center(child: Text('No Service'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}


Widget _ShimmerList(){
  return Expanded(
    child: ListView(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      children: List.generate(5, (index) => CustomContainer(
        height: 200,
        margin: EdgeInsetsGeometry.only(top: 10),
        child:  Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShimmerBox(height: 10, width: 200),
              10.height,
              Row(
                children: [
                  ShimmerBox(height: 10, width:50),
                  10.width,
                  ShimmerBox(height: 10, width: 50),
                ],
              )
            ],
          ),
        ),
      ),),
    ),
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