import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/offer/repository/offer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../bloc/offer_bloc.dart';
import '../bloc/offer_event.dart';
import '../bloc/offer_state.dart';
import 'offers_details_screen.dart';

class OfferWidget extends StatefulWidget {
  const OfferWidget({super.key});

  @override
  State<OfferWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return BlocBuilder<OfferBloc, OfferState>(
      builder: (context, state) {
        if (state is OfferLoading) {
           return  SizedBox.shrink();
        }

        if (state is OfferLoaded) {
          final offers = state.offers;
          if (offers.isEmpty) return const SizedBox.shrink();

          return Column(
            children: [
              SizedBox(height: dimensions.screenHeight*0.03,),

              const Text(
                'Todays Best Offer for you',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
               Text(
                'Grab the opportunity & win amazing offer ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),

              15.height,

              SizedBox(
                height: dimensions.screenHeight * 0.22,
                child: CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: offers.length,
                  options: CarouselOptions(
                    height: dimensions.screenHeight * 0.22,
                    viewportFraction: 0.82,
                    enlargeCenterPage: false,
                    padEnds: false,
                    disableCenter: true,
                    autoPlay: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final offer = offers[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F0FE),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      margin: EdgeInsets.only(left: dimensions.screenWidth * 0.03,),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomNetworkImage(
                              imageUrl: offer.thumbnailImage,
                              borderRadius: BorderRadius.circular(10),
                              fit: BoxFit.fill,
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => OffersDetailsScreen(offersFuture: offer),));
                              },
                            ),
                          ),

                        ],
                      ),
                    );
                  },

                ),
              ),
              10.height,

              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    offers.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: _currentIndex == index ? 50 : 25,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? CustomColor.blackColor
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (state is OfferError) {
          debugPrint('❌ Offer Error: ${state.message}');
          return SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }
}