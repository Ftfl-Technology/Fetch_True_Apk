import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../favorite/widget/favorite_service_button_widget.dart';
import '../bloc/franchise_top_trending_service/franchise_top_trending_service_bloc.dart';
import '../bloc/franchise_top_trending_service/franchise_top_trending_service_state.dart';
import '../model/franchise_top_trending_service_model.dart';
import '../screen/franchise_service_details_screen.dart';

class FranchiseTopTrendingServiceWidget extends StatelessWidget {
  final String moduleId;
  const FranchiseTopTrendingServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<FranchiseTopTrendingServiceBloc, FranchiseTopTrendingServiceState>(
      builder: (context, state) {
        if (state is FranchiseTopTrendingServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is FranchiseTopTrendingServiceLoaded) {

          final services = state.data.data;

          if (services.isEmpty) {
            return SizedBox.shrink();
          }

           return Column(
            children: [
              50.height,
              Text(
                "Top 10 Trending",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Here are our Top Trending franchise for you ",
                style: TextStyle(color: Colors.grey),
              ),

              20.height,

              ListView.builder(
                itemCount: services.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = services[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: FranchiseCardWidget(
                      services: data,
                    ),
                  );
                },
              ),
            ],
          );;
        }

        if (state is FranchiseTopTrendingServiceError) {
          print('Franchise Top Trending Service Error ${state.message}');
          return SizedBox.shrink();
        }

        return const SizedBox();
      },
    );
  }
}


class FranchiseCardWidget extends StatelessWidget {
  final FranchiseTopTrendingServiceData services;
  const FranchiseCardWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey,width: 0.2)
      ),
      child: InkWell(
        child: Column(
          children: [
            /// 🔹 Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Image.network('${services.thumbnailImage}',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  /// Gradient Overlay
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(1),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),

                  /// Top Left Info
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:  [
                        Text(
                          "${services.serviceName}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Row(
                        //   spacing: 10,
                        //   children: List.generate(services.keyValues.length, (index) {
                        //     final list = services.keyValues[index];
                        //     return  Text(
                        //       "${list.key}",
                        //       style: TextStyle(color: Colors.white70),
                        //     );
                        //   },),
                        // ),

                        SizedBox(height: 6),
                        Row(
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 4,
                              children: List.generate(5, (index) {
                                final rating = services.averageRating; // e.g. 3.5

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
                                const Icon(Icons.account_circle_outlined, size: 12,color: Colors.white,),
                                Text(
                                  '${services.totalReviews}+ Reviews',
                                  style: const TextStyle(fontSize: 10,color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children:  [
                            // _InfoChip(
                            //   text: "Discount ${0}%",
                            //   bgColor: Color(0xffE8FFF1),
                            //   textColor: Colors.green,
                            // ),
                            // SizedBox(width: 8),
                            _InfoChip(
                              text: "Earn Up to ${services.franchiseDetails.commission}",
                              bgColor: Color(0xffEAF1FF),
                              textColor: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:Icon(Icons.verified_user_outlined, size: 20,color: Colors.blue.shade700,),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child:Icon(Icons.person),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircleAvatar(
                          backgroundColor: Colors.black38,
                          child: FavoriteServiceButtonWidget(serviceId: services.id)),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 10,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      _StatItem(
                          value: "${services.franchiseDetails.monthlyEarnPotential.first.range} ${services.franchiseDetails.monthlyEarnPotential.first.parameters}", label: "Monthly Earnings"),

                      Container(width:1,height: 35,color: Colors.grey,),
                      _StatItem(
                          value: "${services.franchiseDetails.investmentRange.first.range} - ${services.franchiseDetails.investmentRange.first.range}L",
                          label: "Investment Range"),
                      // Container(width:1,height: 35,color: Colors.grey,),
                      // _StatItem(
                      //     value: "00-00",
                      //     label: "Number Outlet"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseServiceDetailsScreen(
            serviceName: services.serviceName,
            serviceId: services.id,
          ),));
        },
      ),
    );
  }
}
class _InfoChip extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _InfoChip({
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
              fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}