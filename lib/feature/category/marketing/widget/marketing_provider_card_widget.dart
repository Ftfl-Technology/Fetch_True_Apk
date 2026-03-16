import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/favorite/widget/favorite_provider_button_widget.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../address/address_notifier.dart';
import '../../../module/bloc/module_bloc.dart';
import '../../../module/bloc/module_event.dart';
import '../../../module/bloc/module_state.dart';
import '../../../module/model/module_model.dart';
import '../../../module/repository/module_repository.dart';
import '../../../provider/bloc/provider/provider_bloc.dart';
import '../../../provider/bloc/provider/provider_event.dart';
import '../../../provider/bloc/provider/provider_state.dart';
import '../../../provider/repository/provider_repository.dart';
import '../../ondemand/bloc/on_demand_recommended_provider/on_demand_recommended_provider_bloc.dart';
import '../../ondemand/bloc/on_demand_recommended_provider/on_demand_recommended_provider_event.dart';
import '../../ondemand/bloc/on_demand_recommended_provider/on_demand_recommended_provider_state.dart';
import '../../ondemand/repository/on_demand_recommended_provider_repository.dart';

class MarketingProviderCard extends StatelessWidget {
   final String moduleId;
  const MarketingProviderCard({super.key, required this.moduleId,});

  @override
  Widget build(BuildContext context) {

    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;

    print(lat);
    print(lng);

    if (lat == null || lng == null) {
      return SizedBox.shrink();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnDemandRecommendedProviderBloc(OnDemandRecommendedProviderRepository())..add(
            FetchOnDemandRecommendedProviders(
              moduleId: moduleId,
              lat: lat??0.0,
              lng: lng??0.0,))),
      ],
      child: BlocBuilder<OnDemandRecommendedProviderBloc, OnDemandRecommendedProviderState>(
        builder: (context, state) {
          if (state is OnDemandRecommendedProviderLoading) {
            return SizedBox.shrink();
          }

          if (state is OnDemandRecommendedProviderLoaded) {
            final recommendedList = state.data.data;

            if(recommendedList.isEmpty){
              return SizedBox.shrink();
            }

            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Suggested Provider', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  ),
                  10.height,
                  Column(
                    children: List.generate(recommendedList.length, (index) {
                      final provider = recommendedList[index];

                      return CustomContainer(
                          color: Colors.white,
                          border: true,
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF7FAFE)
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: CustomColor.marketing.withOpacity(0.1),
                                          backgroundImage: NetworkImage(provider.storeInfo!.logo.toString()), // replace with NetworkImage if needed
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(provider.storeInfo!.storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                              const SizedBox(height: 2),
                                              Text('Data-driven marketing to increase your conversions.', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.phone, size: 14, color: Colors.blue),
                                                  const SizedBox(width: 4),
                                                  Text(provider.storeInfo!.storePhone, style: const TextStyle(fontSize: 12)),
                                                  const SizedBox(width: 10),
                                                  const Icon(Icons.email, size: 14, color: Colors.blue),
                                                  const SizedBox(width: 4),
                                                  Expanded(child: Text(provider.storeInfo!.storeEmail, style: const TextStyle(fontSize: 12))),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        FavoriteProviderButtonWidget(providerId: provider.id)
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    /// Address
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 14, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Expanded(child: Text(provider.storeInfo!.address, style: const TextStyle(fontSize: 12))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Services
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Services Category -", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.grey.shade700)),
                                        CustomContainer(color: CustomColor.greenColor,
                                            margin: EdgeInsets.zero,
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                            child: Text(
                                              provider.isStoreOpen ? "Available" : "Close",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: provider.isStoreOpen
                                                    ? Colors.white
                                                    : Colors.grey.shade700,
                                              ),
                                            ))
                                      ],
                                    ),
                                    5.height,
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: List.generate(
                                        provider.categoryList.length,
                                            (index) {
                                          return _Chip(text: provider.categoryList[index]);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    Text('About Service', style: TextStyle(fontSize: 12,color: Colors.grey.shade700,fontWeight: FontWeight.w600),),
                                    Column(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          spacing: 5,
                                          children: [
                                            Icon(Icons.timer_outlined,size: 12,color: CustomColor.marketing,),
                                            Text("${provider.storeInfo.totalExperience} Years - Working Experience", style: TextStyle(fontSize: 12),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star, size: 14, color: Colors.orange),
                                            SizedBox(width: 4),
                                            Text("${provider.averageRating} Rating", style: TextStyle(fontSize: 12)),
                                            SizedBox(width: 4),
                                            Text("- by ${provider.totalReviews} reviewed",
                                                style: TextStyle(fontSize: 11, color: Colors.grey)),
                                          ],
                                        )

                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Key Features-', style: TextStyle(fontSize: 12,color: Colors.grey.shade700,fontWeight: FontWeight.w600),),
                                        5.height,
                                        Wrap(
                                          spacing: 16,
                                          runSpacing: 8,
                                          children: List.generate(provider.storeInfo.tags.length,  (index) {
                                            final tag = provider.storeInfo.tags[index];
                                            return _Detail(text: "${tag}");
                                          },),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: provider.id,storeName: provider.storeInfo!.storeName,),));
                          }
                      );
                    },),
                  )
                ],
              ),
            );
          }

          if (state is OnDemandRecommendedProviderError) {
            print('Recommended provider error ${state.message}');
            return SizedBox.shrink();
          }

          return const SizedBox();
        },
      )
    );
  }
}


class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final String text;
  const _Detail({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style:  TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey.shade700)),
      ],
    );
  }
}

