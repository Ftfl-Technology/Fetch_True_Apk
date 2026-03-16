import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../address/address_notifier.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../../module/bloc/module_bloc.dart';
import '../../module/bloc/module_event.dart';
import '../../module/bloc/module_state.dart';
import '../../module/repository/module_repository.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_repository.dart';
import 'package:fetchtrue/feature/module/model/module_model.dart';


class ProviderWidget extends StatelessWidget {
  final String moduleId;
  const ProviderWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders(lat!, lng!))),
        BlocProvider(create: (_) => ModuleBloc(ModuleRepository())..add(GetModules())),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProviderBloc, ProviderState>(listener: (context, state) {
            if (state is ProviderError) debugPrint('Provider Error: ${state.message}');
          },),

          BlocListener<ModuleBloc, ModuleState>(listener: (context, state) {
            if (state is ModuleError) debugPrint('Module Error: ${state.message}');
          },),

        ],
        child: Builder(
            builder: (context) {
              final providerState = context.watch<ProviderBloc>().state;
              final moduleState = context.watch<ModuleBloc>().state;

              if(providerState is ProviderLoading || moduleState is ModuleLoading){
                return  _buildShimmer(dimensions);
              }

              if(providerState is ProvidersLoaded && moduleState is ModuleLoaded){
                final providers = providerState.providers.where((e) => e.kycCompleted == true && e.storeInfo?.module== moduleId && e.subscribedServices.isNotEmpty).toList();
                final modules = moduleState.modules;

                if(providers.isEmpty){
                  return SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: dimensions.screenHeight*0.3,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Container(
                              color: CustomColor.appColor.withOpacity(0.1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  15.height,
                                  Center(child: Text('Service Provider',style: textStyle12(context),)),
                                  Text('Best service provider by Fetch True,',style: TextStyle(color: Colors.grey.shade500),),
                                ],
                              ),
                            )),
                            Expanded(child: Container()),
                          ],
                        ),
                        SizedBox(
                          height:  dimensions.screenHeight*0.22,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(providers.length, (index) {
                                  final provider = providers[index];
                                  ModuleModel? module;
                                  try {
                                    module = modules.firstWhere((m) => m.id == provider.storeInfo?.module);
                                  } catch (e) {
                                    module = null;
                                  }
                                  return Stack(
                                    children: [
                                      CustomContainer(
                                        width: dimensions.screenHeight*0.38,
                                        color: Colors.white,
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    CircleAvatar(
                                                        radius: 30.5,
                                                        backgroundColor: CustomColor.appColor,
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                      backgroundImage: (provider.storeInfo?.logo != null &&
                                                          provider.storeInfo!.logo!.isNotEmpty &&
                                                          Uri.tryParse(provider.storeInfo!.logo!)?.hasAbsolutePath == true)
                                                          ? NetworkImage(provider.storeInfo!.logo!)
                                                          : AssetImage(CustomImage.nullImage) as ImageProvider,
                                                    )),
                                                    5.height,
                                                    Container(
                                                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                                                        decoration: BoxDecoration(
                                                            color: provider.isStoreOpen == true ? CustomColor.greenColor:Colors.grey.shade500,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Text(provider.isStoreOpen == true ?'Open':'Close', style: TextStyle(fontSize: 12, color: CustomColor.whiteColor),))
                                                  ],
                                                ),
                                                10.width,
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(provider.storeInfo!.storeName.toString(),style: textStyle12(context),),
                                                    2.height,
                                                    Text(
                                                      '⭐ ${provider.averageRating} (${provider.totalReviews} Review)',
                                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                                    ),
                                                    Text(module?.name ?? 'Unknown',style: textStyle12(context,fontWeight: FontWeight.w400)),
                                                  ],
                                                )
                                              ],
                                            ),

                                            if (provider.subscribedServices.isNotEmpty) ...[
                                              10.height,
                                              Builder(
                                                builder: (context) {
                                                  final seenCategoryIds = <String>{};
                                                  final uniqueServices = provider.subscribedServices.where((service) {
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
                                        onTap: () {
                                          context.push(
                                            '/provider/${provider.id}?name=${Uri.encodeComponent(provider.storeInfo!.storeName.toString())}',
                                          );
                                        },
                                      ),

                                      Positioned(
                                          top: 10,right: 10,
                                          child: FavoriteProviderButtonWidget(providerId: provider.id.toString(),))
                                    ],
                                  );
                                }, ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();}
        ),
      ),
    );
  }
}



Widget _buildShimmer(Dimensions dimensions){
  return SizedBox(
    height: dimensions.screenHeight*0.3,
    child: Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container(
              width: double.infinity,
              color: CustomColor.whiteColor,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    15.height,
                   ShimmerBox(height: 10, width: dimensions.screenHeight*0.2),
                   10.height,
                   ShimmerBox(height: 10, width: dimensions.screenHeight*0.3),
                  ],
                ),
              ),
            )),

          ],
        ),
        SizedBox(
          height: dimensions.screenHeight*0.22,
          child: ListView.builder(
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CustomContainer(
                margin: EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010, bottom: dimensions.screenHeight*0.010),
                width: dimensions.screenHeight*0.38,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      5.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(radius: 28),
                              5.height,
                              ShimmerBox(height: 15, width: 80)
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerBox(height: 10, width: dimensions.screenHeight*0.10),
                              5.height,
                              ShimmerBox(height: 10, width: dimensions.screenHeight*0.1),
                              5.height,
                              ShimmerBox(height: 10, width: dimensions.screenHeight*0.1),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      5.height,

                      Wrap(
                         spacing: 20,
                         runSpacing: 10,
                        children: List.generate(4, (index) => ShimmerBox(height: 20, width: dimensions.screenHeight*0.09),)
                      ),
                    ],
                  ),
                ),
              );
            },),
        ),
      ],
    ),
  );
}