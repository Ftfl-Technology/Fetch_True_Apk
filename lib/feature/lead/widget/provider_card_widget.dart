import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/repository/provider_repository.dart';
import '../../provider/screen/provider__details_screen.dart';

class ProviderCardWidget extends StatelessWidget {
  final String? providerId;
  const ProviderCardWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    if (providerId == null || providerId!.isEmpty) {
      return SizedBox.shrink();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviderById(providerId!))),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProviderBloc, ProviderState>(listener: (context, state) {
            if (state is ProviderError) debugPrint('Provider Error: ${state.message}');
          },),

        ],
        child: Builder(
            builder: (context) {

              final providerState = context.watch<ProviderBloc>().state;

              if(providerState is ProviderLoading){
                return  LinearProgressIndicator(color: CustomColor.appColor,minHeight: 1,);
              }
              if (providerState is ProviderLoaded) {
                final data = providerState.provider;

                if (data == null || data.kycCompleted != true) {
                  return const Center(child: Text("Provider not available"));
                }

                // final categoryList = data.subscribedServices
                //     .map((service) => service.category.name)
                //     .toSet()
                //     .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0,left: 10),
                      child: Text('Selected Provider', style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w600),),
                    ),
                    CustomContainer(
                      border: true,
                      color: Colors.white,

                      padding: EdgeInsets.zero,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF7FAFE),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    )
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// Image
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(data.storeInfo!.logo),),
                                        ),


                                        /// Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data.storeInfo!.storeName,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              if(data.storeInfo?.aboutUs != null)
                                                Text('${data.storeInfo?.aboutUs
                                                }', style: textStyle12(context,fontWeight: FontWeight.w400,color: Colors.grey.shade700),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                              const SizedBox(height: 6),

                                              Row(
                                                children: [
                                                  Expanded(child: _infoRow(Icons.call, data.storeInfo!.storePhone)),
                                                  Expanded(child: _infoRow(Icons.email, data.storeInfo!.storeEmail)),
                                                  20.width
                                                ],
                                              ),
                                              _infoRow(
                                                Icons.location_on, data.storeInfo!.address,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Services Category",
                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                                          ),
                                          10.height,
                                          if (data.subscribedServices.isNotEmpty) ...[

                                            Builder(
                                              builder: (context) {
                                                final seenCategoryIds = <String>{};
                                                final uniqueServices = data.subscribedServices.where((service) {
                                                  final id = service.category?.id;
                                                  if (id != null && !seenCategoryIds.contains(id)) {
                                                    seenCategoryIds.add(id);
                                                    return true;
                                                  }
                                                  return false;
                                                }).toList();

                                                // sirf 4 items show karna
                                                final limitedServices = uniqueServices.take(5).toList();

                                                final children = limitedServices.map((service) {
                                                  return Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                      border: Border.all(color: Colors.grey.shade500,width: 0.3),
                                                    ),
                                                    child: Text(
                                                      '${service.category?.name ?? 'Unknown'}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                                    ),
                                                  );
                                                }).toList();

                                                // agar 4 se jyada items hai to end me [etc] add karo
                                                if (uniqueServices.length > 5) {
                                                  children.add(
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          border: Border.all(color: Colors.grey.shade500,width: 0.3),
                                                        ),
                                                        child:  Text(
                                                          'etc',style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                                        ),
                                                      ));
                                                }

                                                return Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: children,
                                                );
                                              },
                                            )
                                          ]

                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: data.isStoreOpen ? Colors.green : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        data.isStoreOpen ? "Available" : "Close",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: data.isStoreOpen
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Text('About Service', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                              //       5.height,
                              //       Column(
                              //         children: [
                              //           Row(
                              //             children: [
                              //               Icon(Icons.work_outline, size: 14),
                              //               SizedBox(width: 4),
                              //               Text("${data.storeInfo!.totalExperience} Years - Working Experience", style: TextStyle(fontSize: 12)),
                              //             ],
                              //           ),
                              //           Row(
                              //             children: [
                              //               Icon(Icons.star, size: 14, color: Colors.orange),
                              //               SizedBox(width: 4),
                              //               Text("${data.averageRating} Rating", style: TextStyle(fontSize: 12)),
                              //               SizedBox(width: 4),
                              //               Text("- by ${data.totalReviews} reviewed",
                              //                   style: TextStyle(fontSize: 11, color: Colors.grey)),
                              //             ],
                              //           )
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // 10.height,
                              //
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Text('Service Details', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                              //       5.height,
                              //       Wrap(
                              //         spacing: 16,
                              //         runSpacing: 8,
                              //         children: List.generate(data.storeInfo!.tags.length,  (index) {
                              //           final tag = data.storeInfo!.tags[index];
                              //           return _Detail(text: "${tag}");
                              //         },),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // 10.height,
                            ],
                          ),

                          Positioned(
                              top: 10,right: 10,
                              child: FavoriteProviderButtonWidget(providerId: data.id)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(
                          storeName: data.storeInfo!.storeName,
                          providerId: data.id,
                        ),));
                      },
                    )
                  ],
                );

              }
              return const SizedBox.shrink();
            }
        ),
      ),
    );
  }
  static Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blue),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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