import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../address/address_notifier.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_repository.dart';


class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;

    print(lat);
    print(lng);

    if (lat == null || lng == null) {
      return const Scaffold(
        appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: false,),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders(lat, lng))),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: false,),

        body: SafeArea(
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
                  return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
                }

                if(providerState is ProvidersLoaded){
                  final providers = providerState.providers;
                  // final providers = providerState.providers.where((e) => e.kycCompleted == true && e.subscribedServices.isNotEmpty).toList();

                  if(providers.isEmpty){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 50,color: Colors.grey.shade600,),
                        Center(child: Text('No Provider')),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: providers.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {

                      final data = providers[index];

                      return CustomContainer(
                        border: true,
                        color: Colors.white,
                        width: dimensions.screenHeight*0.4,
                        padding: EdgeInsets.zero,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF7FAFE),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 25,
                                        margin: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.15),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(image: AssetImage('assets/image/provider_module_headline.png'),fit: BoxFit.fill)
                                        ),
                                        child: Center(child: Text('${data.storeInfo!.module!.name}', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)),
                                      ),
                                      10.height,
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.grey.shade200,
                                              child: (data.storeInfo!.logo != null &&
                                                  data.storeInfo!.logo.isNotEmpty &&
                                                  Uri.tryParse(data.storeInfo!.logo)?.hasAbsolutePath == true)
                                                  ? ClipOval(
                                                child: Image.network(
                                                  data.storeInfo!.logo,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) {
                                                    return Icon(Icons.store, size: 30, color: Colors.grey,);
                                                  },
                                                ),
                                              ) :  Icon(Icons.store, size: 30, color: Colors.grey,),
                                            ),
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
                                              style: TextStyle(fontSize: 12),
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

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('About Service', style: TextStyle(fontSize: 12),),
                                      5.height,
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.work_outline, size: 14),
                                              SizedBox(width: 4),
                                              Text("${data.storeInfo!.totalExperience} Years - Working Experience", style: TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.star, size: 14, color: Colors.orange),
                                              SizedBox(width: 4),
                                              Text("${data.averageRating} Rating", style: TextStyle(fontSize: 12)),
                                              SizedBox(width: 4),
                                              Text("- by ${data.totalReviews} reviewed",
                                                  style: TextStyle(fontSize: 11, color: Colors.grey)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Service Details', style: TextStyle(fontSize: 12),),
                                      5.height,
                                      Wrap(
                                        spacing: 16,
                                        runSpacing: 8,
                                        children: List.generate(data.storeInfo!.tags.length,  (index) {
                                          final tag = data.storeInfo!.tags[index];
                                          return _Detail(text: "${tag}");
                                        },),
                                      ),
                                    ],
                                  ),
                                ),
                                10.height,
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
                      );
                    },);
                }

                if (providerState is ProviderError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 50, color: Colors.red),
                        10.height,
                        Text(
                          providerState.message,
                          style: textStyle14(context),
                          textAlign: TextAlign.center,
                        ),
                        10.height,
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProviderBloc>()
                                .add(GetProviders(lat, lng));
                          },
                          child: const Text('Retry'),
                        )
                      ],
                    ),
                  );
                }



                return const SizedBox.shrink();}
            ),
          ),
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