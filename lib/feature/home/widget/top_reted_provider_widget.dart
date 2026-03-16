import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../../provider/screen/provider__details_screen.dart';
import '../bloc/top_rated_provider/top_rated_provider_bloc.dart';
import '../bloc/top_rated_provider/top_rated_provider_state.dart';

class TopRatedProviderPage extends StatelessWidget {
  const TopRatedProviderPage({super.key});

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return BlocBuilder<TopRatedProviderBloc, TopRatedProviderState>(
      builder: (context, state) {

        if (state is TopRatedProviderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TopRatedProviderLoaded) {
          return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0,left: 10),
                child: Text('Top Rated Provider',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
              ),
              SizedBox(
                height: dimensions.screenHeight*0.4,
                child: ListView.builder(
                  itemCount: state.providers.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    final data = state.providers[index];

                    return
                    CustomContainer(
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
                                      child: Center(child: Text('${data.storeInfo.module.name}', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)),
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
                                            child: (data.storeInfo.logo != null &&
                                                data.storeInfo.logo.isNotEmpty &&
                                                Uri.tryParse(data.storeInfo.logo)?.hasAbsolutePath == true)
                                                ? ClipOval(
                                              child: Image.network(
                                                data.storeInfo.logo,
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
                                              Text(data.storeInfo.storeName,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "we provide you the best kitchen service",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              const SizedBox(height: 6),

                                              Row(
                                                children: [
                                                  Expanded(child: _infoRow(Icons.call, data.storeInfo.storePhone)),
                                                  Expanded(child: _infoRow(Icons.email, data.storeInfo.storeEmail)),
                                                  20.width
                                                ],
                                              ),
                                              _infoRow(
                                                Icons.location_on, data.storeInfo.address,
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
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: List.generate(
                                              data.categoryList.length,
                                                  (index) {
                                                return _Chip(text: data.categoryList[index]);
                                              },
                                            ),
                                          ),
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
                                            Text("${data.storeInfo.totalExperience} Years - Working Experience", style: TextStyle(fontSize: 12)),
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
                                      children: List.generate(data.storeInfo.tags.length,  (index) {
                                        final tag = data.storeInfo.tags[index];
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
                          storeName: data.storeInfo.storeName,
                          providerId: data.id,
                        ),));
                      },
                    );
                  },),
              ),
            ],
          );
        }

        if (state is TopRatedProviderError) {
          debugPrint('Top Rated Provider Error ${state.message}');
          return SizedBox.shrink();
        }

        return const SizedBox();
      },
    );
  }
  /// 🔹 Small info row
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